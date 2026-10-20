class_name Mix
extends Node2D

## Tells the main game what drink was selected for the title.
signal drink_selected(drink_type: String)

enum Drinks {
	VODKA,
	TEQUILA,
	BRANDY,
	WHISKEY,
	GIN,
	RUM,
	NONE, # Required as it's impossible to assign null to an enum-type var
}

var selected_drink: Drinks = Drinks.NONE

func _on_drink_clicked(drink_type: Drinks) -> void:
	# Returns early if the drink isn't NONE, since that means we're currently deciding to pour or cancel.
	if not selected_drink == Drinks.NONE:
		return
	
	selected_drink = drink_type
	
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
		Drinks.GIN:
			drink_selected.emit("gin")
		Drinks.RUM:
			drink_selected.emit("rum")


func pour() -> Drinks:
	var returned_drink = selected_drink
	selected_drink = Drinks.NONE
	return returned_drink


func cancel() -> void:
	selected_drink = Drinks.NONE
