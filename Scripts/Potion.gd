extends KinematicBody2D

var rng = RandomNumberGenerator.new()
var velocity = Vector2.ZERO
var speed = 100
var friction = 150

func _ready():
	rng.randomize()
	var x = rng.randf_range(-1.0, 1.0)
	var y = rng.randf_range(-1.0, 1.0)
	velocity = Vector2(x * speed, y * speed)
	

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	velocity = move_and_slide(velocity)	

func _on_Area2D_area_entered(area):
	if area.name == Consts.PLAYER_COIN_HITBOX:
		queue_free()

