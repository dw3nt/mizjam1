extends Node2D

var item = null

onready var sprite = $Sprite


func pickUpItem(_item):
	if item:
		item.isHeld = false
		var itemDupe = item.duplicate()
		item.queue_free()
		get_tree().current_scene.add_child(itemDupe)
		itemDupe.global_position = global_position

	item = _item.duplicate()
	_item.queue_free()

	item.position = Vector2(6, 0)
	item.isHeld = true
	add_child(item)
	item.sprite.z_index = scale.x * -1
