class_name DrinkSelectedMenu
extends Control

signal poured
signal canceled

@onready var tooltip: Tooltip = $Tooltip

func _on_pour_pressed() -> void:
	poured.emit()
	queue_free()


func _on_cancel_pressed() -> void:
	canceled.emit()
	queue_free()


func set_tooltip(title: String, information: String) -> void:
	tooltip.set_title(title)
	tooltip.set_information(information)
