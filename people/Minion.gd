extends KinematicBody2D

onready var minionStates = $MinionStateMachine


func _ready():
	minionStates.ready()
