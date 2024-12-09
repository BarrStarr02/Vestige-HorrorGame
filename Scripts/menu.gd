extends VBoxContainer


const LEVEL = preload("res://scenes/level.tscn")


func _on_button_new_game_pressed():
	get_tree().change_scene_to_packed(LEVEL)

func _on_button_quit_pressed():
	get_tree().quit()
