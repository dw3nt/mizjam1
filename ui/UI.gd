extends Node

const FIRE_ICON_SCENE = preload("res://ui/FireHpIcon.tscn")

onready var hpWrap = $Control/MarginContainer/TownHpWrap


func removeTownHp():
	var inst = hpWrap.get_child(hpWrap.get_child_count() - 1)
	inst.queue_free()

	
func addTownHp():
	var inst = FIRE_ICON_SCENE.instance()
	hpWrap.add_child(inst)
