extends Node2D
var is_active = false
var state = 1
var timer = 1
var anim_counter = 0
var count_sch = []
var count = 1
var knocked_down = ""

signal getup(strength)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(is_active == true):
		state_handler()

func state_handler():
	timer -=1
	if(state == 0):
		if(timer <= 0):
			if(anim_counter == 0): #fight!
				$Sprite2D.set_frame(2)
				timer = 20
				anim_counter += 1
				#print("should start attack")
			elif(anim_counter == 1):
				$Sprite2D.set_frame(3)
				timer = 20
				anim_counter += 1
			elif(anim_counter == 2):
				$Sprite2D.set_frame(2)
				timer = 16
				anim_counter += 1
			elif(anim_counter == 3):
				$Sprite2D.set_frame(3)
				timer = 16
				anim_counter += 1
			elif(anim_counter == 4):
				$Sprite2D.set_frame(18)
				state = 1
				timer = 150
				anim_counter = 0
	elif(state == 1): #walk back
		if(timer <= 0):
			if(position.x >= 255):
				is_active = false
				anim_counter = 0
				$Sprite2D.set_frame(0)
			else:
				position.x += 5
				timer = 8
				if($Sprite2D.frame == 1 and anim_counter == 1):
					$Sprite2D.set_frame(0)
					anim_counter = -1
				elif(anim_counter == 1):
					$Sprite2D.set_frame(1)
					anim_counter = -1
				anim_counter += 1
	elif(state == 2): #walk out
		if(timer <= 0):
			if(position.x <= 165):
				state = 3
				anim_counter = 0
			else:
				position.x -= 5
				timer = 8
				if($Sprite2D.frame == 1 and anim_counter == 1):
					$Sprite2D.set_frame(0)
					anim_counter = -1
				elif(anim_counter == 1):
					$Sprite2D.set_frame(1)
					anim_counter = -1
				anim_counter += 1
	elif(state == 3): #count
		#print("here")
		if(timer <= 0):
			if(count == 10):
				if(knocked_down == "enemy"):
					pass
					print("win")
					#win
				else:
					pass
					print("lose")
					#lose
			elif(anim_counter == 0):
				$Sprite2D.set_frame(2)
				timer = 20
				anim_counter += 1
				#print("should start attack")
			elif(anim_counter == 1):
				$Sprite2D.set_frame(3)
				timer = 4
				anim_counter += 1
			elif(anim_counter == 2):
				$Sprite2D.set_frame(4)
				timer = 2
				anim_counter += 1
			elif(anim_counter == 3):
				$Sprite2D.set_frame(4 + count)
				if(count >= 10):
					state = 4
				elif(count_sch[count - 1] == 3):
					emit_signal("getup",3)
					timer = 400
					state = 0
					count = 0
				elif(count_sch[count - 1] == 2):
					emit_signal("getup",2)
					timer = 300
				elif(count_sch[count - 1] == 1):
					emit_signal("getup",1)
					print("timer should set")
					timer = 250
				else:
					timer = 75
				count += 1
				anim_counter = 0


func _on_enemy_count(schedule):
	count_sch = schedule


func _on_enemy_count_init(state,wait):
	timer = wait
	self.state = state
	is_active = true
	anim_counter = 0
	count = 1
	knocked_down = "enemy"


func _on_player_count_init(state):
	self.state = state
	is_active = true
	anim_counter = 0
	count = 1
	count_sch = [0,0,0,0,0,0,0,0,0,0]
	knocked_down = "player"
