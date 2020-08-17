extends StaticBody2D

signal game_over
signal updated_hp

export var startHp = 3

var hp = 0 setget setHp


func _ready():
	self.hp = startHp


func setHp(val):
	var diff = val - hp
	hp = val
	emit_signal("updated_hp", diff)


func _on_EnemyDetect_body_entered(body):
	self.hp -= 1
	body.destroy()
	if hp <= 0:
		emit_signal("game_over")
