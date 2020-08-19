extends KinematicBody2D

export var hp = 1
export var atk = 2 setget setAtk

onready var minionStates = $MinionStateMachine
onready var injuredState = $MinionStateMachine/Injured


func _ready():
	injuredState.connect("dead", self, "_on_Injured_dead")

	minionStates.damage = atk
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
