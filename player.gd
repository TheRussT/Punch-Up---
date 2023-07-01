extends KinematicBody2D
var inam = false;
var act_counter = 0;
signal punch(value)

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
var idle_index = 0;
var idle = [-0.75,0,8,0.75,1,8,0,1,12,-0.75,0,8,0.75,1,8,0,1,48,-0.75,0,8,0.75,1,8,0,1,12,0.75,0,8,-0.75,1,8,0,1,64]

func _physics_process(_delta):
	if(inam == false):
		process_player_input()
		idler()
	else:
		act_counter -= 1;
		action_handler();
func process_player_input():
	if(Input.is_action_just_pressed("ui_left")):
		act_counter = 41;
		state = L_DODGE
		inam = true;
	elif(Input.is_action_just_pressed("ui_right")):
		act_counter = 41;
		state = R_DODGE
		inam = true;
	elif(Input.is_action_just_pressed("ui_accept")):
		if(Input.is_action_pressed("ui_up")):
			act_counter = 27;
			state = L_JAB;
			inam = true;
			emit_signal("punch",0)
		else:
			act_counter = 23;
			state = L_HOOK
			inam = true;
			emit_signal("punch", 2)
	elif(Input.is_action_just_pressed("ui_cancel")):
		if(Input.is_action_pressed("ui_up")):
			act_counter = 27;
			state = R_JAB;
			inam = true;
			emit_signal("punch", 1)
		else:
			act_counter = 23;
			state = R_HOOK
			inam = true;
			emit_signal("punch", 3)
	
func action_handler():
	if(act_counter <= 0): #if complicates going down, add another conditional or act_counter = 1 change states
		inam = false
		$Sprite.set_frame(0)
		position.x = 110
		position.y = 145
		idle_index = 33
	match state:
		L_DODGE:
			if(act_counter >= 32):
				$Sprite.set_frame(2)
				position.x -= 2.5;
			elif (act_counter >= 7):
				$Sprite.set_frame(3)
			elif (act_counter > 1) :
				$Sprite.set_frame(2)
				position.x += 2.5
		R_DODGE:
			if(act_counter >= 32):
				$Sprite.set_frame(4)
				position.x += 3;
			elif (act_counter >= 7):
				$Sprite.set_frame(5)
			elif (act_counter > 1) :
				$Sprite.set_frame(4)
				position.x -= 3
		L_JAB:
			if(act_counter == 26):
				$Sprite.set_frame(7)
				position.y -= 2
			elif(act_counter == 24):
				$Sprite.set_frame(8)
				position.y -= 5
			elif(act_counter == 22):
				position.y -= 3
			elif(act_counter == 16):
				$Sprite.set_frame(9)
				position.y -= 6
				position.x += 2
			elif(act_counter == 12 or act_counter == 11):
				position.x += 2
				#signal
			elif(act_counter == 2):
				$Sprite.set_frame(8)
				position.y += 3
		R_JAB:
			if(act_counter == 26):
				$Sprite.set_frame(11)
				position.y -= 2
				position.x += 16
			elif(act_counter == 24):
				$Sprite.set_frame(12)
				position.y -= 5
				position.x +=10
			elif(act_counter == 22):
				position.y -= 3
				position.x += 5
			elif(act_counter == 16):
				$Sprite.set_frame(13)
				position.y -= 6
				position.x -= 2
			elif(act_counter == 12 or act_counter == 11):
				position.x -= 2
				#signal
			elif(act_counter == 2):
				$Sprite.set_frame(12)
				position.y += 3
		L_HOOK:
			if(act_counter == 22):
				$Sprite.set_frame(6)
				position.x += 4
			if(act_counter == 19):
				$Sprite.set_frame(7)
				position.y -= 3
				position.x += 5
			if(act_counter == 16):
				$Sprite.set_frame(8)
				position.y -= 3
				position.x += 6
			if(act_counter == 3):
				$Sprite.set_frame(7)
				position.y += 3
		R_HOOK:
			if(act_counter == 22):
				$Sprite.set_frame(10)
				position.x += 12
			if(act_counter == 19):
				$Sprite.set_frame(11)
				position.x += 8
				position.y -= 3
			if(act_counter == 16):
				$Sprite.set_frame(12)
				position.x +=5
				position.y -= 3
			if(act_counter == 3):
				$Sprite.set_frame(11)
				position.y += 3
func idler():
	act_counter -= 1;
	position.x += idle[idle_index - 3]
	if(act_counter <= 0):
		$Sprite.set_frame(idle[idle_index +1])
		act_counter = idle[idle_index + 2]
		idle_index = (idle_index + 3) % 36
