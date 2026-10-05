extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $sprite
@onready var area_2d: Area2D = $Area2D

var speed = 300
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction = Vector2(1,0)
var screen_size = Vector2()
var window_size = Vector2(200,200)

var idle_timer = 0.0
var is_idling = false

var is_dragging = false
var drag_offset = Vector2()

func _ready() -> void:
	screen_size = Vector2(DisplayServer.screen_get_size())
	sprite.play("walk")

func idle_chance():
	if randf() < 0.3:
		is_idling = true
		idle_timer = randf_range(1.0,3.0)
		sprite.play("idle")
		speed = 0

func locate_mouse() -> Vector2:
	return Vector2(DisplayServer.mouse_get_position() - DisplayServer.window_get_position())

func _physics_process(delta: float) -> void:
	GameState.time_alive += delta
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if is_dragging:
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			is_dragging = false
			sprite.play("walk")
		else:
			var target = locate_mouse() - drag_offset
			target.x = clamp(target.x, 0, screen_size.x - window_size.x)
			target.y = clamp(target.y, 0, screen_size.y - window_size.y)
			velocity = (target - position) / delta
		move_and_slide()
		return
	
	if is_idling:
		idle_timer -= delta
		if idle_timer <= 0:
			is_idling = false
			speed = 300
			sprite.play("walk")
		return
		
	velocity.x = direction.x * speed
	move_and_slide()

	if is_on_wall():
		direction.x *= -1
		sprite.flip_h = !sprite.flip_h
		idle_chance()

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		is_dragging = true
		is_idling = false
		drag_offset = locate_mouse() - position
