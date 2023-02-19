extends Control

onready var container = $Bg/GridContainer
onready var gold = $Bg/GoldLabel/Gold

var iconButton = preload("res://Prefabs/IconButton.tscn")

func _ready():
	SignalManager.connect("updateSelectView", self, "addIcon")
	SignalManager.connect("setLegacyGold", self, "setGold")
	
func addIcon(data):
	# Potion type upgrades don't need to add icon
	if data.frame == 152 || data.frame == 156 || data.frame == 144:
		return
	var icon = iconButton.instance()
	icon.setIconFrameAndData(data)
	container.add_child(icon)

func setGold():
	print(PlayerStats.coinCount)
	var goldAmount = round(PlayerStats.coinCount * 0.3)
	PlayerStats.coinForNextRun = goldAmount
	gold.text = "$ " + String(goldAmount)


func _on_Back_pressed():
	PlayerStats.resetAll()
	Transition.startGame()
	visible = false
