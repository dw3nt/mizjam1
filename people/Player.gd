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

onready var pickUpArea = $PickUpDetect
onready var headSprite = $Head
onready var leftHand = $LeftHand
onready var rightHand = $RightHand


func _ready():
	pickUpInputMap = {
		"pick_up_left": leftHand,
		"pick_up_right": rightHand
	}


func _input(event):
	for pickUpInput in pickUpInputMap.keys():
		if event.is_action_pressed(pickUpInput):
			var closestItem = null
			for item in pickUpArea.get_overlapping_areas():
				if !item.isHeld:
					if closestItem:
						if global_position.distance_to(item.global_position) < global_position.distance_to(closestItem.global_position):
							closestItem = item
					else:
						closestItem = item
				
			if closestItem:
				pickUpInputMap[pickUpInput].pickUpItem(closestItem)
				updateHandSpriteZIndex(pickUpInput == "pick_up_right")


func _physics_process(delta):
	movePlayer()


func movePlayer():
	var input = Vector2.ZERO
	for inputDir in inputDirs.keys():
		if Input.is_action_pressed(inputDir):
			input += inputDirs[inputDir]

	if input.x != 0:
		flipPlayer(input)

	velocity = input.normalized() * MOVE_SPEED

	move_and_slide(velocity)


func flipPlayer(input):
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

