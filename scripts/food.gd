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

var dragging = false
var click_radius = 32 # Size of the sprite.

var drag_target := Vector2.ZERO
var throw = Vector2.ZERO

func _ready() -> void:
	food.global_position = Vector2(56.5,540)
	sprite.texture = load(used)
	launch()

func launch() -> void:
	angle = deg_to_rad(angle)
	var direction := Vector2(cos(angle), sin(angle))
	apply_central_impulse(direction * launch_speed)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void: #this nullifies forces while dragigng
	if dragging:
		state.transform.origin = drag_target
		state.linear_velocity = Vector2.ZERO #nah cuz godot tripping when i dont do this

func _input(event): #taken from the godot docs and modified cuz im too lazy
	#this function can probably be optimized but i cant be arsed to figure out what cry about it
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if (event.position - food.position).length() < click_radius:
			if not dragging and event.pressed:
				dragging = true
				drag_target = get_global_mouse_position()
		if dragging and not event.pressed:
			dragging = false
			linear_velocity = throw

	if event is InputEventMouseMotion and dragging:
		drag_target = get_global_mouse_position()
		throw = event.velocity
