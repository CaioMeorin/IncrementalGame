extends Control

onready var totalPointsValue
onready var hPoints
onready var strengthPoints
onready var intPoints
onready var dexPoints
onready var lukPoints
onready var wisPoints
onready var pointsAvailableLabel = $playerStats/Points
onready var labelHP
onready var labelSTR
onready var labelINT
onready var labelDEX
onready var labelLUK
onready var labelWIS

func _ready():
	hPoints = $playerStats/maxhealth
	strengthPoints = $playerStats/str
	intPoints = $playerStats/int
	dexPoints = $playerStats/dex
	lukPoints = $playerStats/luk
	wisPoints = $playerStats/wis
	

	
	labelHP = $playerStats/MaxHP
	labelSTR = $playerStats/Strength
	labelINT = $playerStats/Intelligence
	labelDEX = $playerStats/Dexterity
	labelLUK = $playerStats/Luck
	labelWIS = $playerStats/Wisdom

func _process(delta):

	labelHP.text = "Total HP: "+ str(100 +hPoints.value)
	labelSTR.text = "Strength: " + str(strengthPoints.value)
	labelINT.text = "Intelligence: " + str(intPoints.value)
	labelDEX.text = "Dexterity: " + str(dexPoints.value)
	labelLUK.text = "Luck: " + str(lukPoints.value)
	labelWIS.text = "Wisdom: " + str(wisPoints.value)
	
	totalPointsValue = 60 - (hPoints.value + strengthPoints.value + intPoints.value + 
							dexPoints.value + lukPoints.value + wisPoints.value)
							
	if totalPointsValue <= 0:
		totalPointsValue = 0
		
	hPoints.max_value = hPoints.value + totalPointsValue
	strengthPoints.max_value = strengthPoints.value + totalPointsValue
	intPoints.max_value = intPoints.value + totalPointsValue
	dexPoints.max_value = dexPoints.value + totalPointsValue
	lukPoints.max_value = lukPoints.value + totalPointsValue
	wisPoints.max_value = wisPoints.value + totalPointsValue
		
	
	pointsAvailableLabel.text = "Points Available: "+str(totalPointsValue)
	
	
	#Create Character on ENTER
	if Input.is_action_pressed("ui_accept") and $playerStats/Name.text != "":
		createCharacter()

#LOADS NEXT SCENE
func createCharacter():
	GameState.playername = $playerStats/nomeInput.text
	
	GameState.maxhealth= 100 + hPoints.value
	GameState.initial_strength= strengthPoints.value
	GameState.initial_intelligence=intPoints.value
	GameState.initial_dexterity= dexPoints.value
	GameState.initial_luck= lukPoints.value
	GameState.initial_wisdom= wisPoints.value
					
	GameState.statsLoad()
	get_tree().change_scene("res://Data/Scenes/Levels/Rooms.tscn")

func _on_Button_pressed():
	if $playerStats/Name.text != "":
		createCharacter()
