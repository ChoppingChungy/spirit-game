extends Node

@onready var world: Node2D = %World
const BAR = preload("uid://bvkn4awiardov")
const MIX = preload("uid://rswunmjp4n4w")
const TOPPING = preload("uid://co61gy3pe3qm8")

var current_scene: Node2D

func _ready() -> void:
	switch_scene("bar")


func switch_scene(scene_name: String):
	var new_scene: Node2D
	
	if current_scene:
		current_scene.queue_free()
	
	match scene_name:
		"bar":
			new_scene = BAR.instantiate()
		"mix":
			new_scene = MIX.instantiate()
		"topping":
			new_scene = TOPPING.instantiate()
	
	world.add_child(new_scene)
	current_scene = new_scene


func _on_scene_switcher_scene_switched(scene_name: String) -> void:
	switch_scene(scene_name)
