extends Control

onready var hearts = $Hearts
onready var heartsEmpty = $HeartsEmpty
onready var coinCount = $CoinCount

const WIDTH = 30

func _ready():
	SignalManager.connect('initHealth', self, 'initHealth')
	SignalManager.connect('healthChange', self, 'setCurrentHealth')
	SignalManager.connect('maxHealthChange', self, 'setMaxHealth')
	SignalManager.connect('setCointNum', self, 'setCointNum')
	pass

func setCurrentHealth(health):
	hearts.rect_size.x = health * WIDTH
	if health == 0:
		hearts.visible = false
	else:
		hearts.visible = true

func initHealth(health):
	heartsEmpty.rect_size.x = health * WIDTH
	hearts.rect_size.x = health * WIDTH

func setMaxHealth(health):
	heartsEmpty.rect_size.x = health * WIDTH

func setCointNum(value):
	coinCount.text = "x " + String(value)
