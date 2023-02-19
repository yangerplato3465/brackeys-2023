extends KinematicBody2D

export var isKing = false

export var maxHealth = 15
export var extraCoinDrop = 0
export var accel = 300
export var maxSpeed = 50
export var friction = 300

onready var animationPlayer = $AnimationPlayer
onready var hurtbox = $HurtBox
onready var blinkAnimation = $BlinkAnimation
onready var playerDetection = $PlayerDetection
onready var sprite = $Sprite

var coin = preload("res://Prefabs/Coin.tscn")
var potion = preload("res://Prefabs/Potion.tscn")

var health
var velocity = Vector2.ZERO
var state = CHASE
var target = null
var rng = RandomNumberGenerator.new()

enum {
	IDLE,
	WANDER,
	CHASE
}

func _ready():
	rng.randomize()
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
		if PlayerStats.stickyBullet:
			maxSpeed = 35
		if health <= 0:
			state = IDLE
			hurtbox.collision_layer = Consts.IGNORE
			hurtbox.collision_mask = Consts.IGNORE
			animationPlayer.play("Death")

func death():
	spawnCoins()
	spawnPotion()
	if isKing:
		Transition.changeScene()
	else:
		queue_free()

func spawnCoins():
	var coinNum = rng.randi_range(PlayerStats.enemyMinCoinDrop, PlayerStats.enemyMaxCoinDrop)
	for n in coinNum + extraCoinDrop:
		var coinInstance = coin.instance()
		get_tree().get_root().add_child(coinInstance)
		coinInstance.global_position = global_position

func spawnPotion():
	var shouldSpawn = false
	if PlayerStats.dropPotionChance <= 0:
		return
	else:
		shouldSpawn = rng.randf() < PlayerStats.dropPotionChance
	
	if shouldSpawn:
		var potionInstance = potion.instance()
		get_tree().get_root().add_child(potionInstance)
		potionInstance.global_position = global_position

func _on_PlayerDetection_body_entered(body):
	if body.name == Consts.PLAYER:
		state = CHASE
		target = body


func _on_PlayerDetection_body_exited(body):
	if body.name == Consts.PLAYER:
		state = IDLE
		target = null
