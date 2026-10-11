extends Node

func choose_move(category,difficulty):
	var total_weight = 0.0
	var move_weights = []
	
	
	# Calculate the weight of every move
	for move in category_list[category]:
		var difference = abs(difficulty - move["difficulty"])
		var weight = pow(1.0 - difference, 2)

		move_weights.append(weight)
		total_weight += weight

	# Roll somewhere within the total weight
	var roll = randf_range(0.0, total_weight)

	# Find which move the roll landed on
	var current_weight = 0.0

	for i in range(category_list[category].size()):
		current_weight += move_weights[i]
		if roll <= current_weight:
			print(category_list[category][i])
			return category_list[category][i]
@onready var category_list = {
	"movement":movement_moves,
	"teleport":teleport_moves,
	"special":special_moves

}

var movement_moves = [
	{
		"action": dash,
		"difficulty":0.1,
	},
	{
		"action":circle,
		"difficulty":0.5
		
	}
	
]

var teleport_moves = [
	{
		"action":skip,
		"difficulty": 0.1
		
		
	},
	{
		"action":anywhere,
		"difficulty":0.3
		
		
	},
	
] 

var special_moves = [
	{
		"action":"double_fake",
		"difficulty": 1
		
		
		
	},
	
	
	
]


func dash(spirit, direction: Vector2):
	spirit.velocity = direction * spirit.speed * 2.5
	
func circle(spirit,direction):
	spirit.velocity = direction * spirit.speed * 3
	spirit.turn_timer = 1
	spirit.turn_speed = spirit.speed / 75.0
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
func skip(spirit,direction):
		
	var distance = spirit.speed /2.0
	var target = spirit.position + direction * distance
	var screen_size = spirit.get_viewport_rect().size

	target.x = wrapf(
		target.x,
		spirit.radius,
		screen_size.x - spirit.radius
	)

	target.y = wrapf(
		target.y,
		spirit.radius,
		screen_size.y - spirit.radius
	)

	spirit.position = target
	
func anywhere(spirit,direction):
	var screen_size = spirit.get_viewport_rect().size
	var x = randi_range(0,screen_size.x)
	var y = randi_range(0, screen_size.y)
	spirit.position.x = x
	spirit.position.y = y
