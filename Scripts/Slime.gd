extends KinematicBody2D

export var maxHealth = 15
var health
onready var animationPlayer = $AnimationPlayer
onready var hurtbox = $HurtBox

func _ready():
	health = maxHealth


func _on_HurtBox_area_entered(area):
	if area.name == Consts.BULLET_HITBOX:
		health -= area.get_parent().damage
		if health <= 0:
			hurtbox.collision_layer = Consts.IGNORE
			hurtbox.collision_mask = Consts.IGNORE
			animationPlayer.play("Death")

func death():
	queue_free()
