""" Item.gd

	Base classes for all items.
"""

#Basic item
class Item extends Node:
	var weight #how heavy an item is
	var desc #description of an item
	var type = "Item"
	var price
	
	func get_type():
		#Returns item type
		return type
	
#All wearables, including armor.
class Armor extends Item:
	var armorRate = 1 #How protective armor is
	var restriction = 0 #How constrictive the armor is
	var size = 1 #How big a entity this item fits
	
	func _init(n):
		type = "Armor"
		self.name = n

#All wieldables, weapons, spatulas...
class Weapons extends Item:
	var baseDamage #Starting damage. Higher is better
	var rang #Range of the weapon. 
	var handed = 1 #how many hands to hold
	
	func _init():
		type = "Weapon"