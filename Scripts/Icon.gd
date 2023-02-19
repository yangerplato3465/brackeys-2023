extends PanelContainer

func _ready():
	pass

func setIconFrame(data):
	var icon = get_child(0)
	icon.frame = data.frame
	var upgradeDecriptionLabel = get_node("UpgradeDecription/NinePatchRect/Label")
	upgradeDecriptionLabel.text = data.description



func _on_Icon_mouse_entered():
	var upgradeDecription = get_node("UpgradeDecription")
	upgradeDecription.visible = true


func _on_Icon_mouse_exited():
	var upgradeDecription = get_node("UpgradeDecription")
	upgradeDecription.visible = false
