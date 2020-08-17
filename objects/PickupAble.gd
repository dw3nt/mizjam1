extends Node2D

var isHeld = false

onready var sprite = $Sprite
onready var hitboxCollision = $Hitbox/CollisionShape2D


func _ready():
	hitboxCollision.disabled = true


func _on_Hitbox_area_entered(area):
	area.handleHitboxHit()


func _on_Hitbox_area_exited(area):
	pass


func _on_Hitbox_body_entered(body):
	body.handleHitboxHit()


func _on_Hitbox_body_exited(body):
	pass