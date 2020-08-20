extends MinionStateMachine

var fsm


func enter_state(args):
	fsm.animation.play("damaged")


func animation_finished(anim_name):
	if anim_name == "damaged":
		var previousState = fsm.getPreviousState()
		fsm.change_state(previousState.state, previousState.args)
