extends Control

func _on_quit_button_pressed():
	get_tree().quit()

func _on_continue_button_pressed():
	get_node("LoadScene").visible = true

func _on_back_button_pressed():
	get_node("LoadScene").visible = false
