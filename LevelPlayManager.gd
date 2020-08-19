extends Node2D

onready var goal = $Goal
onready var ui = $UI


func _ready():
	for i in range(goal.hp):
		ui.addTownHp()

	goal.connect("updated_hp", self, "_on_Goal_updated_hp")
	goal.connect("game_over", self, "_on_Goal_game_over")


func _on_Goal_updated_hp(diff):
	if diff < 0:
		ui.removeTownHp()
	else:
		ui.addTownHp()


func _on_Goal_game_over():
	get_tree().change_scene("res://menus/GameOver.tscn")
