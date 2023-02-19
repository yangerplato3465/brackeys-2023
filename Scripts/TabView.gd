extends NinePatchRect

onready var damage = $VBoxContainer/DamageLabel/Damage
onready var speed = $VBoxContainer/SpeedLabel/Speed
onready var firerate = $VBoxContainer/FirerateLabel/Firerate
onready var container = $GridContainer

var icon = preload("res://Prefabs/Icon.tscn")

func _ready():
	SignalManager.connect("updateTabView", self, "addIcon")
	SignalManager.connect("updateTabViewStats", self, "updateStats")
	init()

func init():
	damage.text = String(stepify(PlayerStats.damage, 0.01))
	speed.text = String(stepify(PlayerStats.maxSpeed, 0.01))
	firerate.text = String(stepify(1 / PlayerStats.fireRate, 0.01))

func updateStats():
	damage.text = String(stepify(PlayerStats.damage, 0.01))
	speed.text = String(stepify(PlayerStats.maxSpeed, 0.01))
	firerate.text = String(stepify(1 / PlayerStats.fireRate, 0.01))

func addIcon(data):
	# Potion type upgrades don't need to add icon
	if data.frame == 152 || data.frame == 156 || data.frame == 144:
		return
	var iconInstance = icon.instance()
	iconInstance.setIconFrame(data)
	container.add_child(iconInstance)
	
