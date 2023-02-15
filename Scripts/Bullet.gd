extends KinematicBody2D

var speed = 500
var velocity = Vector2(1, 0)
var damage = 0 setget setDamage

var lookOnce = true

func _process(delta):
	if lookOnce:
		look_at(get_global_mouse_position())
		lookOnce = false
	global_position += velocity.rotated(rotation) * speed * delta


func _on_Hitbox_area_entered(area):
	queue_free()

func setDamage(value):
	damage = value


func _on_BulletHitbox_body_entered(body):
	if body.name == Consts.WALLS:
		queue_free()
