""" BattleManager.gd
	
	Manages battles, including UI, fighters, turn order, combat/background animations...
"""

extends Node


# StartBattle(): loads battle and starts it running.
# Order fighters by speed + random value
# find first fighter on list
# determine action, AI / player choice
# Execute action
# Check if either side has won: 
# Game over if failure
# Dole out loot/xp,  return to overworld/map/whatever if success
# loop if the fight is ongoing

#AddFighter(entity): adds an entity to the list of figthers.

#SortFighters(): sorts list by speed

#