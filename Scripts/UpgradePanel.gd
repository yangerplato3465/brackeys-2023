extends Control
var rng = RandomNumberGenerator.new()

var option1ID
var option2ID
var option3ID

func _ready():
	rng.randomize()
	createUpgrades()

func createUpgrades():
#	print(Consts.tier1Upgrades.size())
	if PlayerStats.itemTierUnlocked == 0:
		for n in 3:
			var index = rng.randi_range(0, Consts.tier1Upgrades.size() - 1)
#			print(index)
			setOptionData(Consts.tier1Upgrades[index], n + 1)
			

func setOptionData(data, optionNum):
	get_node("Option" + String(optionNum) + "/Description").text = data.description
	get_node("Option" + String(optionNum) + "/Name").text = data.name
	get_node("Option" + String(optionNum) + "/Texture").frame = data.frame
	match optionNum:
		1:
			option1ID = data.id
		2:
			option2ID = data.id
		3:
			option3ID = data.id


func _on_Back_pressed():
	pass # Replace with function body.


func _on_Reroll_pressed():
	createUpgrades()


func _on_Option1_gui_input(event):
	if event is InputEventMouseButton && event.is_pressed():
		PlayerStats.applyUpgrade(option1ID)


func _on_Option2_gui_input(event):
	if event is InputEventMouseButton && event.is_pressed():
		PlayerStats.applyUpgrade(option2ID)


func _on_Option3_gui_input(event):
	if event is InputEventMouseButton && event.is_pressed():
		PlayerStats.applyUpgrade(option3ID)
