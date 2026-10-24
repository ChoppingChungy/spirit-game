class_name Bar
extends Node2D

@onready var ghost: Sprite2D = $Ghost

const GHOST_Y_POSITION = 510

func _ready() -> void:
	loop_tween()


func loop_tween() -> void:
	await create_tween().tween_property(ghost, "position:y", GHOST_Y_POSITION + 20, 1).set_trans(Tween.TRANS_SINE).finished
	await create_tween().tween_property(ghost, "position:y", GHOST_Y_POSITION - 20, 1).set_trans(Tween.TRANS_SINE).finished
	loop_tween()
