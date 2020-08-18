extends StaticBody2D

const NO_RECIPE_LOOP_MAX = 2
const RECIPES = [
	{
		"ingredients": ["Bones", "MageCloak", "MageStaff"],
		"scene": preload("res://people/MageMinion.tscn")
	}
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
