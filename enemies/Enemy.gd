extends KinematicBody2D

export var hp = 2
export var atk = 1 setget setAtk
export var chaseGoalSpeed = 25 setget setChaseGoalSpeed
export var chaseTargetSpeed = 30 setget setChaseTargetSpeed
export var minAttackSpeed = 0.75 setget setMinAttackSpeed
export var maxAttackSpeed = 1.5 setget setMaxAttackSpeed
export var attackTimeOffset = 2 setget setAttackTimeOffset

var path setget setPath

onready var enemyStates = $EnemyStateMachine
onready var injuredState = $EnemyStateMachine/Injured


func _ready():
	randomize()
	enemyStates.damage = atk
	enemyStates.path = path
	enemyStates.chaseGoalSpeed = chaseGoalSpeed
	enemyStates.chaseTargetSpeed = chaseTargetSpeed
	enemyStates.minAttackSpeed = minAttackSpeed
	enemyStates.maxAttackSpeed = maxAttackSpeed
	enemyStates.attackTimeOffset = attackTimeOffset
	enemyStates.ready()


func _process(delta):
	enemyStates.state.process(delta)


func _physics_process(delta):
	enemyStates.state.physics_process(delta)
	move_and_slide(enemyStates.velocity)


func handleHitboxHit(hitter, damage):
	if enemyStates.state.name != "Injured":
		enemyStates.change_state("Injured", [])
		hp -= damage
		if hp <= 0:
			destroy()


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


func setChaseGoalSpeed(val):
	chaseGoalSpeed = val
	if enemyStates:
		enemyStates.chaseGoalSpeed = chaseGoalSpeed


func setChaseTargetSpeed(val):
	chaseTargetSpeed = val
	if enemyStates:
		enemyStates.chaseTargetSpeed = chaseTargetSpeed


func setMinAttackSpeed(val):
	minAttackSpeed = val
	if enemyStates:
		enemyStates.minAttackSpeed = minAttackSpeed


func setMaxAttackSpeed(val):
	maxAttackSpeed = val
	if enemyStates:
		enemyStates.maxAttackSpeed = maxAttackSpeed

func setAttackTimeOffset(val):
	attackTimeOffset = val
	if enemyStates:
		enemyStates.attackTimeOffset = path