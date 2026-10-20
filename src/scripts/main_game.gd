extends Node

const BAR = preload("uid://bvkn4awiardov")
const MIX = preload("uid://rswunmjp4n4w")
const TOPPING = preload("uid://co61gy3pe3qm8")
const DRINK_SELECTED_MENU = preload("uid://c3b0oklocj8vt")

@onready var scene_switcher: SceneSwitcher = $GUI/SceneSwitcher

@onready var world: Node2D = %World

var current_scene: Node2D
var current_scene_name: String

var current_selected_drink: String

enum Topping {
	CHERRY,
	BLOOD_ORANGE,
}

enum DrinkType {
	VODKA,
	TEQUILA,
	BRANDY,
	WHISKEY,
	GIN,
	RUM,
	NONE, # Required as it's impossible to assign null to an enum-type var
}

class Drink:
	var base: Array[DrinkType] = []
	var topping: Topping

var current_drink = Drink.new()

func _ready() -> void:
	current_scene = BAR.instantiate()
	current_scene_name = "bar"
	world.add_child(current_scene)
	scene_switcher.set_pointing_to("drinks")


func switch_scene():
	var new_scene: Node2D
	var new_scene_name: String
	
	if current_scene:
		current_scene.queue_free()
	
	match current_scene_name:
		"bar":
			new_scene = MIX.instantiate() as Mix
			new_scene.drink_selected.connect(_on_mix_drink_selected)
			new_scene_name = "drinks"
			scene_switcher.set_pointing_to("bar")
		"drinks":
			new_scene = BAR.instantiate() as Bar
			new_scene_name = "bar"
			scene_switcher.set_pointing_to("drinks")
	
	world.add_child(new_scene)
	current_scene = new_scene
	current_scene_name = new_scene_name


func _on_scene_switcher_scene_switched() -> void:
	switch_scene()


func _on_mix_drink_selected(drink_type: String) -> void:
	var mix_scene := current_scene as Mix
	var drink_menu := DRINK_SELECTED_MENU.instantiate() as DrinkSelectedMenu
	# Connects the drink menu's pour function to pour the drink in the Mix scene and add it to the current_drink
	drink_menu.mixed.connect(_on_drink_menu_mixed)
	drink_menu.canceled.connect(_on_drink_menu_canceled)
	add_child(drink_menu)
	drink_menu.set_tooltip(DrinkType.keys().get(mix_scene.selected_drink), "Default")
	print_debug(drink_type)


func _on_drink_menu_mixed() -> void:
	var mix_scene = current_scene as Mix
	var poured_drink: DrinkType = mix_scene.pour() as DrinkType
	current_drink.base.append(poured_drink)
	if current_drink.base.size() == 3:
		pass # Do something here to only allow mixing in the Mix menu.
	print_debug(current_drink.base)

func _on_drink_menu_canceled() -> void:
	var mix_scene := current_scene as Mix
	mix_scene.cancel()
