extends Node2D

var ismoving = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if(GlobalScript.menu_index == 101):
		$win_lose.text = "you win"
		GlobalScript.fight_index += 1
	elif(GlobalScript.menu_index == 102):
		$win_lose.text = "you lose "
	GlobalScript.menu_index = GlobalScript.fight_index * 3
	GlobalScript.round = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(ismoving == true):
		position.y -= 1
		if(position.y <= -224):
			ismoving = false
			get_tree().change_scene_to_file("res://scenes/between_fights.tscn")
	if Input.is_action_just_pressed("ui_select"):
		if(GlobalScript.fight_index == 2):
			ismoving = true
		else:
			get_tree().change_scene_to_file("res://scenes/between_fights.tscn")
