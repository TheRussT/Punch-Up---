extends Node2D

var timer = 120
var ismoving
var isreading
var read_timer
var message
var index = 0
var partial
var mess_table = ["you undig-\nnified\namerican!\ni come from\na long line\nof sir-\nrendreres!" , "I was over-\nconfident,\ni think\ni'll\ncapitulate\nsoon!" , "I'd better\nsay au\nrevoir to\nmy family"]
# Called when the node enters the scene tree for the first time.
func _ready():
	if(GlobalScript.menu_index < 100):
		$Enemy/e_picture.set_frame(GlobalScript.fight_index * 9 + 2 * GlobalScript.round + 1)
		$Fighter/f_picture.set_frame(GlobalScript.fight_index * 9 + 2 * GlobalScript.round + 1)
		if(GlobalScript.menu_index % 3 == 0):
			$Enemy/e_age.visible = true
			$Enemy/e_weight.visible = true
			$Enemy/e_from.visible = true
			$Fighter/f_age.visible = true
			$Fighter/f_weight.visible = true
			$Fighter/f_from.visible = true
			$Enemy/e_profile.text = "\"profile\""
			if(GlobalScript.menu_index == 0):
				$Enemy/e_record.text = " 1- 8  1ko"
				$Enemy/e_name.text = "sir rendre"
				$Enemy/e_name2.text = ""
				$Enemy/e_ranked.text = "ranked: #2"
				$Enemy/e_age.text = "age: 32"
				$Enemy/e_weight.text = "weight:144"
				$Enemy/e_from.text = "from\n lyon,\n    france"
			elif(GlobalScript.menu_index == 3):
				$Enemy/e_record.text = "13-23 10ko"
				$Enemy/e_name.text = "sarwatt"
				$Enemy/e_name2.text = "the great"
				$Enemy/e_ranked.text = "ranked: #1"
				$Enemy/e_age.text = "age: 36"
				$Enemy/e_weight.text = "weight:234"
				$Enemy/e_from.text = "from\n cairo,\n     egypt"
		elif(GlobalScript.menu_index % 3 < 3):
			$Enemy/e_age.visible = false
			$Enemy/e_weight.visible = false
			$Enemy/e_from.visible = false
			$Fighter/f_age.visible = false
			$Fighter/f_weight.visible = false
			$Fighter/f_from.visible = false
			message = mess_table[1]
			isreading = true
			partial = ''
			index = 0
			read_timer = 10
	elif(GlobalScript.menu_index == 101):
		pass
	elif(GlobalScript.menu_index == 102):
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer -= 1
	if(ismoving == true):
		position.y -= 1
		if(position.y <= -224):
			ismoving = false
			GlobalScript.round += 1
			get_tree().change_scene_to_file("res://scenes/Ring.tscn")
	if(timer <= 0):
		timer = 120
		if($Enemy/e_picture.frame == GlobalScript.fight_index * 9 + 2 * GlobalScript.round + 1):
			$Enemy/e_picture.set_frame(GlobalScript.fight_index * 9 + 2 * GlobalScript.round + 2)
		elif($Enemy/e_picture.frame == GlobalScript.fight_index * 9 + 2 * GlobalScript.round + 2):
			$Enemy/e_picture.set_frame(GlobalScript.fight_index * 9 + 2 * GlobalScript.round + 1)
		if($Fighter/f_picture.frame == GlobalScript.fight_index * 9 + 2 * GlobalScript.round + 1):
			$Fighter/f_picture.set_frame(GlobalScript.fight_index * 9 + 2 * GlobalScript.round + 2)
		elif($Fighter/f_picture.frame == GlobalScript.fight_index * 9 + 2 * GlobalScript.round + 2):
			$Fighter/f_picture.set_frame(GlobalScript.fight_index * 9 + 2 * GlobalScript.round + 1)
	if Input.is_action_just_pressed("ui_select"):
		ismoving = true
		$round_number.set_frame(GlobalScript.round)
	if(isreading == true):
		read_timer -= 1
		if(read_timer <= 0):
			partial += message[index]
			index += 1
			read_timer = 10
			$Enemy/e_profile.text = partial
			if(partial == message):
				isreading = false
