class_name Tooltip
extends Control

@onready var title: Label = $PanelContainer/MarginContainer/VBoxContainer/Title
@onready var information: Label = $PanelContainer/MarginContainer/VBoxContainer/Information

func set_title(p_title: String) -> void:
	
	title.text = p_title

func set_information(p_information: String) -> void:
	information.text = p_information
