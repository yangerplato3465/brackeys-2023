extends Node

const BULLET_HITBOX = "BulletHitbox"
const PLAYER = "Player"
const WALLS = "Walls"
const COIN_AREA = "CoinArea"
const NPC_AREA = "NpcArea"
const MAIL_AREA = "MailArea"
const PLAYER_COIN_HITBOX = "PlayerCoinHitbox"

var tier1Upgrades = [
	{
		"id": 0,
		"frame": 16,
		"name": "Strong Heart",
		"description": "Increase max health by 1",
		"tier": 1
	},
	{
		"id": 1,
		"frame": 159,
		"name": "Bondage",
		"description": "Increase health gain when entering new area",
		"tier": 1
	},
	{
		"id": 4,
		"frame": 156,
		"name": "Mini Healing Potion",
		"description": "Heal 1 health",
		"tier": 1
	},
	{
		"id": 5,
		"frame": 148,
		"name": "Potion Master",
		"description": "Chance to drop a potion on kill",
		"tier": 1
	},
	{
		"id": 6,
		"frame": 81,
		"name": "Knight's Sword",
		"description": "Increate attack damage by 20%",
		"tier": 1
	},
	{
		"id": 9,
		"frame": 112,
		"name": "Archer's Hat",
		"description": "Increase attack speed by 20%",
		"tier": 1
	},
	{
		"id": 14,
		"frame": 130,
		"name": "Swifty Boots",
		"description": "Increase move speed by 10%",
		"tier": 1
	},
	{
		"id": 15,
		"frame": 202,
		"name": "Money Maker",
		"description": "Enemies drop more coins when killed",
		"tier": 1
	},
	{
		"id": 12,
		"frame": 134,
		"name": "Lucky Charm",
		"description": "Higher chance for rare items to appear in shop",
		"tier": 1
	},
]

var tier2Upgrades = [
	{
		"id": 3,
		"frame": 144,
		"name": "Healing Potion",
		"description": "Heal 3 health",
		"tier": 2
	},
	{
		"id": 18,
		"frame": 61,
		"name": "Sticky Bullet",
		"description": "Attacks slows enemies by 30%",
		"tier": 2
	},
	{
		"id": 19,
		"frame": 175,
		"name": "Hour Glass",
		"description": "Increase invincibility frame by 20%",
		"tier": 2
	},
	{
		"id": 16,
		"frame": 204,
		"name": "Buisness Man",
		"description": "Shop items are 20% cheaper",
		"tier": 2
	},
	{
		"id": 13,
		"frame": 131,
		"name": "Nimbus Boots",
		"description": "Decrease roll colldown by 20%",
		"tier": 2
	},
	{
		"id": 10,
		"frame": 121,
		"name": "Archer's Tunic",
		"description": "Increase attack speed by 40%",
		"tier": 2
	},
	{
		"id": 7,
		"frame": 82,
		"name": "Knight's Ancient Sword",
		"description": "Increate attack damage by 40%",
		"tier": 2
	},
]

var tier3Upgrades = [
	{
		"id": 2,
		"frame": 152,
		"name": "Super Healing Potion",
		"description": "Heal to full health",
		"tier": 3
	},
	{
		"id": 17,
		"frame": 59,
		"name": "Berserker's Wrath",
		"description": "Deals double damage when close to death",
		"tier": 3
	},
	{
		"id":11,
		"frame": 124,
		"name": "Archer's Underwear",
		"description": "Increase attack speed by 60%",
		"tier": 3
	},
	{
		"id": 8,
		"frame": 89,
		"name": "Knight's Double Dagger",
		"description": "Increate attack damage by 60%",
		"tier": 3
	},
]

enum {
	IGNORE = 10
}
