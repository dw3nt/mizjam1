extends Area2D

onready var sprite = $Sprite

func handleHitboxHit():
    sprite.region_rect = Rect2(16, 0, 16, 16)
    set_collision_layer_bit(6, 0)
    set_collision_mask_bit(5, 0)