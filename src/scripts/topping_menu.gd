class_name ToppingMenu
extends Control

signal serve_pressed
signal trash_pressed

@onready var serve: Button = %Serve
@onready var trash: Button = %Trash

func set_button_visibility(showing: bool) -> void:
	serve.visible = showing


func _on_serve_pressed() -> void:
	serve_pressed.emit()


func reset() -> void:
	set_button_visibility(false)


func _on_trash_pressed() -> void:
	trash_pressed.emit()
