extends Control

signal scene_switched(scene_name: String)

func _on_bar_pressed() -> void:
	scene_switched.emit("bar")


func _on_mix_pressed() -> void:
	scene_switched.emit("mix")


func _on_topping_pressed() -> void:
	scene_switched.emit("topping")
