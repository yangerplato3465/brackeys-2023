extends KinematicBody2D

enum {
	MOVE,
	ROLL,
	DEATH
}
# Stats
export var maxSpeed = 100
export var rollSpeed = 200
export var accel = 1500
export var bulletSpeed = 1000
export var fireRate = 0.5
export var damage = 5
export var maxHealth = 20
export var health = 0
export var invincibilityTime = 1

var velocity = Vector2.ZERO
var rollVector = Vector2.RIGHT
var state = MOVE
var canFire = true
var isInvincible = false
var canControl = true

onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite
onready var gun = $Gun
onready var bulletPoint = $Gun/BulletPoint
onready var muzzleFlash = $Gun/Flash
onready var blinkAnimation = $BlinkAnimation
onready var hurtbox = $PlayerHurtbox

var bullet = preload("res://Prefabs/Bullet.tscn")

func _ready():
	health = maxHealth
	canControl = true
	SignalManager.emit_signal("initHealth", health)
	
func _process(delta):
	if canControl:
		gunBehavior()
		if Input.is_action_pressed("fire") and canFire:
			fire()
		if hurtbox.get_overlapping_areas().size() > 0 and !isInvincible:
			takeDamage()

func fire():
	muzzleFlash()
	var bulletInstance = bullet.instance()
	bulletInstance.setDamage(damage)
	get_tree().get_root().add_child(bulletInstance)
	bulletInstance.global_position = bulletPoint.global_position
	canFire = false
	yield(get_tree().create_timer(fireRate), "timeout")
	canFire = true

func muzzleFlash():
	muzzleFlash.visible = true
	yield(get_tree().create_timer(0.1), "timeout")
	muzzleFlash.visible = false	

func _physics_process(delta):
	if canControl:
		match state:
			MOVE:
				moveState(delta)
			
			ROLL:
				rollState(delta)
	
func moveState(delta):
	var inputVector = Vector2.ZERO
	inputVector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	inputVector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	inputVector = inputVector.normalized()
	
	if inputVector.x > 0:
		sprite.scale.x = 1
	elif inputVector.x < 0:
		sprite.scale.x = -1
	
	if inputVector != Vector2.ZERO:
		rollVector = inputVector
		velocity = velocity.move_toward(inputVector * maxSpeed, accel * delta)
		animationPlayer.play("Run")
	else:
		velocity = Vector2.ZERO
		animationPlayer.play("Idle")
	
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL

func rollState(_delta):
	velocity = rollVector * rollSpeed
	animationPlayer.play("Roll")
	move()

func roll_animation_finished():
	state = MOVE

func move():
	velocity = move_and_slide(velocity)

func gunBehavior():
	var mousePos = get_global_mouse_position()
	gun.look_at(mousePos)
	if mousePos.x > position.x:
		gun.scale.y = 1
	elif mousePos.x < position.x:
		gun.scale.y = -1

func death():
	queue_free()

func takeDamage():
	if state == ROLL:
		return
	health -= 1
	if health <= 0:
		canControl = false
		velocity = Vector2.ZERO
		SignalManager.emit_signal("healthChange", health)
		animationPlayer.play("Death")
		return
	SignalManager.emit_signal("healthChange", health)
	isInvincible = true
	blinkAnimation.play("Start")
	yield(get_tree().create_timer(invincibilityTime), "timeout")
	blinkAnimation.play("Stop")	
	isInvincible = false
