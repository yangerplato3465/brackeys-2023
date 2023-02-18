extends NinePatchRect

onready var damage = $VBoxContainer/DamageLabel/Damage
onready var speed = $VBoxContainer/SpeedLabel/Speed
onready var firerate = $VBoxContainer/FirerateLabel/Firerate
onready var container = $GridContainer

var icon = preload("res://Prefabs/Icon.tscn")

func _ready():
	SignalManager.connect("updateTabView", self, "addIcon")
	init()

func init():
	damage.text = String(PlayerStats.damage)
	speed.text = String(PlayerStats.maxSpeed)
	firerate.text = String(1 / PlayerStats.fireRate)

func addIcon(frame):
	var iconInstance = icon.instance()
	iconInstance.setIconFrame(frame)
	container.add_child(iconInstance)
	
