extends KinematicBody2D

const MOVE_SPEED = 50

var hp = 2
var ready = false
var path = [] setget setPath
var nextPathPoint = null
var moveDir = Vector2.ZERO

onready var animation = $AnimationPlayer
onready var sprite = $Sprite


func _ready():
	ready = true
	set_physics_process(false)
	if path.size() > 0:
		enablePathing()
		

func destroy():
	queue_free()


func handleHitboxHit(hitter, damage):
	set_physics_process(false)
	hp -= damage
	animation.play("damaged")


func _physics_process(_delta):
	if !nextPathPoint:
		nextPathPoint = path[0]

	if global_position.distance_to(nextPathPoint) < 4:
		if path.size() > 1:
			nextPathPoint = path[1]

		path.remove(0)

	moveDir = global_position.direction_to(nextPathPoint)
	sprite.flip_h = moveDir.x < 0

	move_and_slide(moveDir * MOVE_SPEED)
	

func enablePathing():
	animation.play("run")
	set_physics_process(true)


func setPath(val):
	path = val
	if val.size() > 0 && ready:
		enablePathing()
		

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "damaged":
		if hp <= 0:
			destroy()
		else:
			enablePathing()


func _on_MinionDetect_body_entered(body):
	set_physics_process(false)
	animation.play("idle")
