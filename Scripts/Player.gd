extends KinematicBody2D

enum {
	MOVE,
	ROLL,
	DEATH
}
# Stats
var accel = 1500
var bulletSpeed = 1000

var velocity = Vector2.ZERO
var rollVector = Vector2.RIGHT
var state = MOVE
var canFire = true
var isInvincible = false
var canControl = true
var canRoll = true
var gunSmithInRange = false

onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite
onready var gun = $Gun
onready var bulletPoint = $Gun/BulletPoint
onready var muzzleFlash = $Gun/Flash
onready var blinkAnimation = $BlinkAnimation
onready var hurtbox = $PlayerHurtbox

var bullet = preload("res://Prefabs/Bullet.tscn")
var upgradePanelPrefab = preload("res://Prefabs/UpgradePanel.tscn")
var upgradePanel = null

func _ready():
	canControl = true
	SignalManager.connect("hideUpgradePanel", self, "hideUpgradePanel")
	SignalManager.emit_signal("initHealth", PlayerStats.health)
	SignalManager.emit_signal("setCointNum", PlayerStats.coinCount)
	
func _process(delta):
	if canControl:
		gunBehavior()
		if Input.is_action_pressed("fire") and canFire:
			fire()
		if hurtbox.get_overlapping_areas().size() > 0 and !isInvincible:
			takeDamage()
		if Input.is_action_pressed("action") and gunSmithInRange:
			showUpgradePanel()

func showUpgradePanel():
	if(upgradePanel == null):
		upgradePanel = upgradePanelPrefab.instance()
		get_tree().get_root().get_node("/root/World/CanvasLayer").add_child(upgradePanel)
		canControl = false
	else:
		upgradePanel.visible = true
		canControl = false

func hideUpgradePanel():
	upgradePanel.visible = false
	canControl = true

func fire():
	muzzleFlash()
	var bulletInstance = bullet.instance()
	bulletInstance.setDamage(PlayerStats.damage)
	get_tree().get_root().add_child(bulletInstance)
	bulletInstance.global_position = bulletPoint.global_position
	canFire = false
	yield(get_tree().create_timer(PlayerStats.fireRate), "timeout")
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
		velocity = velocity.move_toward(inputVector * PlayerStats.maxSpeed, accel * delta)
		animationPlayer.play("Run")
	else:
		velocity = Vector2.ZERO
		animationPlayer.play("Idle")
	
	move()
	
	if Input.is_action_just_pressed("roll") and canRoll:
		state = ROLL
		canRoll = false
		yield(get_tree().create_timer(PlayerStats.rollCD), "timeout")
		canRoll = true

func rollState(_delta):
	velocity = rollVector * PlayerStats.rollSpeed
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
	PlayerStats.health -= 1
	if PlayerStats.health <= 0:
		canControl = false
		velocity = Vector2.ZERO
		SignalManager.emit_signal("healthChange", PlayerStats.health)
		animationPlayer.play("Death")
		return
	SignalManager.emit_signal("healthChange", PlayerStats.health)
	isInvincible = true
	blinkAnimation.play("Start")
	yield(get_tree().create_timer(PlayerStats.invincibilityTime), "timeout")
	blinkAnimation.play("Stop")	
	isInvincible = false


func _on_PlayerCoinHitbox_area_entered(area):
	if area.name == Consts.COIN_AREA:
		PlayerStats.coinCount += 1
		SignalManager.emit_signal("setCointNum", PlayerStats.coinCount)
	elif area.name == Consts.NPC_AREA:
		gunSmithInRange = true


func _on_PlayerCoinHitbox_area_exited(area):
	if area.name == Consts.NPC_AREA:
		gunSmithInRange = false
