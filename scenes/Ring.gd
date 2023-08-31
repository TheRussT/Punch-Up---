extends Node2D

@onready var ones = $Timer_Ones
@onready var tens = $Timer_Tens
@onready var hundreds = $Timer_Hundreds
@onready var s_score = $star_score
@onready var f_healthbar = $f_healthbar
@onready var e_healthbar = $e_healthbar
@onready var f_staminabar = $f_staminabar
@onready var e_staminabar = $e_staminabar
var es_value 
var fs_value = 20
var eh_value = 96
var fh_value = 96
var countdown = 10
var speed = 20
var timer = 180


# Called when the node enters the scene tree for the first time.
func _ready():
	s_score.visible = false
	if(GlobalScript.fight_index == 0):
		e_staminabar.max_value = 30
		es_value = 30
	elif(GlobalScript.fight_index == 1):
		e_staminabar.max_value = 50
		es_value = 50
	elif(GlobalScript.fight_index == 2):
		e_staminabar.max_value = 12
		es_value = 12
	e_staminabar.value = e_staminabar.max_value
	$round_number.set_frame(GlobalScript.round - 1)


func _physics_process(delta):
	#print(str(e_staminabar.value))
	if(speed < 100):
		countdown -= 1
	if(countdown <= 0):
		timer -= 1
		$Timer_Ones.set_frame(timer % 10)
		$Timer_Tens.set_frame((timer / 10) % 6)
		$Timer_Hundreds.set_frame((timer / 60))
		if(timer == 0):
			speed = 100
			emit_signal("round_timeout","Ring")
			#print("this")
			get_tree().change_scene_to_file("res://scenes/between_fights.tscn")
		countdown = speed
	if(es_value < e_staminabar.value):
		e_staminabar.value -= 1
	elif(es_value > e_staminabar.value + 1):
		e_staminabar.value += 1
	if(fs_value < f_staminabar.value):
		f_staminabar.value -= 1
	elif(fs_value > f_staminabar.value + 1):
		f_staminabar.value += 1
	if(eh_value < e_healthbar.value):
		e_healthbar.value -= 1
	elif(eh_value > e_healthbar.value + 1):
		e_healthbar.value += 1
	if(fh_value < f_healthbar.value):
		f_healthbar.value -= 1
	elif(fh_value > f_healthbar.value + 1):
		f_healthbar.value += 1

func _on_player_f_health(amount):
	fh_value = amount


func _on_enemy_health_deplete(amount):
	eh_value = amount


func _on_player_f_stam(amount):	
	fs_value = amount


func _on_enemy_stam_deplete(amount):
	es_value = amount


func _on_enemy_set_speed(amount):
	speed = amount


func _on_player_set_speed(amount):
	speed = amount
	if(countdown > speed):
		countdown = speed


func _on_player_score_star(amount):
	if(amount == 0):
		s_score.visible = false
	else:
		s_score.set_frame(amount - 1)
		s_score.visible = true
