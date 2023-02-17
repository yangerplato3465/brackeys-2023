extends Sprite

onready var EKey = $Key

func _ready():
	pass


func _on_MailArea_body_entered(body):
	if body.name == Consts.PLAYER:
		EKey.visible = true


func _on_MailArea_body_exited(body):
	if body.name == Consts.PLAYER:
		EKey.visible = false
