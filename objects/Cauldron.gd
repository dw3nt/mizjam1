extends StaticBody2D

const NO_RECIPE_LOOP_MAX = 2
const RECIPES = [
	# Farmers
	{
		"ingredients": ["BonesAndSkull", "FarmerHat", "Staff"],
		"scene": preload("res://people/FarmerMinion1.tscn")
	},

	# Monks
	{
		"ingredients": ["BonesAndSkull", "HoodedRobe", "Gloves"],
		"scene": preload("res://people/MonkMinion1.tscn")
	},
	{
		"ingredients": ["BonesAndSkull", "HoodedRobe", "Staff"],
		"scene": preload("res://people/MonkMinion2.tscn")
	},
	{
		"ingredients": ["BonesAndSkull", "Hood", "Gloves"],
		"scene": preload("res://people/MonkMinion3.tscn")
	},
	{
		"ingredients": ["BonesAndSkull", "Hood", "Staff"],
		"scene": preload("res://people/MonkMinion4.tscn")
	},
	{
		"ingredients": ["BonesAndSkull", "HoodedRobe", "Boots"],
		"scene": preload("res://people/MonkMinion5.tscn")
	},
	{
		"ingredients": ["BonesAndSkull", "Hood", "Boots"],
		"scene": preload("res://people/MonkMinion6.tscn")
	},

	# Soliders
	{
		"ingredients": ["BonesAndSkull", "Belt", "Spear"],
		"scene": preload("res://people/SoliderMinion1.tscn")
	},
	{
		"ingredients": ["BonesAndSkull", "Sword", "Shield"],
		"scene": preload("res://people/SoliderMinion2.tscn")
	},
	{
		"ingredients": ["BonesAndSkull", "Gloves", "Boots"],
		"scene": preload("res://people/SoliderMinion3.tscn")
	},
	{
		"ingredients": ["BonesAndSkull", "Belt", "Gloves"],
		"scene": preload("res://people/SoliderMinion4.tscn")
	},
	{
		"ingredients": ["BonesAndSkull", "Belt", "Boots"],
		"scene": preload("res://people/SoliderMinion5.tscn")
	},
	{
		"ingredients": ["BonesAndSkull", "Belt", "Sword"],
		"scene": preload("res://people/SoliderMinion6.tscn")
	},

	# Knights
	{
		"ingredients": ["Helmet", "Sword", "Shield"],
		"scene": preload("res://people/KnightMinion1.tscn")
	},
	{
		"ingredients": ["Helmet", "Spear", "Shield"],
		"scene": preload("res://people/KnightMinion2.tscn")
	},
	{
		"ingredients": ["Helmet", "Belt", "Boots"],
		"scene": preload("res://people/KnightMinion3.tscn")
	},
	{
		"ingredients": ["Helmet", "Boots", "Gloves"],
		"scene": preload("res://people/KnightMinion4.tscn")
	},
	{
		"ingredients": ["Helmet", "Belt", "Gloves"],
		"scene": preload("res://people/KnightMinion5.tscn")
	},


	# Monsters
	{
		"ingredients": ["BonesAndSkull", "Bone", "HumanSkull"],
		"scene": preload("res://people/MonsterMinion1.tscn")
	},
	{
		"ingredients": ["MonsterSkull", "Hood", "Gloves"],
		"scene": preload("res://people/MonsterMinion2.tscn")
	},
	{
		"ingredients": ["MonsterSkull", "Hood", "Boots"],
		"scene": preload("res://people/MonsterMinion2.tscn")
	},
	{
		"ingredients": ["MonsterSkull", "Gloves", "Boots"],
		"scene": preload("res://people/MonsterMinion3.tscn")
	},
	{
		"ingredients": ["MonsterSkull", "Belt", "Gloves"],
		"scene": preload("res://people/MonsterMinion4.tscn")
	},
	{
		"ingredients": ["MonsterSkull", "Boots", "Belt"],
		"scene": preload("res://people/MonsterMinion4.tscn")
	},
	{
		"ingredients": ["MonsterSkull", "Belt", "Spear"],
		"scene": preload("res://people/MonsterMinion5.tscn")
	},
	{
		"ingredients": ["MonsterSkull", "Sword", "Shield"],
		"scene": preload("res://people/MonsterMinion6.tscn")
	},
	{
		"ingredients": ["MonsterSkull", "FarmerHat", "Staff"],
		"scene": preload("res://people/MonsterMinion7.tscn")
	},
]

export(NodePath) var minionWrapPath

var noRecipeLoops = 0
var itemsHeld = []

onready var sprite = $Sprite
onready var itemsHeldWrap = $ItemsHeld
onready var spawnPoint = $SpawnPoint
onready var animation = $AnimationPlayer
onready var minionWrap = get_node(minionWrapPath)


func handleHitboxHit(hitter, damage):
	if itemsHeld.size() < 3:
		var type = getSimpleFileName(hitter)
		if itemsHeld.find(type) < 0:
			itemsHeld.append(type)
			var playerHand = hitter.get_parent()
			playerHand.item = null

			var item = hitter.duplicate()
			hitter.queue_free()
			
			item.position = Vector2.ZERO
			item.isGrabable = false
			itemsHeldWrap.get_child(itemsHeld.size() - 1).add_child(item)
			item.sprite.position = Vector2.ZERO
		
	if itemsHeld.size() >= 3:
		var sortedItems = itemsHeld.duplicate()
		sortedItems.sort()
		var itemCreated = false
		for key in range(RECIPES.size()):
			var orderedRecipe = RECIPES[key]["ingredients"].duplicate()
			orderedRecipe.sort()
			if arraysMatch(sortedItems, orderedRecipe):
				var inst = RECIPES[key]["scene"].instance()
				inst.global_position = spawnPoint.global_position
				minionWrap.add_child(inst)
				itemCreated = true
				
		if !itemCreated:
			animation.play("no_recipe")
		else:
			emptyCauldron(true)


func arraysMatch(arr1, arr2):
	if arr1.size() != arr2.size():
		return false

	for key in range(arr2.size()):
		if arr1[key] != arr2[key]:
			return false
	
	return true
		

func getSimpleFileName(obj):
	var filename = obj.filename
	var startPos = filename.find_last("/")
	if startPos >= 0:
		startPos += 1
		var endPos = filename.find(".tscn", startPos)
		if endPos >= 0:
			return filename.substr(startPos, endPos - startPos)

	return ""


func emptyCauldron(isItemsUsed):
	for key in range(itemsHeld.size()):
		var item = itemsHeldWrap.get_child(key).get_child(0)
		if !isItemsUsed:
			var _item = item.duplicate()
			_item.global_position = item.global_position
			_item.global_position.y += 20
			get_parent().add_child(_item)

		item.queue_free()

	itemsHeld = []


func countNoRecipeLoop():
	noRecipeLoops += 1
	if noRecipeLoops >= NO_RECIPE_LOOP_MAX:
		animation.stop()
		noRecipeLoops = 0
		emptyCauldron(false)
