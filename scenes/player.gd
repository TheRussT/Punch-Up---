extends CharacterBody2D
var inam = false;
var act_counter = 0;
signal punch(value)
signal f_health(amount)
signal stam_deplete(value,dazes)
signal f_stam(amount)
signal count_init(state,techko)
signal ko_to_enemy(state, wait)
signal set_speed(amount)
signal score_star(amount)
@export var health = 96;
var star_count = 0
var stam_max = 20
var stamina = stam_max
var game_state = "main"
var mash = 40
var mash_co = 2
var ko_count = 0
var dodge_timer = 0
var is_blocked = false
var pos_table = [2,1,2,2]

enum {
	IDLE, L_DODGE, R_DODGE, L_HOOK, R_HOOK,L_JAB,R_JAB,BLOCK,L_HIT,R_HIT,COOLDOWN,PARRY,BLOCKING,NO_STAM,FALLING,STAR_PUNCH
}

enum{
	WALK_UP, WALK_DOWN, DOWN, NONE, EXCERCISE, GETTING_UP, WALKING_UP
}
var state = IDLE;
var idle_index = 0;
var idle = [-1,1,2, -2,0,2, -4,0,9, 1,0,2, 2,1,2, 4,1,25, -1,1,2, -2,0,2, -4,0,9, 1,0,2, 2,1,2, 4,1,61, -1,1,2, -2,0,2, -4,0,9, 1,0,2, 2,1,2, 4,1,25, 1,1,2, 2,0,2, 4,0,9, -1,0,2, -2,1,2, -4,1,73]
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
	if Input.is_action_just_pressed("ui_select"):
		direction_keys.push_back("ui_select")
	elif Input.is_action_just_released("ui_select"):
		direction_keys.erase("ui_select")
	if !Input.is_action_pressed("ui_right") and !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_down") and !Input.is_action_pressed("ui_up") and !Input.is_action_pressed("ui_accept") and !Input.is_action_pressed("ui_cancel") and !Input.is_action_pressed("ui_select"):
		direction_keys.clear()
func _physics_process(_delta):
	if(game_state == "main"):
		#print(str(direction_keys))
		if(inam == false):
			if(dodge_timer > 0):
				dodge_timer -= 1
			if(state == IDLE):
				block_counter -= 1
				idler()
				process_player_input()
			elif(state == BLOCK):
				if(direction_keys.has("ui_up") == false):
					$Sprite2D.set_frame(0)
					position.x = 114
					position.y = 155
					idle_index = 33
					state = IDLE
					block_counter = 16
				elif(direction_keys.has("ui_accept") == true):
					#print("from block")
					act_counter = 27;
					state = L_JAB;
					inam = true
				elif(direction_keys.has("ui_cancel") == true):
					#print("from block")
					act_counter = 27;
					state = R_JAB;
					inam = true
			elif(state == NO_STAM):
				no_stam()
				if(direction_keys.has("ui_left") == true):
					act_counter = 45;
					state = L_DODGE
					inam = true;
				elif(direction_keys.has("ui_right") == true):
					act_counter = 45;
					state = R_DODGE
					inam = true;
		else:
			act_counter -= 1;
			#print(str(act_counter))
			action_handler();
	else:
		if(inam == true):
			act_counter -= 1
		ko_handler()
func process_player_input():
	if(direction_keys.size() != 0):
		var key = direction_keys.back()
		if Input.is_action_pressed(key):
			position.x = 110
			if(key == "ui_accept"):
				emit_signal("set_speed",60)
				if(Input.is_action_pressed("ui_up")):
					act_counter = 27;
					state = L_JAB;
					inam = true;
					#print("from process")
				else:
					act_counter = 26;
					state = L_HOOK
					inam = true;
			elif(key == "ui_cancel"):
				emit_signal("set_speed",60)
				if(Input.is_action_pressed("ui_up")):
					#print("from process")
					act_counter = 27;
					state = R_JAB;
					inam = true;
				else:
					act_counter = 26;
					state = R_HOOK
					inam = true;
			elif(key == "ui_left" and dodge_timer <= 0):
				act_counter = 45;
				state = L_DODGE
				inam = true;
			elif(key == "ui_right" and dodge_timer <= 0):
				act_counter = 45;
				state = R_DODGE
				inam = true;
			elif(key == "ui_up"):
				if(state != BLOCK):
					if(block_counter <= 0):
						act_counter = 11
						state = PARRY
						inam = true
			elif(key == "ui_select"):
				if(star_count > 0):
					if(star_count == 3):
						act_counter = 55
					elif(star_count == 2):
						act_counter = 47
					else:
						act_counter = 39
					state = STAR_PUNCH
					inam = true
		
func action_handler():
	if(act_counter <= 0): #if complicates going down, add another conditional or act_counter = 1 change states
		inam = false
		$Sprite2D.set_frame(0)
		position.x = 114
		position.y = 155
		idle_index = 69
		state = IDLE
		pos_table = [2,1,2,2]
		if(has_no_stam == true):
			idle_index = 0
			state = NO_STAM
	match state:
		L_DODGE:
			if(act_counter == 44):
				$Sprite2D.set_frame(0)
				position.x -= 3
				position.y -= 3
			elif (act_counter == 42):
				position.x -= 2
			elif (act_counter == 41):
				position.x -= 3
			elif (act_counter == 40):
				position.x -= 3
				pos_table = [1,2,2,2]
			elif (act_counter == 39):
				position.x -= 3
				position.y +=3
			elif (act_counter == 37):
				position.x -= 2
				$Sprite2D.set_frame(2)
			elif (act_counter == 35):
				position.x -= 5
				$Sprite2D.set_frame(3)
			elif(act_counter == 29):
				if(direction_keys.has("ui_left") == false):
					act_counter = 18
					if(direction_keys.has("ui_right") == true):
						act_counter = 14
						#print("earl")
			elif(act_counter == 13):
				direction_keys.erase("ui_left")
				position.x += 5
				$Sprite2D.set_frame(1)
			elif(act_counter == 10):
				$Sprite2D.set_frame(0)
				position.y -= 3
			elif(act_counter == 8):
				position.x += 1
				pos_table = [2,1,2,2]
			elif(act_counter == 7):
				position.x += 2
			elif(act_counter == 6):
				position.x += 3
			elif(act_counter == 5):
				position.x += 3
			elif(act_counter == 4):
				position.x += 3
			elif(act_counter == 1):
				position.x += 3
				position.y += 3
				dodge_timer = 6
		R_DODGE:
			if(act_counter == 44):
				$Sprite2D.set_frame(0)
				position.x += 3
				position.y -= 3
			elif (act_counter == 42):
				position.x += 3
			elif (act_counter == 41):
				$Sprite2D.flip_h = true
				position.x += 4
			elif (act_counter == 40):
				position.x += 3
				pos_table = [2,2,1,2]
			elif (act_counter == 39):
				position.x += 3
				position.y +=3
			elif (act_counter == 37):
				position.x += 4
				$Sprite2D.set_frame(2)
			elif (act_counter == 35):
				position.x += 7
				$Sprite2D.set_frame(3)
			elif(act_counter == 29):
				if(direction_keys.has("ui_right") == false):
					act_counter = 18
					if(direction_keys.has("ui_left") == true):
						act_counter = 14
					#print("early")
			elif(act_counter == 13):
				direction_keys.erase("ui_right")
				position.x -= 7
				$Sprite2D.set_frame(1)
			elif(act_counter == 10):
				$Sprite2D.set_frame(0)
				position.y -= 5
			elif(act_counter == 8):
				pos_table = [2,1,2,2]
				position.x -= 1
			elif(act_counter == 7):
				position.x -= 2
			elif(act_counter == 6):
				position.x -= 2
			elif(act_counter == 5):
				position.x -= 4
			elif(act_counter == 4):
				position.x -= 5
				$Sprite2D.flip_h = false 
			elif(act_counter == 1):
				position.x -= 3
				position.y -= 3
				dodge_timer = 6
				
		L_JAB:
			if(act_counter == 25):
				direction_keys.erase("ui_accept")
				$Sprite2D.set_frame(7)
				position.y -= 3
				position.x += 2
			elif(act_counter == 23):
				$Sprite2D.set_frame(8)
				position.y -= 7
				position.x +=2
			elif(act_counter == 21):
				position.y -= 5
				position.x += 2
			elif(act_counter == 19):
				$Sprite2D.set_frame(9)
				position.y -= 7
				position.x += 2
				
			elif(act_counter == 18):
				position.x += 2
				emit_signal("punch",0)
			elif(act_counter == 8):
				$Sprite2D.set_frame(8)
				position.y += 4
			elif(act_counter == 5):
				position.y += 3;
				$Sprite2D.set_frame(0)
			elif(act_counter == 2):
				position.y += 3;
				position.x -= 1
				#if(is_blocked == true):
					#is_blocked = false
					#state = COOLDOWN
					#act_counter = 12
					#position.x = 114
					#position.y = 155
		R_JAB:
			if(act_counter == 25):
				direction_keys.erase("ui_cancel")
				$Sprite2D.set_frame(11)
				position.y -= 3
				position.x += 12
			elif(act_counter == 23):
				$Sprite2D.set_frame(12)
				position.y -= 7
				position.x +=6
			elif(act_counter == 21):
				position.y -= 5
				position.x += 3
			elif(act_counter == 20):
				$Sprite2D.set_frame(13)
				position.y -= 7
				position.x -= 3
				
			elif(act_counter == 18):
				position.x -= 2
				emit_signal("punch", 1)
			elif(act_counter == 8):
				$Sprite2D.set_frame(12)
				position.y += 4
			elif(act_counter == 5):
				position.y += 3
				$Sprite2D.set_frame(0)
			elif(act_counter == 2):
				position.y += 3
				position.x -= 2
				#if(is_blocked == true):
					#is_blocked = false
					#state = COOLDOWN
					#act_counter = 12
					#position.x = 114
					#position.y = 155
		L_HOOK:
			if(act_counter == 24):
				direction_keys.erase("ui_accept")
				$Sprite2D.set_frame(6)
				position.x += 1
			elif(act_counter == 21):
				
				$Sprite2D.set_frame(7)
				position.y -= 3
				position.x += 2
			elif(act_counter == 18):
				emit_signal("punch", 2)
				$Sprite2D.set_frame(8)
				position.y -= 3
				position.x += 3
			elif(act_counter == 9):
				$Sprite2D.set_frame(7)
				position.y += 3
				position.x -= 2
			elif(act_counter == 4):
				$Sprite2D.set_frame(6)
				position.y += 3
				position.x -= 2
				if(is_blocked == true):
					is_blocked = false
					state = COOLDOWN
					act_counter = 12
					position.x = 114
					position.y = 155
		R_HOOK:
			if(act_counter == 24):
				direction_keys.erase("ui_cancel")
				$Sprite2D.set_frame(10)
				position.x += 5
			elif(act_counter == 21):
				$Sprite2D.set_frame(11)
				position.x += 4
				position.y -= 3
				
			elif(act_counter == 18):
				$Sprite2D.set_frame(12)
				position.x +=5
				position.y -= 3
				emit_signal("punch", 3)
			elif(act_counter == 9):
				$Sprite2D.set_frame(11)
				position.y += 3
				position.x -= 3
			elif(act_counter == 4):
				$Sprite2D.set_frame(10)
				position.y += 3
				position.x -= 2
				if(is_blocked == true):
					is_blocked = false
					state = COOLDOWN
					act_counter = 12
					position.x = 114
					position.y = 155
		L_HIT:
			if(act_counter == 34):
				$Sprite2D.flip_h = false 
				emit_signal("score_star", 0)
				star_count = 0
				$Sprite2D.set_frame(17)
				position.x -= 4
				position.y += 4
			elif(act_counter == 31):
				$Sprite2D.set_frame(18)
				position.y += 4
				position.x -= 4
			elif(act_counter == 28):
				if(health <= 0):
					#print("knockdown")
					state = FALLING
					act_counter = 29
			elif(act_counter == 2):
				state = COOLDOWN
				act_counter = 16
				position.x = 114
				position.y = 155
		R_HIT:
			if(act_counter == 34):
				$Sprite2D.flip_h = false 
				emit_signal("score_star", 0)
				star_count = 0
				$Sprite2D.set_frame(14)
				position.x += 6
				position.y += 4
			elif(act_counter == 31):
				$Sprite2D.set_frame(15)
				position.y += 4
				position.x += 4
			elif(act_counter == 28):
				if(health <= 0):
					#print("knockdown")
					state = FALLING
					act_counter = 29
			elif(act_counter == 2):
				state = COOLDOWN
				act_counter = 16
				position.x = 114
				position.y = 155
		COOLDOWN:
			if(act_counter == 15):
				$Sprite2D.set_frame(20)
			elif(act_counter == 7):
				$Sprite2D.set_frame(19)
		PARRY:
			if(direction_keys.has("ui_accept") == true):
				act_counter = 29;
				state = L_JAB;
			elif(direction_keys.has("ui_cancel") == true):
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
				position.y += 13
				position.x = 114
				game_state = "KO"
				state = GETTING_UP
				act_counter = 0
				inam = false
				$Sprite2D.set_frame(0)
				emit_signal("ko_to_enemy",12,0)
				emit_signal("set_speed",100)
				ko_calc()
				if(ko_count >= 3):
					emit_signal("count_init",2,true)
				else:
					emit_signal("count_init",2,false)
		STAR_PUNCH:
			if(act_counter == 54):
				$Sprite2D.set_frame(25)
			elif(act_counter == 50):
				$Sprite2D.set_frame(26)
			elif(act_counter == 46):
				$Sprite2D.set_frame(25)
			elif(act_counter == 42):
				$Sprite2D.set_frame(26)
			elif(act_counter == 38):
				$Sprite2D.set_frame(25)
				position.x += 5
			elif(act_counter == 34):
				$Sprite2D.set_frame(26)
				position.y -= 7
				position.x += 7
			elif(act_counter == 33):
				position.y -= 7
				position.x += 2
			elif(act_counter == 32):
				$Sprite2D.set_frame(27)
				position.y -= 6
				position.x += 2
				emit_signal("punch", 3 + star_count)
				emit_signal("score_star", 0)
				star_count = 0
			elif(act_counter == 30):
				position.y -= 6
				position.x += 4
			elif(act_counter == 23):
				position.y += 6
				position.x -= 2
				$Sprite2D.set_frame(28)
			elif(act_counter == 14):
				position.x -= 4
				position.y += 6
				$Sprite2D.set_frame(29)
			elif(act_counter == 8):
				position.x -= 4
				position.y += 6
			
func idler():
	act_counter -= 1;
	if(act_counter <= 0):
		position.x += idle[idle_index]
		$Sprite2D.set_frame(idle[idle_index +1])
		act_counter = idle[idle_index + 2]
		idle_index = (idle_index + 3) % 72

func ko_handler():
	match state:
		WALK_UP:
			if(act_counter < 0):
				if(position.y <= 155):
					act_counter = 0
					state = IDLE
					inam = false
					game_state = "main"
				else:
					position.y -= 5
					if($Sprite2D.frame == 0):
						$Sprite2D.set_frame(1)
					else:
						$Sprite2D.set_frame(0)
					act_counter = 4
		WALK_DOWN:
			if(act_counter < 0):
				if(position.y >= 205):
					act_counter = 0
					state = EXCERCISE
					inam = false
				else:
					position.y += 5
					if($Sprite2D.frame == 0):
						$Sprite2D.set_frame(1)
					else:
						$Sprite2D.set_frame(0)
					act_counter = 4
		EXCERCISE:
			if(act_counter == 0):
				if(direction_keys.has("ui_accept") == true):
					act_counter = 1
					position.y -= 1
				elif(direction_keys.has("ui_cancel") == true):
					act_counter = 2
					position.y -= 1
			elif(act_counter == 1):
				if(direction_keys.has("ui_cancel") == true and direction_keys.has("ui_accept") == false):
					act_counter = 0
					handle_health(-0.25)
					position.y += 1
			elif(act_counter == 2):
				if(direction_keys.has("ui_accept") == true and direction_keys.has("ui_cancel") == false):
					act_counter = 0
					handle_health(-0.25)
					position.y += 1
		GETTING_UP:
			position.y = 225 + (mash / mash_co)
			if(mash == 0):
				act_counter = 80
				inam = true
				state = WALK_UP
				emit_signal("ko_to_enemy",11,100)
				emit_signal("count_init",0,false)
				handle_health(0)
				idle_index = 69
				stamina = stam_max + 1
				has_no_stam = false
				check_stam(0)
			elif(act_counter == 0):
				if(direction_keys.has("ui_accept") == true):
					act_counter = 1
				elif(direction_keys.has("ui_cancel") == true):
					act_counter = 2
			elif(act_counter == 1):
				if(direction_keys.has("ui_cancel") == true and direction_keys.has("ui_accept") == false):
					act_counter = 0
					mash -= mash_co
			elif(act_counter == 2):
				if(direction_keys.has("ui_accept") == true and direction_keys.has("ui_cancel") == false):
					act_counter = 0
					mash -= mash_co

func _on_enemy_attack(type,damage,table,duration,stam):
	if(state != R_HIT and state != L_HIT and state != BLOCKING):
		if(table[0] == pos_table[0] or table[1] == pos_table[1] or table[2] == pos_table[2] or table[3] == pos_table[3]):
			#print(str(pos_table))
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
			else:
				position.x = 114
				position.y = 155
				act_counter = 35
				inam = true
				handle_health(damage)
				check_stam(1 + stam)
				if(type %2 == 0):
					state = L_HIT
				else:
					state = R_HIT
		else:
			if(duration == 1):
				if(state == R_DODGE):
					#print(str(act_counter))
					#print(str(table[2] == 1 and act_counter < 40 + duration))
					#print(str(table[1] == 1 and act_counter < 8 + duration))
					if(!(table[2] == 1 and act_counter < 41) and !(table[1] == 1 and act_counter < 9)):
						emit_signal("stam_deplete",stam,false)
						if(stamina <= 0):
							stamina = stam_max
							check_stam(0)
							has_no_stam = false
				elif(state == L_DODGE):
					#print(str(act_counter))
					#print(str(table[0] == 1 and act_counter < 40 + duration))
					#print(str(table[1] == 1 and act_counter < 8 + duration))
					if(!(table[0] == 1 and act_counter < 40 + duration) and !(table[1] == 1 and act_counter < 8 + duration)):
						emit_signal("stam_deplete",stam,false)
						if(stamina <= 0):
							stamina = stam_max
							check_stam(0)
							has_no_stam = false
		
	

func check_stam(amount):
	stamina -= amount
	emit_signal("f_stam", stamina)
	if(stamina <= 0 and health > 0 and has_no_stam == false):
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

func handle_health(value):
	health -= value
	if(health >= 96 and value < 0):
		health += value
	emit_signal("f_health",health)

func _on_enemy_blocked(value):
	check_stam(value)
	is_blocked = true

func _on_enemy_ko_to_player(state_no, wait):
	game_state = "KO"
	act_counter = wait
	inam = true
	position.x = 114
	if(state_no == 0):
		state = WALK_DOWN
	elif(state_no == 1):
		state = WALK_UP

func ko_calc():
	ko_count += 1
	if(ko_count == 1):
		health = 80
		mash = 48
		mash_co = 4
	elif(ko_count == 2):
		health = 60
		mash = 60
		mash_co = 3
	else:
		mash = 1000


func _on_star_star_to_player():
	if(star_count < 3):
		star_count += 1
		emit_signal("score_star",star_count)
