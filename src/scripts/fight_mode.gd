extends Node
@onready var spirit_bar: ColorRect = $CanvasLayer/ColorRect
var wet:bool = false
signal damaged(num)
@onready var watergun: Node2D = $watergun
@export var increment: int
@export var decrement: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if wet and watergun.visible == true:
		emit_signal("damaged",increment * delta)
	else:
		emit_signal("damaged",decrement * delta)
func _on_spirit_flashed() -> void:
	wet = not wet
