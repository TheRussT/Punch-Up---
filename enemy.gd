extends KinematicBody2D
#usually fighter Table state components consist of how many repititions there will be followed by a pattern of x movements, y movements, animation frame, timer
var f_Table = {"stats":[125,118,[3,3,8,8],200], "idle":[6,-1,2,0,16,-2,-3,4,7,0,1,4,2,1,1,5,16,2,-2,4,7,0,1,4,2], "daze":[50,17], "jaw_hit":[3,0,0,15,2,2,-2,15,3,2,-2,15,3], "jaw_sent":[3,3,-2,16,3,2,-2,16,3,4,-4,16,10], #Stats, Idle, Daze, Hit, Sent
"belly_hit":[3,0,0,12,3,1,-1,12,2,1,-1,12,1], "belly_sent":[3,1,-1,12,2,1,-1,12,2,1,-1,12,12], "up_block":[3,0,0,9,6,4,-2,9,4,0,0,8,20], "low_block":[3,0,0,7,6,4,-2,7,4,0,0,6,18] , "stam_loss":[5,0], #Stomach hit, Stomach sent, High block, Low block, Stamina
"dodge":[3,6,-4,10,5,6,-4,10,7,10,-6,10,15], #dodge
"jab":[7,2,-1,1,6,[2,8,8,3],false,2,-2,1,6,[3,6,8,8],false,1,-2,1,18,[8,8,8,8],false,-2,2,22,6,[8,8,8,8],false,-12,12,18,4,[8,8,8,8],true,0,0,18,16,[1,1,1,1],false,3,-3,18,48,[1,1,1,1],false],
"hook":[7,-6,-2,2,6,[8,8,8,8],false,-6,-2,19,6,[0,0,0,0],false,-12,2,19,20,[0,0,3,0],false,3,6,23,3,[0,0,0,0],false,8,6,20,5,[8,8,8,8],false,20,-3,20,4,[8,8,8,8],true,3,-1,21,42,[1,1,1,1],false],
"taunt":[16,0,-2,0,8,[0,0,0,0],true,0,-2,4,8,[],false,0,-2,5,8,[],false,0,-2,0,8,[],false,0,-2,4,8,[],false,0,-2,5,8,[],false,0,-2,0,40,[],false,-4,-3,24,24,[],false,4,3,0,8,[],false,
-4,2,26,8,[],false,0,2,25,8,[],false,4,2,27,8,[],false,0,2,25,8,[],false,-4,2,26,8,[],false,0,2,25,8,[],false,2,2,27,8,[0,0,7,7],true,0,2,0,160,[],false]}
var f_schedule = [[0,11],[1,7],[0,14],[1,100],[0,13],[1,100],[0,14],[1,160],[0,13],[2,60,100],[4,2,11],[0,13],[1,70],[3,2],[0,14],[1,15],[0,14],[1,15],[3,14],[0,16],[1,5],[0,14],[3,2]]
#                   0      1  |    2     3      4       5       6      7       8        9        10      11     12    13  |  14     15     16     17     18  |   19    20    21    22
var sch_timer = 1
var sch_index = 0
var state = 16
var timer = 1;
var t_counter = 1;
var repeater = 0;
var hits_aval = 7;
var gaurd = f_Table["stats"][2] #left up, right up, left down, right down
var health = f_Table["stats"][3]
var idle_hit_counter = 0;
onready var sprite = $Sprite

signal attack(type,damage)
signal health(amount)

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
			position.x += f_Table["idle"][t_counter];
			position.y += f_Table["idle"][t_counter + 1];
			sprite.set_frame(f_Table["idle"][t_counter + 2]);
			timer = f_Table["idle"][t_counter + 3];
			t_counter = (t_counter + 4) % (f_Table["idle"][0] * 4)
	elif(state == 1): #daze
		sprite.set_frame(f_Table["daze"][1]);
		sprite.scale.x = 1; #Can remove after right facing sprites
		#hit detection
		if(timer <= 0):
			state = 0
			gaurd = f_Table["stats"][2]
	elif(state == 2): #hit left uppercut
		if(timer <= 0):
			update_four("jaw_hit")
			if(t_counter >= f_Table["jaw_hit"][0] * 4 + 1):
				health -= 10
				check_health()
				emit_signal("health", health)
				if(hits_aval <=1):
					state = 3;
					t_counter = 1;
				else:
					state = 1;
					position.x = f_Table["stats"][0];
					position.y = f_Table["stats"][1];
					t_counter = 1;
					hits_aval -= 1;
					timer = f_Table["daze"][0]
	elif(state == 3): #sent right uppercut
		if(timer <= 0):
			if(t_counter >= f_Table["jaw_sent"][0] * 4 + 1):
				position.x = f_Table["stats"][0];
				position.y = f_Table["stats"][1];
				t_counter = 1;
				state = 0
				gaurd = [8,8,3,3]
			else:
				update_four("jaw_sent")
	elif(state == 4): #hit right uppercut (add left facing sprite)
		sprite.scale.x = -1;
		if(timer <= 0):
			position.x -= f_Table["jaw_hit"][t_counter];
			position.y += f_Table["jaw_hit"][t_counter + 1];
			sprite.set_frame(f_Table["jaw_hit"][t_counter + 2]);
			timer = f_Table["jaw_hit"][t_counter + 3];
			t_counter += 4;
			if(t_counter >= f_Table["jaw_hit"][0] * 4 + 1):
				health -= 10
				check_health()
				emit_signal("health", health)
				if(hits_aval <=1):
					state = 5;
					t_counter = 1;
				else:
					state = 1;
					position.x = f_Table["stats"][0];
					position.y = f_Table["stats"][1];
					t_counter = 1;
					hits_aval -= 1;
					timer = f_Table["daze"][0]
	elif(state == 5): #sent left uppercut (add left facing sprite)
		if(timer <= 0):
			if(t_counter >= f_Table["jaw_sent"][0] * 4 + 1):
				sprite.scale.x = 1;
				t_counter = 1;
				state = 0;
				position.x = f_Table["stats"][0];
				position.y = f_Table["stats"][1];
				gaurd = [8,8,3,3]
			else:
				position.x -= f_Table["jaw_hit"][t_counter];
				position.y += f_Table["jaw_sent"][t_counter + 1];
				sprite.set_frame(f_Table["jaw_sent"][t_counter + 2]);
				timer = f_Table["jaw_sent"][t_counter + 3];
				t_counter += 4;
	elif(state == 6): #hit stomach
		if(timer <= 0):
			update_four("belly_hit")
			if(t_counter >= f_Table["belly_hit"][0] * 4 + 1):
				health -= 10
				check_health()
				emit_signal("health", health)
				if(hits_aval <=1):
					state = 7;
					t_counter = 1;
				else:
					state = 1;
					position.x = f_Table["stats"][0];
					position.y = f_Table["stats"][1];
					t_counter = 1;
					hits_aval -= 1;
					timer = f_Table["daze"][0]
	elif(state == 7): #sent stomach
		if(timer <= 0):
			if(t_counter >= f_Table["belly_sent"][0] * 4 + 1):
				t_counter = 1;
				state = 0;
				position.x = f_Table["stats"][0];
				position.y = f_Table["stats"][1];
				gaurd = f_Table["stats"][2]
			else:
				update_four("belly_sent")
	elif(state == 8): #uppercut block
		if(timer <= 0):
			update_four("up_block")
			if(t_counter >= f_Table["up_block"][0] * 4 + 1):
				t_counter = 1;
				state = 0;
				position.x = f_Table["stats"][0];
				position.y = f_Table["stats"][1];
				if(idle_hit_counter <= 8):
					gaurd = [8,8,3,3]
				else:
					gaurd = f_Table["stats"][2]
	elif(state == 9): #stomach block
		if(timer <= 0):
			update_four("low_block")
			if(t_counter >= f_Table["low_block"][0] * 4 + 1):
				t_counter = 1;
				state = 0;
				position.x = f_Table["stats"][0];
				position.y = f_Table["stats"][1];
				gaurd = f_Table["stats"][2]
	elif(state == 10): #stamina daze
		#hit detection
		if(timer <= 0):
			if(repeater < f_Table["stam_loss"][0]):
				position.x += f_Table["stam_loss"][t_counter];
				position.y += f_Table["stam_loss"][t_counter + 1];
				sprite.set_frame(f_Table["stam_loss"][t_counter + 2]);
				timer = f_Table["stam_loss"][t_counter + 3];
				t_counter += 4;
				repeater +=1;
			else:
				t_counter = 1;
				state = 0;
				position.x = f_Table["stats"][0];
				position.y = f_Table["stats"][1];
	#elif() #falling
	elif(state == 12): #dodge
		if(timer <= 0):
			update_four("dodge")
			if(t_counter >= f_Table["dodge"][0] * 4 + 1):
				t_counter = 1;
				state = 0;
				position.x = f_Table["stats"][0];
				position.y = f_Table["stats"][1];
	elif(state == 13): #jab/punch1
		if(timer <= 0):
			if(t_counter == (6 * f_Table["jab"][0] + 1)):
				state = 0;
				t_counter = 1;
				timer = 1
				position.x = f_Table["stats"][0];
				position.y = f_Table["stats"][1];
				gaurd = f_Table["stats"][2]
			else:
				position.x += f_Table["jab"][t_counter];
				position.y += f_Table["jab"][t_counter + 1];
				sprite.set_frame(f_Table["jab"][t_counter + 2]);
				timer = f_Table["jab"][t_counter + 3];
				gaurd = f_Table["jab"][t_counter + 4]
				t_counter = t_counter + 6
		elif(f_Table["jab"][t_counter - 1] == true):
			emit_signal("attack",0,30) 
	elif(state == 14): #hook/punch2
		if(timer <= 0):
			if(t_counter == (6 * f_Table["hook"][0]+1)):
				state = 0;
				t_counter = 1;
				timer = 1
				position.x = f_Table["stats"][0];
				position.y = f_Table["stats"][1];
				gaurd = f_Table["stats"][2]
			else:
				position.x += f_Table["hook"][t_counter];
				position.y += f_Table["hook"][t_counter + 1];
				sprite.set_frame(f_Table["hook"][t_counter + 2]);
				timer = f_Table["hook"][t_counter + 3];
				gaurd = f_Table["hook"][t_counter + 4]
				t_counter = (t_counter + 6) 
		elif(f_Table["hook"][t_counter - 1] == true):
			emit_signal("attack",1,40)
	elif(state == 15): #walk
		pass
	elif(state == 16): #taunt
		if(timer <= 0):
			if(t_counter == (6 * f_Table["taunt"][0]+1)):
				state = 0;
				t_counter = 1;
				timer = 1
				position.x = f_Table["stats"][0];
				position.y = f_Table["stats"][1];
				gaurd = f_Table["stats"][2]
			else:
				position.x += f_Table["taunt"][t_counter];
				position.y += f_Table["taunt"][t_counter + 1];
				sprite.set_frame(f_Table["taunt"][t_counter + 2]);
				timer = f_Table["taunt"][t_counter + 3];
				if(f_Table["taunt"][t_counter + 5] == true):
					gaurd = f_Table["taunt"][t_counter + 4]
				t_counter = (t_counter + 6) 
		elif(f_Table["taunt"][t_counter-5]  == 2 and timer == 2):
			position.y += 1
		elif(f_Table["taunt"][t_counter-5]  == -2 and timer == 2):
			position.y -= 2

func check_health():
	if(health <= 0):
		health = 200
		print("enemy knockdown")

func schedule_handler():
	if(state == 0 ): #or state > 12 if need be
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
	
func update_four(fstate):
	position.x += f_Table[fstate][t_counter];
	position.y += f_Table[fstate][t_counter + 1];
	sprite.set_frame(f_Table[fstate][t_counter + 2]);
	timer = f_Table[fstate][t_counter + 3];
	t_counter += 4;
	
func _on_player_punch(value):
	if(state == 0 or state == 1 or state >= 13):
		if(state == 0):
			idle_hit_counter += 1
			if(idle_hit_counter == 8):
				sch_index = 18
				idle_hit_counter +=1
				f_Table["stats"][2] = [8,8,8,8]
		var temp_c = t_counter
		var temp_t = timer
		t_counter = 1
		timer = 1
		#position.x = f_Table["stats"][0];
		#position.y = f_Table["stats"][1];
		if(value == 0):
			if(gaurd[0] > 6):
				state = 8
			elif(gaurd[0] > 4):
				state = 12;
			elif(gaurd[0] > 0):
				if(gaurd[0] > 1):
					hits_aval = 1
				state = 2;
			else:
				t_counter = temp_c
				timer = temp_t
				health += 10
		elif(value == 1):
			if(gaurd[1] > 6):
				state = 8
			elif(gaurd[1] > 4):
				state = 12;
			elif(gaurd[1] > 0):
				if(gaurd[0] > 1):
					hits_aval = 1
				state = 4;
			else:
				t_counter = temp_c
				timer = temp_t
				health += 10
		elif(value == 2):
			if(gaurd[2] > 6):
				state = 9
			elif(gaurd[2] > 4):
				state = 12;
			elif(gaurd[2] > 0):
				if(gaurd[0] > 1):
					hits_aval = 1
				state = 6;
			else:
				t_counter = temp_c
				timer = temp_t
				health += 10
		elif(value == 3):
			if(gaurd[3] > 6):
				state = 9
			elif(gaurd[3] > 4):
				state = 12;
			elif(gaurd[3] > 0):
				if(gaurd[0] > 1):
					hits_aval = 1
				state = 6;
			else:
				t_counter = temp_c
				timer = temp_t
				health += 10
	
