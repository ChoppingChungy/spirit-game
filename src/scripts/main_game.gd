extends Node

const BAR = preload("uid://bvkn4awiardov")
const MIX = preload("uid://rswunmjp4n4w")
const TOPPING = preload("uid://co61gy3pe3qm8")
const DRINK_SELECTED_MENU = preload("uid://c3b0oklocj8vt")

@onready var gui: CanvasLayer = %GUI
@onready var scene_switcher: SceneSwitcher = $GUI/SceneSwitcher
@onready var world: Node2D = %World
@onready var mix_menu: MixMenu = $GUI/MixMenu as MixMenu

var current_scene: Node2D

enum DrinkStation {
	MIX,
	TOPPING,
}

var current_drink_station: DrinkStation = DrinkStation.MIX

enum ToppingType {
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
	var topping: ToppingType

var current_drink = Drink.new()

func _ready() -> void:
	current_scene = BAR.instantiate()
	world.add_child(current_scene)
	scene_switcher.set_pointing_to("drinks")


func switch_scene():
	var new_scene: Node2D
	
	if current_scene:
		current_scene.queue_free()
	
	# This is kind of confusing, but we're matching where we're swapping FROM, not TO.
		if current_scene is Bar:
			
			# Loads either the mix or topping stations, depending on which one is needed.
			match current_drink_station:
				DrinkStation.MIX:
					new_scene = MIX.instantiate() as Mix
					new_scene.drink_selected.connect(_on_mix_drink_selected)
					mix_menu.show()
					
				DrinkStation.TOPPING:
					new_scene = TOPPING.instantiate() as Topping
					
			scene_switcher.set_pointing_to("bar")
			
		elif current_scene is Mix or current_scene is Topping:
			new_scene = BAR.instantiate() as Bar
			scene_switcher.set_pointing_to("drinks")
			
			mix_menu.hide()
	
	world.add_child(new_scene)
	current_scene = new_scene


func _on_scene_switcher_scene_switched() -> void:
	switch_scene()


func _on_mix_drink_selected(drink_type: String) -> void:
	print_debug(current_drink.base.size())
	# Returns early to prevent new drinks from being added when the drink is full.
	if current_drink.base.size() == 3:
		return
	
	var drink_menu := DRINK_SELECTED_MENU.instantiate() as DrinkSelectedMenu
	
	# Connects the drink menu's pour function to pour the drink in the Mix scene and add it to the current_drink
	drink_menu.poured.connect(_on_drink_menu_poured)
	drink_menu.canceled.connect(_on_drink_menu_canceled)
	gui.add_child(drink_menu)
	
	# Sets the drink tooltip in the drink_menu.
	drink_menu.set_tooltip(drink_type.capitalize(), "Default")


func _on_drink_menu_poured() -> void:
	var mix_scene = current_scene as Mix
	var poured_drink: DrinkType = mix_scene.pour() as DrinkType
	
	# Increments the meter in the mix menu by one unit
	mix_menu.increment_meter()
	
	# Addes the poured drink into the list of bases
	current_drink.base.append(poured_drink)

	# Shows the mix button by default, since pouring a unit implies that there is more than one unit in the drink.
	mix_menu.set_button_visibility(true)

	if current_drink.base.size() == 3:
		pass # Do something here to only allow mixing in the Mix menu.


func _on_drink_menu_canceled() -> void:
	var mix_scene := current_scene as Mix
	mix_scene.cancel()


## Resets the drink if the user trashes it or finishes the current customer.
func reset_drink() -> void:
	var mix_scene = current_scene as Mix
	mix_scene.cancel()
	mix_menu.set_button_visibility(false)
	mix_menu.reset()
	current_drink = Drink.new()


func _on_mix_menu_mix_pressed() -> void:
	current_scene.queue_free()
	current_scene = TOPPING.instantiate()
	world.add_child(current_scene)
	mix_menu.hide()
	mix_menu.reset()
	
	current_drink_station = DrinkStation.TOPPING


func _on_mix_menu_trash_pressed() -> void:
	reset_drink()
