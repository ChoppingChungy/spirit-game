class_name MixMenu
extends Control

signal mix_pressed

@onready var fill_meter: ProgressBar = %FillMeter
@onready var mix: Button = %Mix

func set_meter(value: int) -> void:
	fill_meter.value = value


func set_mix_visibility(showing: bool) -> void:
	mix.visible = showing


func increment_meter() -> void:
	fill_meter.value += 1

func _on_mix_pressed() -> void:
	mix_pressed.emit()
