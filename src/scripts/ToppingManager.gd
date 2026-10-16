extends Control

enum Garnish { CHERRY, LIME, BLOOD_ORANGE, LEMON }

var current_garnish: Garnish = Garnish.CHERRY

@onready var cherry_button: Button = $CherryButton
@onready var lime_button: Button = $LimeButton
@onready var blood_orange_button: Button = $BloodOrangeButton
@onready var lemon_button: Button = $LemonButton

func _ready() -> void:
	cherry_button.pressed.connect(_on_garnish_pressed.bind(Garnish.CHERRY))
	lime_button.pressed.connect(_on_garnish_pressed.bind(Garnish.LIME))
	blood_orange_button.pressed.connect(_on_garnish_pressed.bind(Garnish.BLOOD_ORANGE))
	lemon_button.pressed.connect(_on_garnish_pressed.bind(Garnish.LEMON))

func _on_garnish_pressed(garnish: Garnish) -> void:
	current_garnish = garnish
	print("Selected: ", Garnish.keys()[current_garnish])
