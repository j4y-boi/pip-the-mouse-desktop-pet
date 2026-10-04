extends Node2D
@onready var sprite: AnimatedSprite2D = $Pip/sprite
@onready var area_2d: Area2D = $Pip/Area2D

var speed = 300

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
		var r = randi() % 3
		
		if r == 0:
			sprite.play("idle")
			speed = 0

func _physics_process(delta: float) -> void:
	if is_idling:
		idle_timer -= delta
		if idle_timer <= 0:
			is_idling = false
			speed = 300
			sprite.play("walk")
		return
	
	if is_dragging:
		var mouse_pos = Vector2(DisplayServer.mouse_get_position())
		var new_win_pos = mouse_pos - drag_offset
		DisplayServer.window_set_position(Vector2i(new_win_pos))
		return
	
	var window_position = Vector2(DisplayServer.window_get_position())
	window_position += direction*speed*delta
	print(window_position)
	window_position.x = clamp(window_position.x,0,screen_size.x - window_size.x)
	window_position.y = clamp(window_position.y,0,screen_size.y - window_size.y)
	DisplayServer.window_set_position(window_position)
	
	if window_position.x <= 0 or window_position.x >= screen_size.x - window_size.x:
		direction.x *= -1
		sprite.flip_h = !sprite.flip_h
		idle_chance()
	
	if window_position.y <= 0 or window_position.y >= screen_size.y - window_size.y:
		direction.y *= -1
		idle_chance()

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			is_dragging = true
			var mouse_pos = Vector2(DisplayServer.mouse_get_position())
			var win_pos = Vector2(DisplayServer.window_get_position())
			drag_offset = mouse_pos - win_pos
		else:
			is_dragging = false
