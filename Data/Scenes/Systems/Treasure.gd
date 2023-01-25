extends Control



func _on_Button_pressed():
	if len(GameState.roomContent1) >= 1:
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
