extends CharacterBody2D
var inam = false;
var act_counter = 0;
signal punch(value)
signal f_health(amount)
signal stam_deplete(value,dazes)
signal f_stam(amount)
var health = 200;
var stam_max = 20
var stamina = stam_max

enum {
	IDLE, L_DODGE, R_DODGE, L_HOOK, R_HOOK,L_JAB,R_JAB,BLOCK,L_HIT,R_HIT,COOLDOWN,PARRY,BLOCKING,NO_STAM,FALLING
}
var state = IDLE;
var idle_index = 0;
var idle = [-0.75,0,8,0.75,1,8,0,1,12,-0.75,0,8,0.75,1,8,0,1,48,-0.75,0,8,0.75,1,8,0,1,12,0.75,0,8,-0.75,1,8,0,1,64]
var out_of_stam = [1,24,6,-1,23,8]
var has_no_stam = false
var direction_keys = []
var block_counter = 0

func _process(_delta):
	# Store direction keys in a "stack", ordered by when they're pressed
	if Input.is_action_just_pressed("ui_right"):
		direction_keys.push_back("ui_right")
	elif Input.is_action_just_released("ui_right"):
		direction_keys.erase("ui_right")
	if Input.is_action_just_pressed("ui_left"):
		direction_keys.push_back("ui_left")
	elif Input.is_action_just_released("ui_left"):
		direction_keys.erase("ui_left")
	if Input.is_action_just_pressed("ui_down"):
		direction_keys.push_back("ui_down")
	elif Input.is_action_just_released("ui_down"):
		direction_keys.erase("ui_down")
	if Input.is_action_just_pressed("ui_up"):
		direction_keys.push_back("ui_up")
	elif Input.is_action_just_released("ui_up"):
		direction_keys.erase("ui_up")
	if Input.is_action_just_pressed("ui_accept"):
		direction_keys.push_back("ui_accept")
	elif Input.is_action_just_released("ui_accept"):
		direction_keys.erase("ui_accept")
	if Input.is_action_just_pressed("ui_cancel"):
		direction_keys.push_back("ui_cancel")
	elif Input.is_action_just_released("ui_cancel"):
		direction_keys.erase("ui_cancel")
	if !Input.is_action_pressed("ui_right") and !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_down") and !Input.is_action_pressed("ui_up") and !Input.is_action_pressed("ui_accept") and !Input.is_action_pressed("ui_cancel"):
		direction_keys.clear()
func _physics_process(_delta):
	if(inam == false):
		if(state == IDLE):
			block_counter -= 1
			idler()
			process_player_input()
		elif(state == BLOCK):
			if(direction_keys.find("ui_up") < 0):
				$Sprite2D.set_frame(0)
				position.x = 110
				position.y = 155
				idle_index = 33
				state = IDLE
				block_counter = 16
			elif(Input.is_action_pressed("ui_accept")):
				act_counter = 29;
				state = L_JAB;
				inam = true
			elif(Input.is_action_pressed("ui_cancel")):
				act_counter = 29;
				state = R_JAB;
				inam = true
		elif(state == NO_STAM):
			no_stam()
			if( direction_keys.find("ui_left") == 0):
				act_counter = 41;
				state = L_DODGE
				inam = true;
			elif(direction_keys.find("ui_right") == 0):
				act_counter = 41;
				state = R_DODGE
				inam = true;
	else:
		act_counter -= 1;
		action_handler();
func process_player_input():
	if(direction_keys.size() != 0):
		var key = direction_keys.back()
		if Input.is_action_pressed(key):
			if(key == "ui_accept"):
				if(Input.is_action_pressed("ui_up")):
					act_counter = 29;
					state = L_JAB;
					inam = true;
				else:
					act_counter = 27;
					state = L_HOOK
					inam = true;
			elif(key == "ui_cancel"):
				if(Input.is_action_pressed("ui_up")):
					act_counter = 29;
					state = R_JAB;
					inam = true;
				else:
					act_counter = 27;
					state = R_HOOK
					inam = true;
			elif(key == "ui_left"):
				act_counter = 41;
				state = L_DODGE
				inam = true;
			elif(key == "ui_right"):
				act_counter = 41;
				state = R_DODGE
				inam = true;
			elif(key == "ui_up"):
				if(state != BLOCK):
					if(block_counter <= 0):
						act_counter = 11
						state = PARRY
						inam = true
		
func action_handler():
	if(act_counter <= 0): #if complicates going down, add another conditional or act_counter = 1 change states
		inam = false
		$Sprite2D.set_frame(0)
		position.x = 110
		position.y = 155
		idle_index = 33
		state = IDLE
		if(has_no_stam == true):
			idle_index = 0
			state = NO_STAM
	match state:
		L_DODGE:
			if(act_counter >= 32):
				$Sprite2D.set_frame(2)
				position.x -= 2.5;
			elif (act_counter >= 7):
				$Sprite2D.set_frame(3)
			elif (act_counter > 1) :
				$Sprite2D.set_frame(2)
				position.x += 2.5
		R_DODGE:
			if(act_counter >= 32):
				$Sprite2D.set_frame(4)
				position.x += 3;
			elif (act_counter >= 7):
				$Sprite2D.set_frame(5)
			elif (act_counter > 1) :
				$Sprite2D.set_frame(4)
				position.x -= 3
		L_JAB:
			if(act_counter == 28):
				$Sprite2D.set_frame(7)
				position.y -= 3
				position.x += 2
			elif(act_counter == 26):
				$Sprite2D.set_frame(8)
				position.y -= 7
				position.x +=2
			elif(act_counter == 24):
				position.y -= 5
				position.x += 2
			elif(act_counter == 23):
				$Sprite2D.set_frame(9)
				position.y -= 7
				position.x += 2
				
			elif(act_counter == 22):
				position.x += 2
				emit_signal("punch",0)
			elif(act_counter == 5):
				$Sprite2D.set_frame(8)
				position.y += 4
			elif(act_counter == 2):
				position.y += 3;
				position.x -= 1
		R_JAB:
			if(act_counter == 28):
				$Sprite2D.set_frame(11)
				position.y -= 3
				position.x += 12
			elif(act_counter == 26):
				$Sprite2D.set_frame(12)
				position.y -= 7
				position.x +=6
			elif(act_counter == 24):
				position.y -= 5
				position.x += 3
			elif(act_counter == 23):
				$Sprite2D.set_frame(13)
				position.y -= 7
				position.x -= 3
				
			elif(act_counter == 22):
				position.x -= 2
				emit_signal("punch", 1)
			elif(act_counter == 5):
				$Sprite2D.set_frame(12)
				position.y += 4
			elif(act_counter == 2):
				position.y += 3
				position.x -= 2
		L_HOOK:
			if(act_counter == 28):
				$Sprite2D.set_frame(6)
				position.x += 4
			elif(act_counter == 25):
				emit_signal("punch", 2)
				$Sprite2D.set_frame(7)
				position.y -= 3
				position.x += 5
			elif(act_counter == 22):
				$Sprite2D.set_frame(8)
				position.y -= 3
				position.x += 6
			elif(act_counter == 6):
				$Sprite2D.set_frame(7)
				position.y += 3
		R_HOOK:
			if(act_counter == 28):
				$Sprite2D.set_frame(10)
				position.x += 12
			elif(act_counter == 25):
				$Sprite2D.set_frame(11)
				position.x += 8
				position.y -= 3
				emit_signal("punch", 3)
			elif(act_counter == 22):
				$Sprite2D.set_frame(12)
				position.x +=5
				position.y -= 3
			elif(act_counter == 6):
				$Sprite2D.set_frame(11)
				position.y += 3
		L_HIT:
			if(act_counter == 34):
				$Sprite2D.set_frame(17)
				position.x -= 4
				position.y += 4
			elif(act_counter == 31):
				$Sprite2D.set_frame(18)
				position.y += 4
				position.x -= 4
			elif(act_counter == 28):
				if(health <= 0):
					print("knockdown")
					state = FALLING
					act_counter = 29
			elif(act_counter == 2):
				state = COOLDOWN
				act_counter = 16
				position.x = 110
				position.y = 155
		R_HIT:
			if(act_counter == 34):
				$Sprite2D.set_frame(14)
				position.x += 6
				position.y += 4
			elif(act_counter == 31):
				$Sprite2D.set_frame(15)
				position.y += 4
				position.x += 4
			elif(act_counter == 28):
				if(health <= 0):
					print("knockdown")
					state = FALLING
					act_counter = 29
			elif(act_counter == 2):
				state = COOLDOWN
				act_counter = 16
				position.x = 110
				position.y = 155
		COOLDOWN:
			if(act_counter == 15):
				$Sprite2D.set_frame(20)
			elif(act_counter == 7):
				$Sprite2D.set_frame(19)
		PARRY:
			if(Input.is_action_pressed("ui_accept")):
				act_counter = 29;
				state = L_JAB;
			elif(Input.is_action_pressed("ui_cancel")):
				act_counter = 29;
				state = R_JAB;
			if(act_counter == 8):
				$Sprite2D.set_frame(21)
			if(act_counter == 5):
				$Sprite2D.set_frame(22)
			if(act_counter == 2):
				inam = false
				state = BLOCK
		BLOCKING:
			if(act_counter == 9):
				$Sprite2D.set_frame(22)
				position.y += 4
			elif(act_counter == 6):
				position.y += 2
			elif(act_counter == 2):
				block_counter = 14
		FALLING:
			if(act_counter == 28):
				position.y += 4
			elif(act_counter == 25):
				position.y += 5
			elif(act_counter == 22):
				position.y += 5
			elif(act_counter == 18):
				position.y +=5
			elif(act_counter == 12):
				position.y += 5
				$Sprite2D.set_frame(16)
			elif(act_counter ==1):
				pass
func idler():
	act_counter -= 1;
	position.x += idle[idle_index - 3]
	if(act_counter <= 0):
		$Sprite2D.set_frame(idle[idle_index +1])
		act_counter = idle[idle_index + 2]
		idle_index = (idle_index + 3) % 36


func _on_enemy_attack(type,damage):
	if(state != R_HIT and state != L_HIT and state != BLOCKING):
		if(((state == R_DODGE or state == L_DODGE) and act_counter > 12)):
			if(has_no_stam == true):
				stamina += stam_max/5
				print(str(stamina))
				if(stamina >= stam_max):
					stamina = stam_max
					check_stam(0)
					has_no_stam = false
		elif(type > 5):
			pass
		elif(type == 5):
			pass
		elif(type == 4):
			pass
		else:
			if(type <= 1 and state == PARRY and act_counter < 6):
				emit_signal("stam_deplete",3,true)
				act_counter = 12
				state = BLOCKING
				inam = true
			elif(type <= 1 and state == BLOCK):
				check_stam(1)
				act_counter = 12
				state = BLOCKING
				inam = true
				#check stam
			elif((state != R_DODGE and state != L_DODGE) or ((state == R_DODGE or state == L_DODGE) and act_counter <= 12)):
				position.x = 110
				position.y = 155
				if((type % 2) == 0):
					state = L_HIT
					act_counter = 35
					inam = true
					health -= damage
					check_stam(damage/20)
					emit_signal("f_health",health)
				else:
					state = R_HIT
					act_counter = 35
					inam = true
					health -= damage
					check_stam(damage/20)
					emit_signal("f_health",health)

func check_stam(amount):
	stamina -= amount
	emit_signal("f_stam", stamina)
	if(stamina <= 0):
		has_no_stam = true
		state = NO_STAM
		idle_index = 0
func no_stam():
	act_counter -= 1;
	if(act_counter <= 0):
		position.y += out_of_stam[idle_index]
		$Sprite2D.set_frame(out_of_stam[idle_index +1])
		act_counter = out_of_stam[idle_index + 2]
		idle_index = (idle_index + 3) % 6


func _on_enemy_blocked(value):
	check_stam(value)
