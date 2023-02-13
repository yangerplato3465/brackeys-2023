extends KinematicBody2D

export var maxHealth = 15
export var accel = 300
export var maxSpeed = 50
export var friction = 300

onready var animationPlayer = $AnimationPlayer
onready var hurtbox = $HurtBox
onready var blinkAnimation = $BlinkAnimation
onready var playerDetection = $PlayerDetection
onready var sprite = $Sprite

var health
var velocity = Vector2.ZERO
var state = CHASE
var target = null

enum {
	IDLE,
	WANDER,
	CHASE
}

func _ready():
	health = maxHealth
	
func _physics_process(delta):
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			
		WANDER:
			pass
			
		CHASE:
			if target != null:
				var direction = (target.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * maxSpeed, accel * delta)
			sprite.flip_h = velocity.x > 0
			
	velocity = move_and_slide(velocity)

func seekPlayer():
	pass

func _on_HurtBox_area_entered(area):
	if area.name == Consts.BULLET_HITBOX:
		health -= area.get_parent().damage
		blinkAnimation.play("BlinkOnce")
		if health <= 0:
			state = IDLE
			hurtbox.collision_layer = Consts.IGNORE
			hurtbox.collision_mask = Consts.IGNORE
			animationPlayer.play("Death")

func death():
	queue_free()


func _on_PlayerDetection_body_entered(body):
	if body.name == Consts.PLAYER:
		state = CHASE
		target = body


func _on_PlayerDetection_body_exited(body):
	if body.name == Consts.PLAYER:
		state = IDLE
		target = null
