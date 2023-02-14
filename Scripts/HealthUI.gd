extends Control

onready var hearts = $Hearts
onready var heartsEmpty = $HeartsEmpty

const WIDTH = 30

func _ready():
	SignalManager.connect('initHealth', self, 'initHealth')
	SignalManager.connect('healthChange', self, 'setCurrentHealth')
	SignalManager.connect('maxHealthChange', self, 'setMaxHealth')
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
