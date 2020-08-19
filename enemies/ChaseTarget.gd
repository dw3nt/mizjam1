extends EnemyStateMachine

const MOVE_SPEED = 40

var fsm
var target = null

onready var attackTargetDetect = $AttackTargetDetect


func physics_process(delta):
	var wr = weakref(target)
	if !wr.get_ref():
		fsm.change_state("FindPath", [])
	else:
		var direction = global_position.direction_to(target.global_position)
		fsm.velocity = direction * MOVE_SPEED
		

# args[0] - chase target
func enter_state(args):
	fsm.animation.play("run")
	target = args[0]
	

func _on_AttackTargetDetect_body_entered(body):
	if fsm.state == self:
		fsm.change_state("Attack", [body])
