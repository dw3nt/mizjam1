extends KinematicBody2D

const MOVE_SPEED = 50

export var hp = 2
export var atk = 1 setget setAtk

var path setget setPath

onready var enemyStates = $EnemyStateMachine


func _ready():
	enemyStates.ready()
	enemyStates.damage = atk


func _process(delta):
	enemyStates.state.process(delta)


func _physics_process(delta):
	enemyStates.state.physics_process(delta)
	move_and_slide(enemyStates.velocity)


func setAtk(val):
	atk = val
	if enemyStates:
		enemyStates.damage = atk


func setPath(val):
	path = val
	if enemyStates:
		enemyStates.path = path
