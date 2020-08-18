extends KinematicBody2D

export var hp = 10
export var atk = 2 setget setAtk

onready var minionStates = $MinionStateMachine


func _ready():
	minionStates.ready()
	minionStates.damage = atk


func _process(delta):
	minionStates.state.process(delta)


func _physics_process(delta):
	minionStates.state.physics_process(delta)
	move_and_slide(minionStates.velocity)


func setAtk(val):
	atk = val
	if minionStates:
		minionStates.damage = atk
