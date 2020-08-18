extends Node2D

export var damage = 1

var isHeld = false
var isGrabable = true

onready var sprite = $Sprite
onready var hitboxCollision = $Hitbox/CollisionShape2D


func _ready():
	hitboxCollision.disabled = true


func _on_Hitbox_area_entered(area):
	area.handleHitboxHit(self, damage)


func _on_Hitbox_area_exited(area):
	pass


func _on_Hitbox_body_entered(body):
	body.handleHitboxHit(self, damage)


func _on_Hitbox_body_exited(body):
	pass
