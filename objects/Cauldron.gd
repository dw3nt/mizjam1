extends StaticBody2D

const RECIPES = [
	{
		"ingredients": ["Bones", "MageCloak", "MageStaff"],
		"scene": preload("res://people/MageMinion.tscn")
	}
]

export(NodePath) var minionWrapPath

var itemsHeld = []

onready var itemsHeldWrap = $ItemsHeld
onready var spawnPoint = $SpawnPoint
onready var minionWrap = get_node(minionWrapPath)


func handleHitboxHit(hitter):
	if itemsHeld.size() < 3:
		var type = getSimpleFileName(hitter)
		if itemsHeld.find(type) < 0:
			itemsHeld.append(type)
			var playerHand = hitter.get_parent()
			playerHand.item = null

			var item = hitter.duplicate()
			hitter.queue_free()
			
			item.position = Vector2.ZERO
			itemsHeldWrap.get_child(itemsHeld.size() - 1).add_child(item)
		
	if itemsHeld.size() >= 3:
		itemsHeld = itemsHeld.sort()
		for key in range(RECIPES.size()):
			if itemsHeld == RECIPES[key]["ingredients"].sort():
				print(RECIPES[key]["scene"])
				var inst = RECIPES[key]["scene"].instance()
				inst.global_position = spawnPoint.global_position
				minionWrap.add_child(inst)
		

func getSimpleFileName(obj):
	var filename = obj.filename
	var startPos = filename.find_last("/")
	if startPos >= 0:
		startPos += 1
		var endPos = filename.find(".tscn", startPos)
		if endPos >= 0:
			return filename.substr(startPos, endPos - startPos)

	return ""
