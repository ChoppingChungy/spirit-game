extends Node

const BAR = preload("uid://bvkn4awiardov")
const MIX = preload("uid://rswunmjp4n4w")
const TOPPING = preload("uid://co61gy3pe3qm8")

@onready var scene_switcher: SceneSwitcher = $GUI/SceneSwitcher
@onready var world: Node2D = %World

var current_scene: Node2D
var current_scene_name: String

enum Topping {
	CHERRY,
	BLOOD_ORANGE,
}

var current_drink: Dictionary = {
	"base": [
		"first",
		"second",
		"third",
	],
	"topping": "cherry",
}

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
			new_scene = MIX.instantiate()
			new_scene_name = "drinks"
			scene_switcher.set_pointing_to("bar")
		"drinks":
			new_scene = BAR.instantiate()
			new_scene_name = "bar"
			scene_switcher.set_pointing_to("drinks")
	
	world.add_child(new_scene)
	current_scene = new_scene
	current_scene_name = new_scene_name


func _on_scene_switcher_scene_switched() -> void:
	switch_scene()
