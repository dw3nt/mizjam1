extends MinionStateMachine

const CHARGE_DISTANCE = 8
const ATTACK_DISTANCE = 6
enum ATTACK_TWEENS { Charging, Attacking, Resetting }

var fsm
var target = null
var spriteStartPos = null
var currentTween = null

onready var tween = $Tween
onready var attackTimer = $AttackTimer


func _ready():
	pass


func process(delta):
	if !targetExists():
		fsm.change_state("Wander", [])


# args[0] - attack target
func enter_state(args):
	fsm.animation.play("idle")
	fsm.velocity = Vector2.ZERO
	target = args[0]
	spriteStartPos = fsm.sprite.position
	attackTimer.start()
	

func exit_state():
	target = null
	tween.stop_all()
	fsm.sprite.position = spriteStartPos
	

func targetExists():
	var wr = weakref(target)
	return wr.get_ref()
	

func playChargeTween():
	currentTween = ATTACK_TWEENS.Charging
	var attackDir = global_position.direction_to(target.global_position).rotated(PI)
	var finalPosition = (attackDir * CHARGE_DISTANCE) + spriteStartPos
	tween.interpolate_property(fsm.sprite, "position", 
		spriteStartPos, finalPosition, 0.25,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()


func playAttackTween():
	currentTween = ATTACK_TWEENS.Attacking
	var attackDir = global_position.direction_to(target.global_position)
	var finalPosition = (attackDir * ATTACK_DISTANCE) + spriteStartPos
	tween.interpolate_property(fsm.sprite, "position", 
		spriteStartPos, finalPosition, 0.05,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	

func playResetTween():
	currentTween = ATTACK_TWEENS.Resetting
	tween.interpolate_property(fsm.sprite, "position", 
		fsm.sprite.position, spriteStartPos, 0.05,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()


func _on_Tween_tween_all_completed():
	match currentTween:
		ATTACK_TWEENS.Charging:
			playAttackTween()

		ATTACK_TWEENS.Attacking:
			target.handleHitboxHit(self, fsm.damage)
			playResetTween()

		ATTACK_TWEENS.Resetting:
			attackTimer.start()
		

func _on_AttackTimer_timeout():
	if targetExists():
		playChargeTween()
