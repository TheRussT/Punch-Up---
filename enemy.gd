extends KinematicBody2D
#usually fighter Table state components consist of how many repititions there will be followed by a pattern of x movements, y movements, animation frame, timer
var f_Table = [[125,108,[2,2,8,8]] , [6,-1,2,0,16,-2,-3,4,7,0,1,4,2,1,1,5,16,2,-2,4,7,0,1,4,2] , [50,17] , [3,0,0,15,2,2,-2,15,3,2,-2,15,3] , [3,3,-2,16,3,2,-2,16,3,4,-4,16,10], #Stats, Idle, Daze, Hit, Sent
[3,0,0,12,3,1,-1,12,2,1,-1,12,1] , [3,1,-1,12,2,1,-1,12,2,1,-1,12,12] , [3,0,0,9,6,4,-2,9,4,0,0,8,20] , [3,0,0,7,6,4,-2,7,4,0,0,6,20] , [5,0], #Stomach hit, Stomach sent, High block, Low block, Stamina
[3,8,-6,10,5,8,-4,10,5,14,-4,10,15], 
[9,6,-2,1,6,[2,8,8,3],false,4,-4,1,6,[3,6,8,8],false,2,-6,1,18,[8,8,8,8],false,0,3,1,2,[8,6,8,8],false,-2,2,22,2,[8,8,8,8],false,-6,6,18,4,[8,8,8,8],false,-6,6,18,4,[8,8,8,8],false,-8,10,18,4,[8,8,8,8],true,0,0,18,48,[1,1,1,1],false,0,0,18,1,[0,0,0,0],false],
[7,-6,-2,2,6,[8,8,8,8],false,-6,-2,19,6,[8,8,8,8],false,-12,2,19,20,[8,8,3,8],false,3,6,23,3,[8,8,8,8],false,8,6,20,5,[8,8,8,8],false,10,3,20,4,[8,8,8,8],true,10,-5,21,40,[1,1,1,1],false,0,0,21,1,[0,0,0,0],false]]
var f_schedule = [[0,11],[1,2000],[0,14],[1,100],[0,13],[1,100],[0,14],[1,160],[0,13],[2,60,100],[4,2,12],[0,13],[1,70],[3,2]]
var sch_timer = 1
var sch_index = 1
var state = 12;
var timer = 100;
var t_counter = 1;
var repeater = 0;
var hits_aval = 7;
var gaurd = [2,2,8,8] #left up, right up, left down, right down

signal attack(type)

func _ready():
	pass
func _physics_process(_delta):
	enemy_handler();
	schedule_handler()
	
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
		$Sprite.scale.x = 1; #Can remove after right facing sprites
		#hit detection
		if(timer <= 0):
			state = 0
	elif(state == 2): #hit left uppercut
		if(timer <= 0):
			position.x += f_Table[3][t_counter];
			position.y += f_Table[3][t_counter + 1];
			$Sprite.set_frame(f_Table[3][t_counter + 2]);
			timer = f_Table[3][t_counter + 3];
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
	elif(state == 4): #hit right uppercut (add left facing sprite)
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
	elif(state == 5): #sent left uppercut (add left facing sprite)
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
	elif(state == 7): #sent stomach
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
	elif(state == 12): #dodge
		if(timer <= 0):
			position.x += f_Table[10][t_counter];
			position.y += f_Table[10][t_counter + 1];
			$Sprite.set_frame(f_Table[10][t_counter + 2]);
			timer = f_Table[10][t_counter + 3];
			t_counter += 4;
			if(t_counter >= f_Table[10][0] * 4 + 1):
				t_counter = 1;
				state = 0;
				position.x = f_Table[0][0];
				position.y = f_Table[0][1];
	elif(state == 13): #jab
		if(f_Table[11][t_counter + 5]):
			emit_signal("attack",0) 
		if(timer <= 0):
			if(t_counter == (6 * f_Table[11][0] + 1)):
				state = 0;
				t_counter = 1;
				timer = 1
				position.x = f_Table[0][0];
				position.y = f_Table[0][1];
				gaurd = f_Table[0][2]
			else:
				position.x += f_Table[11][t_counter];
				position.y += f_Table[11][t_counter + 1];
				$Sprite.set_frame(f_Table[11][t_counter + 2]);
				timer = f_Table[11][t_counter + 3];
				gaurd = f_Table[11][t_counter + 4]
				t_counter = t_counter + 6
	elif(state == 14):
		if(f_Table[12][t_counter + 5]):
			emit_signal("attack",0) 
		if(timer <= 0):
			if(t_counter == (6 * f_Table[12][0]+1)):
				state = 0;
				t_counter = 1;
				timer = 1
				position.x = f_Table[0][0];
				position.y = f_Table[0][1];
				gaurd = f_Table[0][2]
			else:
				position.x += f_Table[12][t_counter];
				position.y += f_Table[12][t_counter + 1];
				$Sprite.set_frame(f_Table[12][t_counter + 2]);
				timer = f_Table[12][t_counter + 3];
				gaurd = f_Table[12][t_counter + 4]
				t_counter = (t_counter + 6) 
			

func schedule_handler():
	if(state == 0 or state > 12):
		sch_timer -= 1;
	if(sch_timer <= 0):
		sch_index += 1
		if(f_schedule[sch_index][0] == 0):
			t_counter = 1
			timer = 1
			state = f_schedule[sch_index][1]
			hits_aval = 4
		elif(f_schedule[sch_index][0] == 1):
			sch_timer = f_schedule[sch_index][1]
		elif(f_schedule[sch_index][0] == 2):
			if(randi() > 0):
				sch_timer = f_schedule[sch_index][1]
			else:
				sch_timer = f_schedule[sch_index][2] 
		elif(f_schedule[sch_index][0] == 3):
			sch_index = f_schedule[sch_index][1]
		elif(f_schedule[sch_index][0] == 4):
			if(randi() > 0):
				sch_index = f_schedule[sch_index][1]
			else:
				sch_index = f_schedule[sch_index][2]
	
func _on_player_punch(value):
	if(state == 0 or state == 1 or state >= 13):
		t_counter = 1
		timer = 1
		#position.x = f_Table[0][0];
		#position.y = f_Table[0][1];
		if(value == 0):
			if(gaurd[0] > 6):
				state = 8
			elif(gaurd[0] > 4):
				state = 12;
			elif(gaurd[0] > 0):
				if(gaurd[0] > 1):
					hits_aval = 1
				state = 2;
		elif(value == 1):
			if(gaurd[1] > 6):
				state = 8
			elif(gaurd[1] > 4):
				state = 12;
			elif(gaurd[1] > 0):
				if(gaurd[0] > 1):
					hits_aval = 1
				state = 4;
		elif(value == 2):
			if(gaurd[2] > 6):
				state = 9
			elif(gaurd[2] > 4):
				state = 12;
			elif(gaurd[2] > 0):
				if(gaurd[0] > 1):
					hits_aval = 1
				state = 6;
		elif(value == 3):
			if(gaurd[3] > 6):
				state = 9
			elif(gaurd[3] > 4):
				state = 12;
			elif(gaurd[3] > 0):
				if(gaurd[0] > 1):
					hits_aval = 1
				state = 6;
	
