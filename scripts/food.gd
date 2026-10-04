extends RigidBody2D
@onready var sprite: Sprite2D = $sprite
@onready var food: RigidBody2D = $"."

var sprites = [
	"res://assets/food/apple_slice.png",
	"res://assets/food/blueberry.png",
	"res://assets/food/cheese.png",
	"res://assets/food/sunflowerseed.png",
]
var launch_speed: float = 600.0
var angle = randi_range(-80,-20)
var used = sprites[randi_range(0,len(sprites)-1)]

func _ready() -> void:
	food.global_position = Vector2(56.5,540)
	sprite.texture = load(used)
	launch()

func launch() -> void:
	angle = deg_to_rad(angle)
	var direction := Vector2(cos(angle), sin(angle))
	apply_central_impulse(direction * launch_speed)
