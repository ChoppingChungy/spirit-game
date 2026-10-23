class_name MixMenu
extends Control

signal mix_pressed
signal trash_pressed

@onready var fill_meter: ProgressBar = %FillMeter
@onready var mix: Button = %Mix
@onready var trash: Button = %Trash

func set_meter(value: int) -> void:
	fill_meter.value = value


func set_button_visibility(showing: bool) -> void:
	mix.visible = showing
	trash.visible = showing
	


func increment_meter() -> void:
	fill_meter.value += 1

func _on_mix_pressed() -> void:
	mix_pressed.emit()


func reset() -> void:
	set_button_visibility(false)
	set_meter(0)


func _on_trash_pressed() -> void:
	trash_pressed.emit()
