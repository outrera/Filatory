""" MoveContainer.gd

	Contains all information related to a move.
"""
""" MOVE TO CLASS CONTAINING THIS
#var moveOwner #Entity who owns move.
#var target = null #target object / list of target objects
#var cost #How much the move costs to use (1 turn, 2 actions, 30 action points...)
"""
extends Node

#Timer System Vars
enum types {HOLD, PRESS, TAP, NOINPUT}
var sequence = [] #Sequence of actions, in order of execution
var returnArr = []
var active = false
var activeAction = null
var condition = false
var previous = [] #previos button array
var hold #bool if button held down 
var holdtotal #total value of time held down
var taps
var exec
var timer

class Action: #lawsuit
	var button = [] #button to be pressed. Plural buttons ar for hold (silmultaneous) or tap (in order in array)
	var timer #How much time to complete action in seconds
	var passable #If this button press is failed, abort. Good for allowing button presses when not specifically asking for buttons
	var type #Hold, press, tap, no press, etc. Refer to ENUM types
	func _init(b,t,nType,p):
		button = b
		timer = t
		passable = p
		self.type = nType

func _ready():
	#AddAction([], 3, types.NOINPUT, true)
	AddAction(["ui_up","ui_down"], 10, types.HOLD, false)
	#AddAction(["ui_down"], 1, types.PRESS, false)
	run()

func _process(delta):
	if active:
		if !exec.empty() or !activeAction == null:
			#Set up initial conditions depending on the button type
			if activeAction == null:
				activeAction = exec.pop_front()
				timer = activeAction.timer
				if activeAction.type == types.NOINPUT:
					condition = true
				elif activeAction.type == types.HOLD:
					condition = true
					holdtotal = 0
				else:
					condition = false
			#Check if the timer has ended
			if timer <= 0:
				#Dump all further actions from exec to stop the move.
				if condition == false and activeAction.passable == false:
					exec.clear()
				match activeAction.type:
					types.PRESS:
						var tempData = Vector2(condition, 0)
						returnArr.append(tempData)
						activeAction = null
					types.HOLD:
						var tempData = Vector2(condition, holdtotal)
						returnArr.append(tempData)
						activeAction = null
					types.TAP:
						var tempData = Vector2(condition, taps)
						returnArr.append(tempData)
						activeAction = null
					types.NOINPUT:
						var tempData = Vector2(condition, 0)
						returnArr.append(tempData)
						activeAction = null
			else:
				#add some value to hold, keepd pace with # of seconds held down
				if activeAction.type == types.HOLD and hold == true:
					holdtotal += delta
				#Reduce timer
				timer -= delta
		else:
			#Set active to false, tell system that results are ready
			active = false

func _input(event):
	#Only handle inputs if the sequence and timers have started
	if active and activeAction != null:
		#Handle each type of QTE properly
		match activeAction.type:
			types.PRESS:
				#Make sure You're pressing the right key and not just getting the last key you let go of.
				if event is InputEventKey and not event.is_echo():
					var skip = false
					for i in previous:
						if Input.is_action_just_released(i):
							skip = true
					if !skip:
						timer = 0 #instantly move on to next item in sequence
					if Input.is_action_just_pressed(activeAction.button[0]):
						previous = activeAction.button
						condition = true
			types.HOLD:
				var buttonsPressed = 0
				#loop through button list to see how many are being held
				for i in activeAction.button:
					if Input.is_action_just_released(i):
						buttonsPressed -= 1
						#Set timer to 0 to stop the sequence if not passable only on release to avoid failing instantly since no buttons are pressed
						if activeAction.passable == false:
							timer = 0
					if Input.is_action_pressed(i):
						buttonsPressed += 1
				#Check if all the buttons are being pressed. If so, allow _process to add delta to % completed
				if buttonsPressed == activeAction.button.size() and event.is_echo():
					hold = true
					condition = true
				else:
					hold = false
					condition = false #set condition here so any state other than "held down" returs false.
				previous = activeAction.button
			types.TAP:
				if Input.is_action_just_pressed(activeAction.button[0]):
					taps += 1
					condition = true
				previous = activeAction.button
			types.NOINPUT:
				#FIXME: Keyboard only: Switch for different control schemes
				if event is InputEventKey and not event.is_echo():
					var skip = false
					for i in previous:
						if Input.is_action_just_released(i):
							skip = true
					if !skip:
						#Set timer to 0 to stop the sequence if not passable
						if activeAction.passable == false:
							timer = 0
							condition = false

func AddAction(b,t,nType,p):
	#check if actions are mapped
	for i in b:
		if !InputMap.has_action(i):
			print("Malformed AddAction button: " + str(i) + ". Does Not exist?")
			return false
	#Ensure that the timer is positive
	if typeof(t) != TYPE_INT and t <= 0:
		print("Malformed AddAction timer: " + str(t) + ". Must be INT > 0")
		return false
	#Verify type
	if !(nType in types.values()):
		print("Malformed AddAction type: " + str(nType) + ". Must be a defined type")
		return false
	#Check passable
	if typeof(p) != TYPE_BOOL:
		print("Malformed AddAction timer: " + str(p) + ". Must be BOOL.")
		return false
	var a = Action.new(b,t,nType,p)
	self.sequence.append(a)

func run():
	#Reset things to initial state
	returnArr.clear()
	previous.clear()
	activeAction = null
	hold = false
	taps = 0
	active = true
	#Copy sequence into exec to allow reuse of the sequence
	exec = sequence
