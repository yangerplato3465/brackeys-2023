extends Sprite

onready var EKey = $Key
export(String, FILE) var targetScene

var playerInRange = false

func _process(delta):
	if Input.is_action_just_pressed("action") and playerInRange:
		if targetScene != null:
			Transition.changeScene(targetScene)


func _on_DoorArea_body_entered(body):
	if body.name == Consts.PLAYER:
		EKey.visible = true
		playerInRange = true


func _on_DoorArea_body_exited(body):
	if body.name == Consts.PLAYER:
		EKey.visible = false
		playerInRange = false
