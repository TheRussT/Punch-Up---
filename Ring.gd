extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





func _on_player_f_health(amount):
	var f_healthbar = $f_healthbar
	f_healthbar.value = amount


func _on_enemy_health(amount):
	var e_healthbar = $e_healthbar
	e_healthbar.value = amount


func _on_player_f_stam(amount):
	var f_staminabar = $f_staminabar
	f_staminabar.value = amount


func _on_enemy_stam_deplete(amount):
	var e_staminabar = $e_staminabar
	e_staminabar.value = amount
