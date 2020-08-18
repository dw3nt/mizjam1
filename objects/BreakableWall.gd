extends StaticBody2D

export var hits = 0

var hitRegions = [
    Rect2(32, 192, 16, 16),
    Rect2(16, 176, 16, 16),
    Rect2(32, 176, 16, 16),
]
var maxHits = hitRegions.size()

onready var sprite = $Sprite


func _ready():
    sprite.region_rect = hitRegions[hits]


func handleHitboxHit(hitter, damage):
    hits += 1
    if hits >= maxHits:
        queue_free()
    else:
        sprite.region_rect = hitRegions[hits]