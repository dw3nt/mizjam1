extends Node

onready var nav2d = $Navigation2D
onready var line2d = $Line2D
onready var start = $Start
onready var end = $End


func _ready():
    var path = nav2d.get_simple_path(start.global_position, end.global_position)
    line2d.points  = path

    print(path)