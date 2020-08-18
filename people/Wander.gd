extends MinionStateMachine

const MOVE_SPEED = 25
const MOVE_DIRS = [
	Vector2.UP,
	Vector2.DOWN,
	Vector2.LEFT,
	Vector2.RIGHT,
]

var fsm
var moveDir = Vector2.ZERO

onready var chooseDirectionTimer = $ChooseDirectionTimer


func _ready():
	chooseDirection()


func physics_process(delta):
	fsm.velocity = moveDir * MOVE_SPEED
	if fsm.velocity == Vector2.ZERO:
		fsm.animation.play("idle")
	else:
		fsm.animation.play("run")
	

func enter_state():
	fsm.animation.play("idle")


func chooseDirection():
	if randf() < 0.65:
		moveDir = MOVE_DIRS[randi() % MOVE_DIRS.size()]
	else:
		moveDir = Vector2.ZERO


func _on_ChooseDirectionTimer_timeout():
	chooseDirection()
