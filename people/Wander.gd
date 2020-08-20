extends MinionStateMachine

const MOVE_DIRS = [
	Vector2.UP,
	Vector2.DOWN,
	Vector2.LEFT,
	Vector2.RIGHT,
]

var fsm
var moveDir = Vector2.ZERO

onready var chooseDirectionTimer = $ChooseDirectionTimer
onready var chaseEnemyDetect = $ChaseEnemyDetect


func _ready():
	chooseDirection()


func physics_process(delta):
	fsm.velocity = moveDir * fsm.wanderSpeed
	if fsm.velocity == Vector2.ZERO:
		fsm.animation.play("idle")
	else:
		fsm.animation.play("run")
	

func enter_state(args):
	fsm.animation.play("idle")

	var otherTargets = chaseEnemyDetect.get_overlapping_bodies()
	if otherTargets.size() > 0:
		var closestTarget = null
		for potentialTarget in otherTargets:
			if !closestTarget:
				closestTarget = potentialTarget
			else:
				var distanceToClosest = global_position.distance_to(closestTarget.global_position)
				var distanceToPotential = global_position.distance_to(potentialTarget.global_position)
				if distanceToPotential < distanceToClosest:
					closestTarget = potentialTarget

		fsm.change_state("Chase", [closestTarget])


func chooseDirection():
	if randf() < 0.65:
		moveDir = MOVE_DIRS[randi() % MOVE_DIRS.size()]
	else:
		moveDir = Vector2.ZERO


func _on_ChooseDirectionTimer_timeout():
	chooseDirection()


func _on_ChaseEnemyDetect_body_entered(body):
	if fsm != null && fsm.state == self:
		fsm.change_state("Chase", [body])
