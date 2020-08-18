extends Node2D

class_name EnemyStateMachine

export(NodePath) var animationPath
export(NodePath) var spritePath

var state
var path
var velocity = Vector2.ZERO
var damage

onready var animation = get_node(animationPath)
onready var sprite = get_node(spritePath)


func ready():
	state = get_child(0)
	state.fsm = self
	state.enter_state([])
	
	
func change_state(newStateName, args):
	state.exit_state()
	state = get_node(newStateName)
	state.fsm = self
	state.enter_state(args)
	
	
func enter_state(args):
	pass
	
	
func process(delta):
	pass
	
	
func physics_process(delta):
	pass
	
	
func exit_state():
	pass
