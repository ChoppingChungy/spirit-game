class_name Bar
extends Node2D

@onready var ghost: Sprite2D = $Ghost

const GHOST_Y_POSITION = 510

var ghost_tween: Tween

func _ready() -> void:
	loop_tween()


func loop_tween() -> void:
	ghost_tween = create_tween()
	ghost_tween.tween_property(ghost, "position:y", GHOST_Y_POSITION + 20, 1).set_trans(Tween.TRANS_SINE)
	ghost_tween.tween_property(ghost, "position:y", GHOST_Y_POSITION - 20, 1).set_trans(Tween.TRANS_SINE).finished.connect(loop_tween)


## Moves the old customer out and the new customer in.
func swap_customer(new_customer_texture: CompressedTexture2D) -> void:
	await create_tween().tween_property(ghost, "position:x", -600, 3).set_trans(Tween.TRANS_QUAD).finished
	
	# Assigns the new texture to the ghost object.
	ghost.texture = new_customer_texture
	
	# Teleports the ghost sprite to the right side of the screen.
	ghost.position.x = DisplayServer.window_get_size().x + 600
	
	# Moves the ghost texture back to the center with the new texture.
	await create_tween().tween_property(ghost, "position:x", 960, 3).set_trans(Tween.TRANS_QUAD).finished
