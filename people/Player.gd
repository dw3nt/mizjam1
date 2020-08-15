extends KinematicBody2D

const MOVE_SPEED = 100

var pickUpInputMap = {}
var inputDirs = {
	"move_up": Vector2.UP,
	"move_down": Vector2.DOWN,
	"move_left": Vector2.LEFT,
	"move_right": Vector2.RIGHT,
}
var velocity = Vector2.ZERO
var isUsingItem = false

var frontHand
var backHand

onready var pickUpArea = $PickUpDetect
onready var headSprite = $Head
onready var leftHand = $LeftHand
onready var rightHand = $RightHand
onready var animation = $AnimationPlayer


func _ready():
	frontHand = rightHand
	backHand = leftHand

	pickUpInputMap = {
		"pick_up_left": leftHand,
		"pick_up_right": rightHand
	}


func _input(event):
	if event.is_class("InputEventKey"):
		processPickUpInput(event)

	elif event.is_class("InputEventMouseButton"):
		processUseItemInput(event)


func processPickUpInput(event):
	if !isUsingItem:
		for pickUpInput in pickUpInputMap.keys():
			if event.is_action_pressed(pickUpInput):
				var closestItem = null
				for item in pickUpArea.get_overlapping_areas():
					var pickupAbleNode = item.get_parent()
					if !pickupAbleNode.isHeld:
						if closestItem:
							if global_position.distance_to(item.global_position) < global_position.distance_to(closestItem.global_position):
								closestItem = pickupAbleNode
						else:
							closestItem = pickupAbleNode
					
				if closestItem:
					pickUpInputMap[pickUpInput].pickUpItem(closestItem)
					updateHandSpriteZIndex(pickUpInput == "pick_up_right")


func processUseItemInput(event):
	if !isUsingItem:
		if event.is_action_pressed("use_left_item"):
			if backHand == leftHand:
				animation.play("use_left_back_item")
			else:
				animation.play("use_left_front_item")
		
		if event.is_action_pressed("use_right_item"):
			if frontHand == rightHand:
				animation.play("use_right_front_item")
			else:
				animation.play("use_right_back_item")


func setHandItemHitboxCollision(handPath, _disabled):
	var hand = get_node(handPath)
	if hand && hand.item:
		hand.item.hitboxCollision.disabled = _disabled


func setUsingItem(val):
	isUsingItem = val


func _physics_process(_delta):
	movePlayer()


func movePlayer():
	var input = Vector2.ZERO
	for inputDir in inputDirs.keys():
		if Input.is_action_pressed(inputDir):
			input += inputDirs[inputDir]

	if input.x != 0 && !isUsingItem:
		flipPlayer(input)

	velocity = input.normalized() * MOVE_SPEED

	move_and_slide(velocity)


func flipPlayer(input):
	if input.x > 0:
		backHand = leftHand
		frontHand = rightHand
	elif input.x < 0:
		backHand = rightHand
		frontHand = leftHand

	headSprite.flip_h = input.x < 0
	leftHand.scale.x = input.x
	if sign(leftHand.rotation_degrees) != input.x:
		leftHand.rotation_degrees *= -1
	updateHandSpriteZIndex(false)

	rightHand.scale.x = input.x
	if sign(rightHand.rotation_degrees) != input.x:
		rightHand.rotation_degrees *= -1
	updateHandSpriteZIndex(true)


func updateHandSpriteZIndex(isRightHand):
	if isRightHand:
		if rightHand.item:
			rightHand.item.sprite.z_index = rightHand.scale.x
	else:
		if leftHand.item:
			leftHand.item.sprite.z_index = leftHand.scale.x * -1
