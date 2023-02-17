extends Control
var rng = RandomNumberGenerator.new()

var option1ID
var option1Price
var option2ID
var option2Price
var option3ID
var option3Price


onready var option1 = $Option1
onready var option2 = $Option2
onready var option3 = $Option3
onready var rerollText = $Reroll/Label

func _ready():
	rng.randomize()
	createUpgrades()

func createUpgrades():
	option1.visible = true
	option2.visible = true
	option3.visible = true
	if PlayerStats.itemTierUnlocked == 0:
		for n in 3:
			var index = rng.randi_range(0, Consts.tier1Upgrades.size() - 1)
			setOptionData(Consts.tier1Upgrades[index], n + 1)
	elif PlayerStats.itemTierUnlocked == 1:
		var tier2Upgrades = Consts.tier1Upgrades + Consts.tier2Upgrades
		for n in 3:
			var index = rng.randi_range(0, tier2Upgrades.size() - 1)
			setOptionData(tier2Upgrades[index], n + 1)
	elif PlayerStats.itemTierUnlocked == 2:
		var tier3Upgrades = Consts.tier1Upgrades + Consts.tier2Upgrades + Consts.tier3Upgrades
		for n in 3:
			var index = rng.randi_range(0, tier3Upgrades.size() - 1)
			setOptionData(tier3Upgrades[index], n + 1)

func setOptionData(data, optionNum):
	var nameNode = get_node("Option" + String(optionNum) + "/Name")
	var description = get_node("Option" + String(optionNum) + "/Description")
	var texture = get_node("Option" + String(optionNum) + "/Texture")
	var priceLabel = get_node("Option" + String(optionNum) + "/Price")
	var price = 0
	description.text = data.description
	nameNode.text = data.name
	texture.frame = data.frame
	match data.tier:
		1:
			nameNode.modulate = Color.dodgerblue
			price = rng.randi_range(10, 19)
			priceLabel.text = "$ " + String(price)
		2:
			nameNode.modulate = Color.blueviolet
			price = rng.randi_range(20, 29)
			priceLabel.text = "$ " + String(price)
		3:
			price = rng.randi_range(30, 39)
			priceLabel.text = "$ " + String(price)

	match optionNum:
		1:
			option1ID = data.id
			option1Price = price
			if PlayerStats.coinCount < option1Price:
				priceLabel.modulate = Color.red
		2:
			option2ID = data.id
			option2Price = price
			if PlayerStats.coinCount < option2Price:
				priceLabel.modulate = Color.red
		3:
			option3ID = data.id
			option3Price = price
			if PlayerStats.coinCount < option3Price:
				priceLabel.modulate = Color.red
	if PlayerStats.coinCount < 10:
		rerollText.modulate = Color.red
	else:
		rerollText.modulate = Color.white
				
func checkEnoughGold():
	for n in range(1, 4):
		var priceLabel = get_node("Option" + String(n) + "/Price")
		match n:
			1:
				if PlayerStats.coinCount < option1Price:
					priceLabel.modulate = Color.red
				else:
					priceLabel.modulate = Color.black
			2:
				if PlayerStats.coinCount < option2Price:
					priceLabel.modulate = Color.red
				else:
					priceLabel.modulate = Color.black
			3:
				if PlayerStats.coinCount < option3Price:
					priceLabel.modulate = Color.red
				else:
					priceLabel.modulate = Color.black
	if PlayerStats.coinCount < 10:
		rerollText.modulate = Color.red
	else:
		rerollText.modulate = Color.white



func _on_Back_pressed():
	SignalManager.emit_signal("hideUpgradePanel")


func _on_Reroll_pressed():
	if(PlayerStats.coinCount < 10):
		return
	PlayerStats.coinCount -= 10
	SignalManager.emit_signal("setCointNum", PlayerStats.coinCount)
	createUpgrades()


func _on_Option1_gui_input(event):
	if event is InputEventMouseButton && event.is_pressed() && event.button_index == BUTTON_LEFT:
		checkEnoughGold()
		if(PlayerStats.coinCount < option1Price):
			return
		PlayerStats.coinCount -= option1Price
		SignalManager.emit_signal("setCointNum", PlayerStats.coinCount)
		PlayerStats.applyUpgrade(option1ID)
		option1.visible = false


func _on_Option2_gui_input(event):
	if event is InputEventMouseButton && event.is_pressed() && event.button_index == BUTTON_LEFT:
		checkEnoughGold()		
		if(PlayerStats.coinCount < option2Price):
			return
		PlayerStats.coinCount -= option2Price
		SignalManager.emit_signal("setCointNum", PlayerStats.coinCount)
		PlayerStats.applyUpgrade(option2ID)
		option2.visible = false


func _on_Option3_gui_input(event):
	if event is InputEventMouseButton && event.is_pressed() && event.button_index == BUTTON_LEFT:
		checkEnoughGold()
		if(PlayerStats.coinCount < option3Price):
			return
		PlayerStats.coinCount -= option3Price
		SignalManager.emit_signal("setCointNum", PlayerStats.coinCount)
		PlayerStats.applyUpgrade(option3ID)
		option3.visible = false
