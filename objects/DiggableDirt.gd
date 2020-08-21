extends Area2D

const SPAWN_CENTER_OFFSET = Vector2(8, 8)
const BONE_AND_SKULL_SCENE = preload("res://objects/ingredients/BonesAndSkull.tscn")
const BONE_SCENE = preload("res://objects/ingredients/Bone.tscn")
const HUMAN_SKULL_SCENE = preload("res://objects/ingredients/HumanSkull.tscn")
const MONSTER_SKULL_SCENE = preload("res://objects/ingredients/MonsterSkull.tscn")

onready var sprite = $Sprite


func handleHitboxHit(hitter, damage):
    randomize()

    sprite.region_rect = Rect2(16, 0, 16, 16)
    set_collision_layer_bit(6, 0)
    set_collision_mask_bit(5, 0)

    var spawn = randf()
    var inst
    if spawn <= 0.55:
        inst = BONE_AND_SKULL_SCENE.instance()
    elif spawn <= 0.8:
        inst = MONSTER_SKULL_SCENE.instance()
    elif spawn <= .9:
        inst = BONE_SCENE.instance()
    else:
        inst = HUMAN_SKULL_SCENE.instance()

    var spawnPoint = Vector2.RIGHT * 8
    var rand = rand_range(0, PI * 2)
    print(rand)
    spawnPoint = spawnPoint.rotated(rand)
    inst.position = spawnPoint + SPAWN_CENTER_OFFSET
    add_child(inst)