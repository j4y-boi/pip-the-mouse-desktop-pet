extends CharacterBody2D

@export var push_force: float = 150.0
@onready var sprite: AnimatedSprite2D = $sprite

signal ate(name:String)

var stuff_on_top = [] #aouidfofapoisjofiaiopsjadfsdfa

var speed:int = 300
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var consecutive_actions:int = 0

var direction = Vector2(1,0)
var screen_size = Vector2()
var window_size = Vector2(200,200)

var idle_timer:float = 0.0
var is_idling:bool = false

var is_dragging:bool = false
var drag_offset = Vector2()

func _ready() -> void:
	screen_size = Vector2(DisplayServer.screen_get_size())
	sprite.play("walk")

func idle_chance(overwrite:bool=false):
	if randf() < 0.3 or overwrite:
		is_idling = true
		var anims = ["idle","itch","look"]
		var chosen = anims.pick_random()
		if chosen == "idle":
			idle_timer = randf_range(3.0,8.0)
		else:
			idle_timer = randf_range(1.0,4.0)
		sprite.play(chosen) #i didnt even know that pick_random() existed
		consecutive_actions += 1
		speed = 0

func locate_mouse() -> Vector2: 
	#uhhhh so i made the game run at 1080p to prevent scaling
	#but that causes drift in mouse if youre not using a 1080p screen
	#hotfix
	var positon = Vector2(DisplayServer.mouse_get_position() - DisplayServer.window_get_position())
	var screen_mult = get_viewport_rect().size / Vector2(DisplayServer.window_get_size())
	return positon * screen_mult

func push_stuff() -> void: #its a fuckin miracle that this kinda works 
	for body in stuff_on_top:
		print("moving: " + body.name)
		if is_instance_valid(body):
			body.linear_velocity.x = velocity.x
			body.linear_velocity.y = 0
			body.global_position.y = global_position.y - 81

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		set_collision_mask_value(2, false)
	else:
		set_collision_mask_value(2, true)
		
	if is_dragging:
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			is_dragging = false	
			sprite.play("walk")
			speed = 300
		else:
			set_collision_mask_value(2, false)
			var target = locate_mouse() - drag_offset
			target.x = clamp(target.x, 0, screen_size.x - window_size.x)
			target.y = clamp(target.y, 0, screen_size.y - window_size.y)
			velocity = (target - position) / delta
			speed = 0
		move_and_slide()
		push_stuff()
		return
	
	if is_idling:
		idle_timer -= delta
		velocity.x = 0
		if idle_timer <= 0:
			is_idling = false
			speed = 300
			sprite.play("walk")
		move_and_slide()
		return
		
	velocity.x = direction.x * speed
	move_and_slide()
	push_stuff()
	
	if is_on_wall():
		for i in get_slide_collision_count():
			var collider = get_slide_collision(i).get_collider()
			
			if collider.is_in_group("walls"):
				direction.x *= -1
				sprite.flip_h = !sprite.flip_h
				idle_chance()
				break
			
			if collider.is_in_group("food") or collider.is_in_group("ball"):
				is_idling = true
				idle_timer = randf_range(2.0,4.0)
				if collider.is_in_group("food"): #son
					sprite.play("fed")
					GameState.times_fed += 1
				else:
					GameState.times_played += 1
					sprite.play("play")
				ate.emit(collider.name)
				break

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		is_dragging = true
		is_idling = false
		speed = 300
		drag_offset = locate_mouse() - position

func _on_sprite_animation_changed() -> void:
	if sprite== null: #bro godot twaeking if i dont do this
		return
	if sprite.animation.get_basename() == "fed": #fed animation is 48x48 instead of ususal 32x32, offset by 8 so pip stays in the same spot
		if not sprite.flip_h:
			sprite.offset = Vector2(8,-8)
		else:
			sprite.offset = Vector2(-8,-8)
	elif sprite.animation.get_basename() == "play":
		if not sprite.flip_h:
			sprite.offset = Vector2(4,-16)
		else:
			sprite.offset = Vector2(-4,-16)
	else:
		sprite.offset = Vector2.ZERO


func _on_rigidbody_detetcor_body_entered(body: Node2D) -> void:
	print( body.name, " | id: ", body.get_instance_id())
	if body is RigidBody2D:
		if not stuff_on_top.has(body):
			stuff_on_top.append(body)

func _on_rigidbody_detetcor_body_exited(body: Node2D) -> void:
	print(body.name, " | id: ", body.get_instance_id())
	if body is RigidBody2D:
		stuff_on_top.erase(body)
