extends CanvasLayer

onready var animationPlayer = $AnimationPlayer
onready var rect = $ColorRect
var advanceLevel = false
var rng = RandomNumberGenerator.new()
var toUpgrade = false

func _ready():
	rng.randomize()

func changeScene():
	advanceLevel = true
	toUpgrade = false
	animationPlayer.play("FadeIn")

func startGame():
	toUpgrade = false
	advanceLevel = false
	animationPlayer.play("FadeIn")

func goToUpgrade():
	toUpgrade = true
	advanceLevel = false
	animationPlayer.play("FadeIn")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeIn":
		if advanceLevel:
			if PlayerStats.currentLevel == 4:
				get_tree().change_scene("res://Scenes/Level4-1.tscn")
				animationPlayer.play("FadeOut")
				PlayerStats.currentLevel += 1
				return
			elif PlayerStats.currentLevel == 5:
				get_tree().change_scene("res://Scenes/LevelEnding.tscn")
				animationPlayer.play("FadeOut")
				return
			var randNum = rng.randi_range(1, 3)
			var level = String(PlayerStats.currentLevel) + "-" + String(randNum)
			get_tree().change_scene("res://Scenes/Level" + level + ".tscn")
			PlayerStats.currentLevel += 1
		else:
			if toUpgrade:
				get_tree().change_scene("res://Scenes/LevelUpgrade.tscn")
			else:
				get_tree().change_scene("res://Scenes/Level0-1.tscn")
		animationPlayer.play("FadeOut")
