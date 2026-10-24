class_name Mix
extends Node2D

## Tells the main game what drink was selected for the title.
signal drink_selected(drink_type: String)

enum Drinks {
	VODKA,
	TEQUILA,
	BRANDY,
	WHISKEY,
	GINGER,
	RUM,
	NONE, # Required as it's impossible to assign null to an enum-type var
}

# --- Tweak these in the Inspector ---
@export var ready_position := Vector2(50, 50)
@export var ready_rotation_deg := 20.0
@export var pour_rotation_deg := 110.0   # flip the sign if it tips the wrong way
@export var move_time := 0.3
@export var tilt_time := 0.25
@export var pour_hold_time := 0.8

# Maps each drink enum to its drink node. Change the paths to match your scene.
@onready var drinks_dict: Dictionary = {
	Drinks.VODKA: $Vodka,
	Drinks.TEQUILA: $Tequila,
	Drinks.BRANDY: $Brandy,
	Drinks.WHISKEY: $Whiskey,
	Drinks.GINGER: $Ginger,
	Drinks.RUM: $Rum,
}

var selected_drink_enum: Drinks = Drinks.NONE
var selected_drink_object: Control   # TextureButtons, which extend Control

# Cached "home" state of the selected drink.
var home_position: Vector2
var home_rotation_deg: float
var home_z: int

var tween: Tween
var busy := false  # true while a drink is animating back home


func _ready() -> void:
	# Sets the rotation pivot point of each drink object. without it the drinks would rotate differently
	for drink_object: Control in drinks_dict.values():
		drink_object.pivot_offset = drink_object.size / 2.0


func _on_drink_clicked(drink_type: Drinks) -> void:
	# Ignore clicks while deciding pour/cancel, or while a drink is still returning.
	if selected_drink_enum != Drinks.NONE or busy:
		return
	
	selected_drink_enum = drink_type
	selected_drink_object = drinks_dict[drink_type]
	
	# Cache where the drink came from so we can put it back.
	home_position = selected_drink_object.position
	home_rotation_deg = selected_drink_object.rotation_degrees
	home_z = selected_drink_object.z_index
	
	# Draw the lifted drink on top of everything else.
	selected_drink_object.z_index = 100
	
	# Move to the ready position while tilting, both at once.
	_kill_tween()
	tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(selected_drink_object, "position", ready_position, move_time)
	tween.tween_property(selected_drink_object, "rotation_degrees", ready_rotation_deg, move_time)
	
	# Tells the MainGame what drink was selected
	match drink_type:
		Drinks.VODKA:
			drink_selected.emit("vodka")
		Drinks.TEQUILA:
			drink_selected.emit("tequila")
		Drinks.BRANDY:
			drink_selected.emit("brandy")
		Drinks.WHISKEY:
			drink_selected.emit("whiskey")
		Drinks.GINGER:
			drink_selected.emit("ginger")
		Drinks.RUM:
			drink_selected.emit("rum")


func pour() -> Drinks:
	var returned_drink_enum := selected_drink_enum
	var drink_object := selected_drink_object
	
	# Clear selection immediately so game logic isn't waiting on the animation.
	selected_drink_enum = Drinks.NONE
	selected_drink_object = null
	
	if drink_object:
		busy = true
		var pos := home_position
		var rot := home_rotation_deg
		var z := home_z
		
		_kill_tween()
		tween = create_tween()
		tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		
		# 1. Tip the drink into pouring position.
		tween.tween_property(drink_object, "rotation_degrees", pour_rotation_deg, tilt_time)
		# 2. Hold there for a moment (liquid animation will go here later).
		tween.tween_interval(pour_hold_time)
		# 3. Return home, moving and rotating at the same time.
		tween.tween_property(drink_object, "position", pos, move_time)
		tween.parallel().tween_property(drink_object, "rotation_degrees", rot, move_time)
		# 4. Restore draw order and unlock.
		tween.tween_callback(_on_drink_home.bind(drink_object, z))
	
	return returned_drink_enum


func cancel() -> void:
	var drink_object := selected_drink_object
	selected_drink_enum = Drinks.NONE
	selected_drink_object = null
	
	# reset_drink() in the main script calls this even with no selection, so guard.
	if drink_object == null:
		return
	
	busy = true
	var z := home_z
	
	_kill_tween()
	tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(drink_object, "position", home_position, move_time)
	tween.tween_property(drink_object, "rotation_degrees", home_rotation_deg, move_time)
	tween.chain().tween_callback(_on_drink_home.bind(drink_object, z))


func _on_drink_home(drink_object: Control, z: int) -> void:
	drink_object.z_index = z
	busy = false


func _kill_tween() -> void:
	if tween and tween.is_valid():
		tween.kill()
