extends Node2D

const ENEMY_SCENE = preload("res://enemies/Enemy.tscn")

export(NodePath) var navigationPath
export(NodePath) var goalPath
export(NodePath) var enemyWrapPath

var navigation
var goal
var enemyWrap

onready var spawnPointsWrap = $SpawnPoints
onready var spawnTimer = $SpawnTimer


func _ready():
	if navigationPath:
		navigation = get_node(navigationPath)

	if goalPath:
		goal = get_node(goalPath)

	if enemyWrapPath:
		enemyWrap = get_node(enemyWrapPath)


func _on_SpawnTimer_timeout():
	var inst = ENEMY_SCENE.instance()
	var spawnPoint = spawnPointsWrap.get_child(randi() % spawnPointsWrap.get_child_count())
	inst.position = spawnPoint.position
	var path = navigation.get_simple_path(inst.position, goal.position)
	inst.path = path
	enemyWrap.add_child(inst)

	spawnTimer.wait_time = rand_range(5, 8)
	spawnTimer.start()
