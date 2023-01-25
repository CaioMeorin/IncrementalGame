extends Control
onready var playerFirst: bool
onready var enemyHP = $enemyContainer/healthBar
onready var playerHP = $playerPanel/playerData/healthBar
onready var choice
onready var playerName = GameState.playername
onready var rng = RandomNumberGenerator.new()

func _ready():
	getMonsterTexture()
	GameState.enemyLoad()
	GameState.get_player()
	
	enemyHP.max_value = GameState.enemy.MaxHP
	enemyHP.value = GameState.enemy.CurrentHP
	playerHP.max_value = GameState.playerStats[playerName].MaxHP
	playerHP.value = GameState.playerStats[playerName].CurrentHP
	
	$playerPanel/playerData/Player.text = GameState.playerStats.keys()[0]
	$enemyContainer/EnemyName.text = GameState.enemyName
	

func battle():
	choice = ''
	var player_dmg = calculateDamage(GameState.playerStats[playerName], "STR")
	var enemy_dmg = calculateDamage(GameState.enemy, "STR")
	
	print(player_dmg, enemy_dmg)
	
	if playerFirst:
		
		if checkHP(enemyHP, player_dmg):
			doDamage(enemyHP, player_dmg)
			
		if !checkHP(enemyHP,player_dmg):
			$playerPanel/playerData/playerActions/attackButton.disabled = true
			$playerPanel/playerData/playerActions/Button2.disabled = true
			$playerPanel/playerData/playerActions/runButton.disabled = true
			enemyHP.value = 0
			GameState.currentHP = playerHP.value
			GameState.set_player()
			if !$BattleTerminated.visible:
				$BattleTerminated.visible = true
				return 0
			
		if checkHP(playerHP, enemy_dmg):
			doDamage(playerHP, enemy_dmg)

		if !checkHP(playerHP, enemy_dmg):
			$playerPanel/playerData/playerActions/attackButton.disabled = true
			$playerPanel/playerData/playerActions/Button2.disabled = true
			$playerPanel/playerData/playerActions/runButton.disabled = true
			playerHP.value = 0
			if !$BattleTerminated.visible:
				$BattleTerminated.visible = true
				return 0
		

		
	else:
		if checkHP(playerHP, enemy_dmg):
			doDamage(playerHP, enemy_dmg)
		
		if !checkHP(playerHP, enemy_dmg):
			playerHP.value = 0
			if !$BattleTerminated.visible:
				$BattleTerminated.visible = true
				return 0
			
		if checkHP(enemyHP, player_dmg):
			doDamage(enemyHP, player_dmg)
			
		if !checkHP(enemyHP, player_dmg):
			enemyHP.value = 0
			GameState.currentHP = playerHP.value
			GameState.set_player()
			if !$BattleTerminated.visible:
				$BattleTerminated.visible = true
				return 0



func _process(delta):

	if choice:
		battle()
		
	if $playerPanel/RunPanel.visible and Input.is_action_pressed("ui_select"):
		$playerPanel/RunPanel.visible = false

func _on_attackButton_pressed():
	
	choice = "attack"
	decideTurn()
	

func doDamage(entity, damage):
		entity.value = entity.value - damage

func calculateDamage(entity, attribute):
	var dmg = int(entity[attribute] * 1.2)
	return dmg

func checkHP(entityHP, damage):
	if entityHP.value <= entityHP.min_value:
		entityHP.value = entityHP.min_value
		return false
	else:
		return true


func decideTurn():
	if GameState.playerStats[playerName].DEX >= GameState.enemy.DEX:
		playerFirst = true
	else:
		playerFirst = false


func _on_runButton_pressed():
	rng.randomize()
	
	if GameState.playerStats[playerName].DEX > GameState.enemy.DEX and rng.randi_range(0,100) < 90:
		GameState.playerStats[playerName] = playerHP.value
		get_tree().change_scene("res://Data/Scenes/Levels/Rooms.tscn")
	elif rng.randi_range(0,100) < 30:
		GameState.playerStats[playerName] = playerHP.value
		get_tree().change_scene("res://Data/Scenes/Levels/Rooms.tscn")
	else:
		$playerPanel/RunPanel.visible = true
		var enemy_dmg = calculateDamage(GameState.enemy, "STR")
		doDamage(playerHP, enemy_dmg)


func _on_ConfirmationDialog_confirmed():
	
	if playerHP.value <= 0:
		GameState.currentHP = GameState.playerStats[playerName].MaxHP
		GameState.set_player()
		get_tree().change_scene("res://Data/Scenes/Systems/PlayerCreation.tscn")
				
	elif playerHP.value != 0 and len(GameState.roomContent1) >= 1:
		match GameState.roomContent1[0]:
			1:
				GameState.roomContent1.pop_at(0)
				GameState.isBoss = true
				get_tree().change_scene("res://Data/Scenes/Systems/Battle.tscn")
			2:
				GameState.roomContent1.pop_at(0)
				GameState.isBoss = false
				get_tree().change_scene("res://Data/Scenes/Systems/Battle.tscn")
			3:
				GameState.roomContent1.pop_at(0)
				get_tree().change_scene("res://Data/Scenes/Systems/Treasure.tscn")
			_:
				GameState.roomContent1.pop_at(0)
				get_tree().change_scene("res://Data/Scenes/Levels/Rooms.tscn")
	else:
		get_tree().change_scene("res://Data/Scenes/Levels/Rooms.tscn")


func getMonsterTexture():
	var rng_image = RandomNumberGenerator.new()
	rng_image.randomize()
	var dirPath
	var dir = Directory.new()
	var img_list = []
	
	dirPath = OS.get_executable_path().get_base_dir()
	dirPath += "/Data/Resources/Graphics/Monsters/"

	if dir.open(dirPath) == OK:
		dir.list_dir_begin()
		while true:
			var file = dir.get_next()
			if file == "":
				break
			if file.begins_with("monster"):
				if ".import" in file:
					continue
				elif dirPath+file in img_list:
					break
				else:
					
					img_list.append(dirPath+file)
		var texture = load(str(img_list[rng_image.randi_range(0,len(img_list)-1)]))
		$enemyContainer/enemyGraphics.texture = texture
		$enemyContainer/enemyGraphics.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		$enemyContainer/enemyGraphics.margin_bottom = 196
		$enemyContainer/enemyGraphics.margin_right = 632
		
