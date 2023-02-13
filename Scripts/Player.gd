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
export var health = 3

var velocity = Vector2.ZERO
var rollVector = Vector2.RIGHT
var state = MOVE
var canFire = true

onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite
onready var gun = $Gun
onready var bulletPoint = $Gun/BulletPoint
onready var muzzleFlash = $Gun/Flash

var bullet = preload("res://Prefabs/Bullet.tscn")

func _ready():
	pass
	
func _process(delta):
	gunBehavior()
	if Input.is_action_pressed("fire") and canFire:
		fire()

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
