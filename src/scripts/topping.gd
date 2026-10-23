class_name Topping
extends Node2D

## Tells the main game what topping was selected for the title.
signal topping_selected(topping_type: String)

enum Toppings {
	TOPPING1,
	TOPPING2,
	TOPPING3,
	TOPPING4,
	NONE, # Required as it's impossible to assign null to an enum-type var
}

var selected_topping: Toppings = Toppings.NONE

func _on_topping_clicked(topping_type: Toppings) -> void:
	# Returns early if the topping isn't NONE, since that means we're currently deciding to pour or cancel.
	if not selected_topping == Toppings.NONE:
		return
	
	selected_topping = topping_type
	
	# Tells the MainGame what topping was selected
	match topping_type:
		_:
			topping_selected.emit("topping")

## Tops the drink with the currently-selected topping.
func top() -> Toppings:
	var returned_topping = selected_topping
	selected_topping = Toppings.NONE
	return returned_topping

## Cancels the topping and returns to a no-topping state.
func cancel() -> void:
	selected_topping = Toppings.NONE
	
