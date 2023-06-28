extends KinematicBody2D
var inam = false;
var act_counter = 0;

enum {
	IDLE
	L_DODGE
	R_DODGE
	L_HOOK
	R_HOOK
	L_JAB
	R_JAB
}
var state = IDLE;

func _physics_process(_delta):
	if(inam == false):
		process_player_input()
	else:
		act_counter -= 1;
		action_handler();
func process_player_input():
	if(Input.is_action_just_pressed("ui_left")):
		act_counter = 51;
		state = L_DODGE
		inam = true;
	elif(Input.is_action_just_pressed("ui_right")):
		act_counter = 51;
		state = R_DODGE
		inam = true;
	elif(Input.is_action_just_pressed("ui_accept")):
		if(Input.is_action_pressed("ui_up")):
			act_counter = 27;
			state = L_JAB;
			inam = true;
		else:
			act_counter = 23;
			state = L_HOOK
			inam = true;
	elif(Input.is_action_just_pressed("ui_cancel")):
		if(Input.is_action_pressed("ui_up")):
			act_counter = 27;
			state = R_JAB;
			inam = true;
		else:
			act_counter = 23;
			state = R_HOOK
			inam = true;
	
func action_handler():
	if(act_counter <= 0): #if complicates going down, add another conditional or act_counter = 1 change states
		inam = false
		$Sprite.set_frame(0)
		position.x = 110
		position.y = 145
	match state:
		L_DODGE:
			position.x -= (act_counter - 25) / 8
			if (act_counter == 42):
				$Sprite.set_frame(2)
			elif (act_counter == 34):
				$Sprite.set_frame(3)
			elif (act_counter == 8):
				$Sprite.set_frame(2)
		R_DODGE:
			position.x += (act_counter - 25) / 8
			if (act_counter == 42):
				$Sprite.set_frame(4)
			elif (act_counter == 34):
				$Sprite.set_frame(5)
			elif (act_counter == 8):
				$Sprite.set_frame(4)
		L_JAB:
			if(act_counter == 26):
				$Sprite.set_frame(7)
				position.y -= 2
			elif(act_counter == 23):
				$Sprite.set_frame(8)
				position.y -= 5
			elif(act_counter == 21):
				position.y -= 3
			elif(act_counter == 15):
				$Sprite.set_frame(9)
				position.y -= 6
			elif(act_counter == 11 or act_counter == 10):
				position.x += 2
				#signal
			elif(act_counter == 2):
				$Sprite.set_frame(8)
				position.y += 3
		R_JAB:
			if(act_counter == 26):
				$Sprite.set_frame(11)
				position.y -= 2
			elif(act_counter == 23):
				$Sprite.set_frame(12)
				position.y -= 5
			elif(act_counter == 21):
				position.y -= 3
			elif(act_counter == 15):
				$Sprite.set_frame(13)
				position.y -= 6
			elif(act_counter == 11 or act_counter == 10):
				position.x += 2
				#signal
			elif(act_counter == 2):
				$Sprite.set_frame(12)
				position.y += 3
		L_HOOK:
			if(act_counter == 22):
				$Sprite.set_frame(6)
			if(act_counter == 19):
				$Sprite.set_frame(7)
				position.y -= 3
			if(act_counter == 16):
				$Sprite.set_frame(8)
				position.y -= 3
			if(act_counter == 3):
				$Sprite.set_frame(7)
				position.y += 3
		R_HOOK:
			if(act_counter == 22):
				$Sprite.set_frame(10)
			if(act_counter == 19):
				$Sprite.set_frame(11)
				position.y -= 3
			if(act_counter == 16):
				$Sprite.set_frame(12)
				position.y -= 3
			if(act_counter == 3):
				$Sprite.set_frame(11)
				position.y += 3
