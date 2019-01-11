""" Entity.gd

	Base class for all creatures.
"""
extends Node

#Flavor text
var gender

#State vars
var hp
var maxhp

#Stats
var race #could be human, robot, cyborg... elf, dwarf, 
var spd #how fast a combatant springs into combat
var stre #brute strength
var agi #dodge chance, acrobatics things
var aim #ranged accuracy
var cha #Charisma, or how hard it is to dislike entity
var armorRate #How much armor entity has
var equippedArmor #Equipped armor	
var leftHand #Item in left hand
var rightHand #item in right hand

#lists
var movesList = [] #list of all moves known
var itemsDict = {} #dict of all items on person

func _init(n):
	self.name = n


func SetEquipment(item, hand = "right"):
	""" Set equipped item based on item type
	"""
	if item == null: #check if there is an item to add
		return false #No item added
	if item.get_type()=="Weapon":
		if item.handed == 2: #Check if two handed weapon
			leftHand = item
			rightHand = item
			return true
		elif hand == "right":
			rightHand = item
			return true
		elif hand == "left":
			leftHand = item
			return true
		return false #If we get here, item was not assigned
	elif item.get_type()=="Armor":
		#Do a size check
		equippedArmor = item
		armorRate = item.armorRate
		return true
	
	
""" Function for more complex armor models
func UpdateArmor():
	var type = 'Armor'
	var newArmorRate = 0
	for i in equippedDict.keys(): #Once new armor is added or removed, update
		if equippedDict[i].get_type() == type:
			newArmorRate += equippedDict[i].armorRate
	self.armor = newArmorRate
"""








