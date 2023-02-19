extends Control
var rng = RandomNumberGenerator.new()

var option1Price
var option1Data
var option2Price
var option2Data
var option3Price
var option3Data

var option1Bought = false
var option2Bought = false
var option3Bought = false

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
	option1Bought = false
	option2Bought = false
	option3Bought = false
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
	checkEnoughGold()

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
			price = int(round(rng.randi_range(10, 19) * PlayerStats.shopItemCostMultiplier))
			priceLabel.text = "$ " + String(price)
		2:
			nameNode.modulate = Color.blueviolet
			price = int(round(rng.randi_range(20, 29) * PlayerStats.shopItemCostMultiplier))
			priceLabel.text = "$ " + String(price)
		3:
			price = int(round(rng.randi_range(30, 39) * PlayerStats.shopItemCostMultiplier))
			priceLabel.text = "$ " + String(price)

	match optionNum:
		1:
			option1Price = price
			option1Data = data
			if PlayerStats.coinCount < option1Price:
				priceLabel.modulate = Color.red
		2:
			option2Price = price
			option2Data = data
			if PlayerStats.coinCount < option2Price:
				priceLabel.modulate = Color.red
		3:
			option3Price = price
			option3Data = data
			if PlayerStats.coinCount < option3Price:
				priceLabel.modulate = Color.red
	if PlayerStats.coinCount < 10:
		rerollText.modulate = Color.red
	else:
		rerollText.modulate = Color.white
				
func checkEnoughGold():
	$clickAudio.play()
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
		SignalManager.emit_signal("updateTabView", option1Data)
		SignalManager.emit_signal("updateSelectView", option1Data)
		PlayerStats.applyUpgrade(option1Data.id)
		option1.visible = false
		option1Bought = true
		if option2Bought && option3Bought:
			createUpgrades()


func _on_Option2_gui_input(event):
	if event is InputEventMouseButton && event.is_pressed() && event.button_index == BUTTON_LEFT:
		checkEnoughGold()		
		if(PlayerStats.coinCount < option2Price):
			return
		PlayerStats.coinCount -= option2Price
		SignalManager.emit_signal("setCointNum", PlayerStats.coinCount)
		SignalManager.emit_signal("updateTabView", option2Data)
		SignalManager.emit_signal("updateSelectView", option2Data)
		PlayerStats.applyUpgrade(option2Data.id)
		option2.visible = false
		option2Bought = true
		if option1Bought && option3Bought:
			createUpgrades()


func _on_Option3_gui_input(event):
	if event is InputEventMouseButton && event.is_pressed() && event.button_index == BUTTON_LEFT:
		checkEnoughGold()
		if(PlayerStats.coinCount < option3Price):
			return
		PlayerStats.coinCount -= option3Price
		SignalManager.emit_signal("setCointNum", PlayerStats.coinCount)
		SignalManager.emit_signal("updateTabView", option3Data)
		SignalManager.emit_signal("updateSelectView", option3Data)
		PlayerStats.applyUpgrade(option3Data.id)
		option3.visible = false
		option3Bought = true
		if option2Bought && option1Bought:
			createUpgrades()
