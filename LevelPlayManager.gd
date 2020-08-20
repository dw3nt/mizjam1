extends Node2D

const CAULDRON_SCENE = preload("res://objects/Cauldron.tscn")

var roomOriginsUsed = []

onready var goal = $Goal
onready var ui = $UI
onready var roomsWrap = $Rooms
onready var roomOriginsWrap = $RoomOrigins
onready var cauldronsWrap = $Cauldrons
onready var cauldronLayoutsWrap = $CauldronLayouts
onready var minionWrap = $Minions


func _ready():
	randomize()

	for i in range(goal.hp):
		ui.addTownHp()

	goal.connect("updated_hp", self, "_on_Goal_updated_hp")
	goal.connect("game_over", self, "_on_Goal_game_over")

	buildRooms()
	buildCauldrons()


func _unhandled_input(event):
	if event is InputEventKey:
		if event.is_pressed() && !event.is_echo():
			if Input.is_key_pressed(KEY_R):
				get_tree().reload_current_scene()


func buildRooms():
	for room in roomsWrap.get_children():
		var originOffset = randi() % roomOriginsWrap.get_child_count()
		while roomOriginsUsed.has(originOffset):
			originOffset = randi() % roomOriginsWrap.get_child_count()

		room.position = roomOriginsWrap.get_child(originOffset).position
		roomOriginsUsed.append(originOffset)


func buildCauldrons():
	var layout = cauldronLayoutsWrap.get_child(randi() % cauldronLayoutsWrap.get_child_count())
	for origin in layout.get_children():
		var inst = CAULDRON_SCENE.instance()
		inst.minionWrapPath = minionWrap.get_path()
		inst.position = origin.position
		cauldronsWrap.add_child(inst)


func _on_Goal_updated_hp(diff):
	if diff < 0:
		ui.removeTownHp()
	else:
		ui.addTownHp()


func _on_Goal_game_over():
	get_tree().change_scene("res://menus/GameOver.tscn")
