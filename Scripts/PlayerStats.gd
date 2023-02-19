extends Node2D
# Default Stats
var defaultEnemyMaxCoinDrop = 3
var defaultEnemyMinCoinDrop = 2
var defaultDamage = 5.0
var defaultMaxHealth = 5
var defaultHealth = 5
var defaultMaxSpeed = 100.0
var defaultInvincibilityTime = 1.0
var defaultRollCD = 1.0
var defaultFireRate = 0.5
var defaultDropPotionChance = 0.0
var defaultHealsEnterNewRoom = 0
var defaultitemTierUnlocked = 0
var defaultShopItemCostMultiplier = 1
var defaultStickyBullet = false
var defaultBerserkerUnlocked = false
var defaultBerserkerActivated = false
var defaultUpgradeArray = []

# Stats
var enemyMaxCoinDrop = 3
var enemyMinCoinDrop = 2
var damage = 5.0
var maxHealth = 5
var health = 5
var maxSpeed = 100.0
var invincibilityTime = 1.0
var rollCD = 1.0
var fireRate = 0.5
var dropPotionChance = 0.0
var healsEnterNewRoom = 0
var itemTierUnlocked = 0
var shopItemCostMultiplier = 1
var stickyBullet = false
var berserkerUnlocked = false
var berserkerActivated = false
var upgradeArray = []

var coinCount = 0
var currentLevel = 1
# For next run
var coinForNextRun = 0
var upgradeForNextRun = null
var firstRun = true

onready var selectLegacyScene = $CanvasLayer/SelectLegacyScene

func _ready():
	pass
	
func showSelectLegacyScene():
	selectLegacyScene.visible = true

func resetAll():
	enemyMaxCoinDrop = defaultEnemyMaxCoinDrop
	enemyMinCoinDrop = defaultEnemyMinCoinDrop
	damage = defaultDamage
	maxHealth = defaultMaxHealth
	health = defaultHealth
	maxSpeed = defaultMaxSpeed
	invincibilityTime = defaultInvincibilityTime
	rollCD = defaultRollCD
	fireRate = defaultFireRate
	dropPotionChance = defaultDropPotionChance
	healsEnterNewRoom = defaultHealsEnterNewRoom
	itemTierUnlocked = defaultitemTierUnlocked
	shopItemCostMultiplier = defaultShopItemCostMultiplier
	stickyBullet = defaultStickyBullet
	berserkerUnlocked = defaultBerserkerUnlocked
	berserkerActivated = defaultBerserkerActivated
	currentLevel = 1
	coinCount = 0
	SignalManager.emit_signal("setCointNum", coinCount)


func applyUpgrade(id):
	SignalManager.emit_signal("updateTabViewStats")
	if id != 2 || id != 3 || id != 4:
		upgradeArray.append(id)
	match id:
		0:
			maxHealth += 1
			health += 1
			SignalManager.emit_signal("healthChange", health)
			SignalManager.emit_signal('maxHealthChange', maxHealth)
		1:
			healsEnterNewRoom += 1
		2:
			health = maxHealth
			SignalManager.emit_signal("healthChange", health)
			if berserkerActivated:
				damage -= 10
				berserkerActivated = false
		3:
			health += 3
			if health > maxHealth:
				health = maxHealth
			SignalManager.emit_signal("healthChange", health)
			if berserkerActivated:
				damage -= 10
				berserkerActivated = false
		4:
			health += 1
			if health > maxHealth:
				health = maxHealth
			SignalManager.emit_signal("healthChange", health)
			if berserkerActivated:
				damage -= 10
				berserkerActivated = false
		5:
			dropPotionChance += 0.1
		6:
			damage *= 1.2
		7:
			damage *= 1.4
		8:
			damage *= 1.6
		9:
			fireRate *= 0.8
		10:
			fireRate *= 0.6
		11:
			fireRate *= 0.4
		12:
			itemTierUnlocked += 1
		13:
			rollCD *= 0.8
		14:
			maxSpeed *= 1.1
		15:
			enemyMaxCoinDrop += 1
		16:
			shopItemCostMultiplier *= 0.8
		17:
			berserkerUnlocked = true
		18:
			stickyBullet = true
		19:
			invincibilityTime *= 1.2

