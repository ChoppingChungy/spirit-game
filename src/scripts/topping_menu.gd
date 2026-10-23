class_name ToppingMenu
extends Control

signal serve_pressed
signal trash_pressed

@onready var serve: Button = %Serve
@onready var trash: Button = %Trash

func _on_serve_pressed() -> void:
	serve_pressed.emit()

func _on_trash_pressed() -> void:
	trash_pressed.emit()
