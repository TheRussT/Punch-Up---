extends KinematicBody2D
#usually fighter Table state components consist of how many repititions there will be followed by a pattern of x movements, y movements, animation frame, timer
var f_Table = [[125,108] , [6,-1,2,0,16,-2,-3,4,7,0,1,4,2,1,1,5,16,2,-2,4,7,0,1,4,2] , [50,17] , [3,0,0,15,5,2,-2,15,5,2,-2,15,5] , [3,3,-2,16,5,2,-2,16,5,4,-4,16,60], #Stats, Idle, Daze, Hit, Sent
[3,0,0,12,8,1,-1,12,5,1,-1,12,4] , [3,1,-1,12,4,1,-1,12,8,1,-1,12,60] , [3,0,0,9,12,4,-2,9,8,0,0,8,60] , [3,0,0,7,12,4,-2,7,8,0,0,6,60] , [5,0]]
var state = 1;
var timer = 100;
var t_counter = 1;
var repeater = 0;
var hits_aval = 4;
var l_punched = false;

func _ready():
	pass
func _physics_process(_delta):
	enemy_handler();
	if Input.is_action_just_released("ui_right"):
		state = 2;
		t_counter = 1
	if Input.is_action_just_released("ui_down"):
		state = 4;
		t_counter = 1
	if Input.is_action_just_released("ui_accept"):
		state = 6;
		t_counter = 1;
	if Input.is_action_just_pressed("ui_left"):
		state = 8;
		t_counter = 1;
	

func enemy_handler():
	timer -= 1;
	if(state == 0): #Idling
		#hit detection
		if(timer <= 0):
			position.x += f_Table[1][t_counter];
			#print_debug("moving x " + str(f_Table[0][t_counter]));
			position.y += f_Table[1][t_counter + 1];
			#print_debug("moving y " + str(f_Table[0][t_counter + 1]));
			$Sprite.set_frame(f_Table[1][t_counter + 2]);
			#print_debug("going to frame #" + str(f_Table[0][t_counter + 2]));
			timer = f_Table[1][t_counter + 3];
			#print_debug("setting timer to " + str(f_Table[0][t_counter + 3]));
			t_counter = (t_counter + 4) % (f_Table[1][0] * 4)
			#print_debug("counter is " + str(t_counter));
	elif(state == 1): #daze
		$Sprite.set_frame(f_Table[2][1]);
		if Input.is_action_just_pressed("ui_up"):
			state = 2;
			t_counter = 1;
			timer = 1;
		#hit detection
		if(timer <= 0):
			state = 0
	elif(state == 2): #hit left uppercut
		if(timer <= 0):
			position.x += f_Table[3][t_counter];
			#print_debug("moving x " + str(f_Table[3][t_counter]));
			position.y += f_Table[3][t_counter + 1];
			#print_debug("moving y " + str(f_Table[3][t_counter + 1]));
			$Sprite.set_frame(f_Table[3][t_counter + 2]);
			#print_debug("going to frame #" + str(f_Table[3][t_counter + 2]));
			timer = f_Table[3][t_counter + 3];
			#print_debug("setting timer to " + str(f_Table[3][t_counter + 3]));
			t_counter += 4;
			if(t_counter >= f_Table[3][0] * 4 + 1):
				if(hits_aval <=1):
					state = 3;
					t_counter = 1;
				else:
					state = 1;
					position.x = f_Table[0][0];
					position.y = f_Table[0][1];
					t_counter = 1;
					hits_aval -= 1;
					timer = f_Table[2][0]
	elif(state == 3): #sent right uppercut
		if(timer <= 0):
			if(t_counter >= f_Table[4][0] * 4 + 1):
				position.x = f_Table[0][0];
				position.y = f_Table[0][1];
				t_counter = 1;
				state = 0
			else:
				position.x += f_Table[4][t_counter];
				position.y += f_Table[4][t_counter + 1];
				$Sprite.set_frame(f_Table[4][t_counter + 2]);
				timer = f_Table[4][t_counter + 3];
				t_counter += 4;
	elif(state == 4): #hit right uppercut
		$Sprite.scale.x = -1;
		if(timer <= 0):
			position.x -= f_Table[3][t_counter];
			position.y += f_Table[3][t_counter + 1];
			$Sprite.set_frame(f_Table[3][t_counter + 2]);
			timer = f_Table[3][t_counter + 3];
			t_counter += 4;
			if(t_counter >= f_Table[3][0] * 4 + 1):
				if(hits_aval <=1):
					state = 5;
					t_counter = 1;
				else:
					state = 1;
					position.x = f_Table[0][0];
					position.y = f_Table[0][1];
					t_counter = 1;
					hits_aval -= 1;
					timer = f_Table[2][0]
	elif(state == 5): #sent left uppercut
		if(timer <= 0):
			if(t_counter >= f_Table[4][0] * 4 + 1):
				$Sprite.scale.x = 1;
				t_counter = 1;
				state = 0;
				position.x = f_Table[0][0];
				position.y = f_Table[0][1];
			else:
				position.x -= f_Table[4][t_counter];
				position.y += f_Table[4][t_counter + 1];
				$Sprite.set_frame(f_Table[4][t_counter + 2]);
				timer = f_Table[4][t_counter + 3];
				t_counter += 4;
	elif(state == 6): #hit stomach
		if(timer <= 0):
			position.x += f_Table[5][t_counter];
			position.y += f_Table[5][t_counter + 1];
			$Sprite.set_frame(f_Table[5][t_counter + 2]);
			timer = f_Table[5][t_counter + 3];
			t_counter += 4;
			if(t_counter >= f_Table[5][0] * 4 + 1):
				if(hits_aval <=1):
					state = 7;
					t_counter = 1;
				else:
					state = 1;
					position.x = f_Table[0][0];
					position.y = f_Table[0][1];
					t_counter = 1;
					hits_aval -= 1;
					timer = f_Table[2][0]
	elif(state == 7): #sent left uppercut
		if(timer <= 0):
			if(t_counter >= f_Table[6][0] * 4 + 1):
				t_counter = 1;
				state = 0;
				position.x = f_Table[0][0];
				position.y = f_Table[0][1];
			else:
				position.x += f_Table[6][t_counter];
				position.y += f_Table[6][t_counter + 1];
				$Sprite.set_frame(f_Table[6][t_counter + 2]);
				timer = f_Table[6][t_counter + 3];
				t_counter += 4;
	elif(state == 8): #uppercut block
		if(timer <= 0):
			position.x += f_Table[7][t_counter];
			position.y += f_Table[7][t_counter + 1];
			$Sprite.set_frame(f_Table[7][t_counter + 2]);
			timer = f_Table[7][t_counter + 3];
			t_counter += 4;
			if(t_counter >= f_Table[7][0] * 4 + 1):
				t_counter = 1;
				state = 0;
				position.x = f_Table[0][0];
				position.y = f_Table[0][1];
	elif(state == 9): #stomach block
		if(timer <= 0):
			position.x += f_Table[8][t_counter];
			position.y += f_Table[8][t_counter + 1];
			$Sprite.set_frame(f_Table[8][t_counter + 2]);
			timer = f_Table[8][t_counter + 3];
			t_counter += 4;
			if(t_counter >= f_Table[8][0] * 4 + 1):
				t_counter = 1;
				state = 0;
				position.x = f_Table[0][0];
				position.y = f_Table[0][1];
	elif(state == 10): #stamina daze
		#hit detection
		if(timer <= 0):
			if(repeater < f_Table[9][0]):
				position.x += f_Table[8][t_counter];
				position.y += f_Table[8][t_counter + 1];
				$Sprite.set_frame(f_Table[8][t_counter + 2]);
				timer = f_Table[8][t_counter + 3];
				t_counter += 4;
				repeater +=1;
			else:
				t_counter = 1;
				state = 0;
				position.x = f_Table[0][0];
				position.y = f_Table[0][1];
	#elif() #falling
