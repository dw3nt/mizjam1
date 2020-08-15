extends StaticBody2D

export var maxHits = 1
export var hits = 0

var hitRegions = [
    Rect2(32, 192, 16, 16),
    Rect2(16, 176, 16, 16),
    Rect2(32, 176, 16, 16),
]

onready var sprite = $Sprite


func _ready():
    sprite.region_rect = hitRegions[0]


func handleHitboxHit():
    hits += 1
    if hits >= maxHits:
        queue_free()
    else:
        sprite.region_rect = hitRegions[hits]