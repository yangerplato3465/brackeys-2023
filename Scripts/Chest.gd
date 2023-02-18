extends StaticBody2D

onready var EKey = $Key

func _ready():
	pass


func _on_ChestArea_body_entered(body):
	if body.name == Consts.PLAYER:
		EKey.visible = true


func _on_ChestArea_body_exited(body):
	if body.name == Consts.PLAYER:
		EKey.visible = false
