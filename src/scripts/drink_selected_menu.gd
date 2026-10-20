class_name DrinkSelectedMenu
extends Control

signal poured
signal canceled

@onready var drink_tooltip: DrinkTooltip = $DrinkTooltip

func _on_pour_pressed() -> void:
	poured.emit()
	queue_free()


func _on_cancel_pressed() -> void:
	canceled.emit()
	queue_free()


func set_tooltip(title: String, information: String) -> void:
	drink_tooltip.set_title(title)
	drink_tooltip.set_information(information)
