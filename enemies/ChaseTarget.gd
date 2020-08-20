extends EnemyStateMachine

var fsm
var target = null

onready var attackTargetDetect = $AttackTargetDetect
onready var chaseGoalRangeDetect = $ChaseGoalRangeDetect


func physics_process(delta):
	var wr = weakref(target)
	if !wr.get_ref():
		fsm.change_state("ChaseGoal", [])
	else:
		var direction = global_position.direction_to(target.global_position)
		fsm.sprite.flip_h = direction.x < 0
		fsm.velocity = direction * fsm.chaseTargetSpeed
		

# args[0] - chase target
func enter_state(args):
	fsm.animation.play("run")
	target = args[0]
	

func _on_AttackTargetDetect_body_entered(body):
	if fsm != null && fsm.state == self:
		fsm.change_state("Attack", [body])


func _on_ChaseGoalRangeDetect_body_exited(body):
	if fsm != null && fsm.state == self:
		fsm.change_state("ChaseGoal", [])
