extends KinematicBody2D

export var hp = 1
export var atk = 2 setget setAtk
export var wanderSpeed = 25 setget setWanderSpeed
export var chaseSpeed = 40 setget setChaseSpeed
export var minAttackSpeed = 0.75 setget setMinAttackSpeed
export var maxAttackSpeed = 1.5 setget setMaxAttackSpeed
export var attackTimeOffset = 2.0 setget setAttackTimeOffset

onready var minionStates = $MinionStateMachine
onready var injuredState = $MinionStateMachine/Injured


func _ready():
	randomize()
	minionStates.damage = atk
	minionStates.wanderSpeed = wanderSpeed
	minionStates.chaseSpeed = chaseSpeed
	minionStates.minAttackSpeed = minAttackSpeed
	minionStates.maxAttackSpeed = maxAttackSpeed
	minionStates.attackTimeOffset = attackTimeOffset
	minionStates.ready()


func _process(delta):
	minionStates.state.process(delta)


func _physics_process(delta):
	minionStates.state.physics_process(delta)
	move_and_slide(minionStates.velocity)


func handleHitboxHit(hitter, damage):
	if minionStates.state.name != "Injured":
		minionStates.change_state("Injured", [])
		hp -= damage
		if hp <= 0:
			destroy()


func destroy():
	queue_free()


func setAtk(val):
	atk = val
	if minionStates:
		minionStates.damage = atk

func setWanderSpeed(val):
	wanderSpeed = val
	if minionStates:
		minionStates.wanderSpeed = wanderSpeed


func setChaseSpeed(val):
	chaseSpeed = val
	if minionStates:
		minionStates.chaseSpeed = chaseSpeed


func setMinAttackSpeed(val):
	minAttackSpeed = val
	if minionStates:
		minionStates.minAttackSpeed = minAttackSpeed


func setMaxAttackSpeed(val):
	maxAttackSpeed = val
	if minionStates:
		minionStates.maxAttackSpeed = maxAttackSpeed


func setAttackTimeOffset(val):
	attackTimeOffset = val
	if minionStates:
		minionStates.attackTimeOffset = attackTimeOffset