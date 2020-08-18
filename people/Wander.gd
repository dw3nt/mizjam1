extends MinionStateMachine

var fsm


func _ready():
	pass
	

func enter_state():
	fsm.animation.play("idle")
