extends KinematicBody2D

onready var minionStates = $MinionStateMachine


func _ready():
	minionStates.ready()


func _physics_process(delta):
	minionStates.state.physics_process(delta)
	move_and_slide(minionStates.velocity)
