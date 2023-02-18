extends CanvasLayer

onready var animationPlayer = $AnimationPlayer
var targetScene = null

func _ready():
	pass

func changeScene(target):
	targetScene = target
	animationPlayer.play("FadeIn")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeIn":
		if targetScene != null:
			get_tree().change_scene(targetScene)
			animationPlayer.play("FadeOut")
		
