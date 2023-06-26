extends KinematicBody2D

var f_Table = [[125,108] , [6,-1,2,0,16,-2,-3,4,7,0,1,4,2,1,1,5,16,2,-2,4,7,0,1,4,2] , [0] , [3,0,0,15,8,2,-2,15,8,2,-2,15,8] , [3,3,-2,16,8,2,-2,16,8,4,-4,16,100]]
var state = 2;
var timer = 1;
var t_counter = 1;
var repeater;
var hits_aval = 1;
var l_punched = false;

func _ready():
	pass
func _physics_process(delta):
	enemy_handler();

func enemy_handler():
	timer -= 1;
	if(state == 0):
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
	#elif(state == 1):
		#if(l_punched):
			
		#if(timer <= 0):
			
	elif(state == 2):
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
	elif(state == 3):
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
	elif(state == 4):
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
