extends Area2D

export(String, "key", "shovel", "pickaxe") var objectType = "key"

var isHeld = false

var spriteRegionMap = {
	"key": Rect2(512, 176, 16, 16),
	"shovel": Rect2(672, 80, 16, 16),
	"pickaxe": Rect2(688, 80, 16, 16),
}

var spriteRotateMap = {
	"key": 0,
	"shovel": 45,
	"pickaxe": -45
}

var spriteOffsetMap = {
	"key": Vector2.ZERO,
	"shovel": Vector2(4, 0),
	"pickaxe": Vector2(1, -3)
}

onready var sprite = $Sprite


func _ready():
	sprite.region_rect = spriteRegionMap[objectType]
	sprite.rotation_degrees = spriteRotateMap[objectType]
	sprite.offset = spriteOffsetMap[objectType]
