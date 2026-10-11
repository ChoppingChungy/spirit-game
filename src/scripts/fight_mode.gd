extends Node
@onready var spirit_bar: ColorRect = $CanvasLayer/ColorRect
var wet:bool = false
signal damaged(num)
signal pressure_changed(pressure)
@onready var watergun: Node2D = $watergun
@export var increment: int
@export var decrement: int
@onready var color_rect: ColorRect = $CanvasLayer/Control/ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


var spirit_health = 100.0

func update_health():
	var pressure = (color_rect.size.x / (1920 /2))
	pressure_changed.emit(pressure)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if wet and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		color_rect.size.x += increment * delta
	else:
		color_rect.size.x += decrement * delta
	update_health()

	

func _on_spirit_entity_wet() -> void:
	wet = not wet
