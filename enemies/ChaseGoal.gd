extends EnemyStateMachine

var fsm
var goalPath = []
var nextPathPoint = null
var moveDir = Vector2.ZERO

onready var chaseTargetDetect = $ChaseTargetDetect


func enter_state(args):
	if !goalPath:
		goalPath = fsm.path   # remove wasn't working in fsm.path in physics_process()
	fsm.animation.play("run")
	
	var otherTargets = chaseTargetDetect.get_overlapping_bodies()
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

		fsm.change_state("ChaseTarget", [closestTarget])


func physics_process(delta):
	if !nextPathPoint:
		nextPathPoint = goalPath[0]

	if global_position.distance_to(nextPathPoint) < 4:
		if goalPath.size() > 1:
			nextPathPoint = goalPath[1]

		goalPath.remove(0)

	moveDir = global_position.direction_to(nextPathPoint)
	fsm.sprite.flip_h = moveDir.x < 0
	fsm.velocity = moveDir * fsm.chaseGoalSpeed
		

func _on_ChaseTargetDetect_body_entered(body):
	if fsm != null && fsm.state == self:
		fsm.change_state("ChaseTarget", [body])
