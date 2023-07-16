extends Node2D

@onready var ones = $Timer_Ones
@onready var tens = $Timer_Tens
@onready var hundreds = $Timer_Hundreds
var countdown = 10
var speed = 20
var timer = 180

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _physics_process(delta):
	if(speed < 100):
		countdown -= 1
	if(countdown <= 0):
		timer -= 1
		$Timer_Ones.set_frame(timer % 10)
		$Timer_Tens.set_frame((timer / 10) % 6)
		$Timer_Hundreds.set_frame((timer / 60))
		countdown = speed

func _on_player_f_health(amount):
	var f_healthbar = $f_healthbar
	f_healthbar.value = amount


func _on_enemy_health_deplete(amount):
	var e_healthbar = $e_healthbar
	e_healthbar.value = amount


func _on_player_f_stam(amount):
	var f_staminabar = $f_staminabar
	f_staminabar.value = amount


func _on_enemy_stam_deplete(amount):
	var e_staminabar = $e_staminabar
	e_staminabar.value = amount


func _on_enemy_set_speed(amount):
	speed = amount


func _on_player_set_speed(amount):
	speed = amount
