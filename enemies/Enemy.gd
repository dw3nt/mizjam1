extends KinematicBody2D

export var hp = 2
export var atk = 1 setget setAtk

var path setget setPath

onready var enemyStates = $EnemyStateMachine


func _ready():
	enemyStates.damage = atk
	enemyStates.path = path
	enemyStates.ready()


func _process(delta):
	enemyStates.state.process(delta)


func _physics_process(delta):
	enemyStates.state.physics_process(delta)
	move_and_slide(enemyStates.velocity)


func handleHitboxHit(hitter, damage):
	print('hit by ' + str(hitter.name) + ' for ' + str(damage) + ' damage')


func destroy():
	queue_free()


func setAtk(val):
	atk = val
	if enemyStates:
		enemyStates.damage = atk


func setPath(val):
	path = val
	if enemyStates && path.size() > 0:
		enemyStates.path = path
