extends KinematicBody2D

const MAX_SPEED = 100
const ACCELERATION = 1500
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite

func _ready():
	pass

func _physics_process(delta):
	var inputVector = Vector2.ZERO
	inputVector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	inputVector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	inputVector = inputVector.normalized()
	
	if inputVector.x > 0:
		sprite.scale.x = 1
	elif inputVector.x < 0:
		sprite.scale.x = -1
	
	if inputVector != Vector2.ZERO:
		velocity = velocity.move_toward(inputVector * MAX_SPEED, ACCELERATION * delta)
		animationPlayer.play("Run")
	else:
		velocity = Vector2.ZERO
		animationPlayer.play("Idle")
	
	velocity = move_and_slide(velocity)
