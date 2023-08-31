extends Sprite2D

var timer = 0
var is_active = false
var index = 0
signal star_to_player()
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(is_active == true):
		timer -= 1
		if(timer <= 0):
			if(index == 0):
				position.y -= 2
				timer = 6
				index += 1
			elif(index == 1):
				position.y -= 1
				timer = 6
				index += 1
			elif(index == 2):
				index = 0
				is_active = false
				visible = false
				emit_signal("star_to_player")


func _on_enemy_star(xpos, ypos):
	position.x = xpos
	position.y = ypos
	is_active = true 
	visible = true
	timer = 16
	#print("should star")
