extends EnemyStateMachine

const MOVE_SPEED = 30

var fsm
var goalPath = []
var nextPathPoint = null
var moveDir = Vector2.ZERO

onready var chaseTargetDetect = $ChaseTargetDetect


func enter_state(args):
	goalPath = fsm.path   # remove wasn't working in fsm.path in physics_process()
	fsm.animation.play("run")
	

func physics_process(delta):
	if !nextPathPoint:
		nextPathPoint = goalPath[0]

	if global_position.distance_to(nextPathPoint) < 4:
		if goalPath.size() > 1:
			nextPathPoint = goalPath[1]

		goalPath.remove(0)

		moveDir = global_position.direction_to(nextPathPoint)
		fsm.sprite.flip_h = moveDir.x < 0
		fsm.velocity = moveDir.round() * MOVE_SPEED
		

func _on_ChaseTargetDetect_body_entered(body):
	if fsm.state == self:
		fsm.change_state("ChaseTarget", [body])
