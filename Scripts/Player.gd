extends KinematicBody2D

enum {
	MOVE,
	ROLL,
	DEATH
}
const MAX_SPEED = 100
const ROLL_SPEED = 200
const ACCELERATION = 1500
var velocity = Vector2.ZERO
var rollVector = Vector2.RIGHT
var state = MOVE

onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite
onready var gun = $Gun

func _ready():
	pass

func _physics_process(delta):
	gunBehavior()
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
		velocity = velocity.move_toward(inputVector * MAX_SPEED, ACCELERATION * delta)
		animationPlayer.play("Run")
	else:
		velocity = Vector2.ZERO
		animationPlayer.play("Idle")
	
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL

func rollState(delta):
	velocity = rollVector * ROLL_SPEED
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
