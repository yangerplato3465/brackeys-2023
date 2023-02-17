extends Control


func _ready():
	pass


func _on_Back_pressed():
	SignalManager.emit_signal("hideMailPanel")
