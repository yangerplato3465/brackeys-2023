extends PanelContainer

var upgradeData = null

func _ready():
	pass

func setIconFrameAndData(data):
	var icon = get_child(0)
	var upgradeDecriptionLabel = get_node("UpgradeDecription/NinePatchRect/Label")
	upgradeData = data
	icon.frame = data.frame
	upgradeDecriptionLabel.text = data.description

func _on_IconButton_mouse_exited():
	var upgradeDecription = get_node("UpgradeDecription")
	upgradeDecription.visible = false


func _on_IconButton_mouse_entered():
	var upgradeDecription = get_node("UpgradeDecription")
	upgradeDecription.visible = true


func _on_IconButton_gui_input(event):
	if event is InputEventMouseButton && event.is_pressed() && event.button_index == BUTTON_LEFT:
		PlayerStats.upgradeForNextRun = upgradeData
