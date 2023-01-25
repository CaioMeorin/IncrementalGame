extends Node

onready var playerStats: Dictionary
onready var player
onready var playername: String
onready var maxhealth: int

onready var initial_strength: int
onready var initial_intelligence: int
onready var initial_dexterity: int
onready var initial_luck: int
onready var initial_wisdom: int
onready var currentHP: int
onready var isBoss: bool

onready var enemy
onready var enemyName: String
onready var enemyStats: Dictionary

onready var roomContent1 = []
onready var roomContent2 = []





func statsLoad():
	
	var playerStatsFile = File.new()
	if not playerStatsFile.file_exists("res://Data/PlayerData/"+playername+".json"):
		newCharacter()
		return
	
	playerStatsFile.open("res://Data/PlayerData/"+playername+".json", File.READ)
	playerStats = parse_json(playerStatsFile.get_as_text())
	

func enemyLoad():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var enemyStatsFile = File.new()
	
	if !isBoss:
		enemyStatsFile.open("res://Data/EnemyData/Enemies.json", File.READ)
		enemyStats = parse_json(enemyStatsFile.get_as_text())
		enemyName = enemyStats.keys()[rng.randi_range(0,len(enemyStats.keys())-1)]
		enemy = enemyStats[enemyName]
	else:
		enemyStatsFile.open("res://Data/EnemyData/Bosses.json", File.READ)
		enemyStats = parse_json(enemyStatsFile.get_as_text())
		enemyName = enemyStats.keys()[rng.randi_range(0,len(enemyStats.keys())-1)]
		enemy = enemyStats[enemyName]
	
func newCharacter():
	var playerStatsFile = File.new()
	playerStatsFile.open("res://Data/PlayerData/"+playername+".json", File.WRITE)
	
	
	#NEW STATS
	var defaultStats ={
		playername:
		{
		"MaxHP": maxhealth,
		"CurrentHP": maxhealth,

		
		"STR":initial_strength,
		"INT":initial_intelligence,
		"DEX":initial_dexterity,
		"LUK":initial_luck,
		"WIS":initial_wisdom
		}
		}
	#NEWSTATS

	playerStatsFile.store_line(JSON.print(defaultStats))
	print("Player Salvo")
	
func get_player():
	statsLoad()
	
func set_player():
	var playerStatsFile = File.new()
	playerStatsFile.open("res://Data/PlayerData/"+playername+".json", File.WRITE)
	
	
	#NEW STATS
	var defaultStats ={
		playername:
		{
		"MaxHP": maxhealth,
		"CurrentHP": currentHP,

		
		"STR":initial_strength,
		"INT":initial_intelligence,
		"DEX":initial_dexterity,
		"LUK":initial_luck,
		"WIS":initial_wisdom
		}
		}
	#NEWSTATS

	playerStatsFile.store_line(JSON.print(defaultStats))
	print("Player Salvo")
