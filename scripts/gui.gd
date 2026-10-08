extends Control
@onready var confirmation_dialog: ConfirmationDialog = $ConfirmationDialog
@onready var deletion_dialog: ConfirmationDialog = $DeletionDialog

@onready var food_original: RigidBody2D = $SideBar/food
@onready var ball_original: RigidBody2D = $SideBar/ball
@onready var clone_holder: Node = $CloneHolder
@onready var smoke: GPUParticles2D = $smoke

@onready var side_bar: PanelContainer = $SideBar
@onready var stats: PanelContainer = $Stats
@onready var save_interval_button: Button = $Stats/Content/ExtraButtons/SaveInterval
@onready var tutorial: HBoxContainer = $Tutorial

@onready var side_bar_animation: AnimationPlayer = $SideBar/SideBarAnimation
@onready var stat_animations: AnimationPlayer = $Stats/StatAnimations

@onready var play_count: RichTextLabel = $Stats/Content/PlayCount
@onready var feed_count: RichTextLabel = $Stats/Content/FeedCount
@onready var playtime_total: RichTextLabel = $Stats/Content/PlaytimeTotal
@onready var spawn_count: RichTextLabel = $Stats/Content/SpawnCount

var busy = false #true if stuffs moving around
var menuopen = false #omdddd ts a hotfix but idrgaf atm

func convert_int_time_to_string(time:int) -> String:
	var seconds = time % 60 
	@warning_ignore("integer_division")
	var minutes = time / 60 % 60
	@warning_ignore("integer_division")
	var hour = time / 3600
	var result = "%02d:%02d:%02d" % [hour, minutes, seconds]
	return result

func _ready() -> void:
	stats.hide()
	side_bar.hide()
	if GameState.first_start:
		tutorial.show()
		tutorial.position = Vector2(710,425)

func _process(delta: float) -> void:
	GameState.total_playtime += delta
	if stats.visible:
		play_count.text = str(GameState.times_played)
		feed_count.text = str(GameState.times_fed)
		playtime_total.text = convert_int_time_to_string(GameState.total_playtime)
		spawn_count.text = str(GameState.items_spawned)
	
	if menuopen and not busy and not stats.visible:
		var mouse = get_global_mouse_position()
		if not side_bar.get_global_rect().grow(16).has_point(mouse):
			menu_toggle(false)

func menu_toggle(toggle = null): #some questionable choices were made
	if not busy:
		if toggle == null:
			toggle = !menuopen
		
		busy = true
		
		if toggle:
			if not stats.visible:
				menuopen = true
				side_bar.show()
				side_bar_animation.play("show")
				await side_bar_animation.animation_finished
		else:
			menuopen = false
			side_bar_animation.play_backwards("show")
			await side_bar_animation.animation_finished
			side_bar.hide()
		
		busy = false

func _input(event: InputEvent) -> void:
	if event.is_action_released("menu"):
		menu_toggle()
	
	if event.is_action_pressed("explode"):
		for child in clone_holder.get_children():
			child.linear_velocity = Vector2(randi_range(-8000,8000),randi_range(0,2000))
			child.angular_velocity = randi_range(-1000,1000)

func _on_feed_pressed() -> void:
	GameState.items_spawned += 1
	var buffer = food_original.duplicate() #WHAT THE HELL IS THIS FOR THEN IF I NEED TO ADD IT ANYWAY
	buffer.show()
	buffer.name = "food_copy"
	buffer.process_mode = Node.PROCESS_MODE_INHERIT
	clone_holder.add_child(buffer)

func _on_play_pressed() -> void:
	GameState.items_spawned += 1
	var buffer = ball_original.duplicate()
	buffer.show()
	buffer.process_mode = Node.PROCESS_MODE_INHERIT
	buffer.name = "ball_copy"
	clone_holder.add_child(buffer)

func _on_stats_pressed() -> void:
	if busy:
		var anim_length = side_bar_animation.current_animation_length
		side_bar_animation.seek(anim_length, true)
		busy = false
		
	if not busy:
		busy = true
		
		stats.show()
		stat_animations.play("show")
		side_bar_animation.play_backwards("show")
		
		await side_bar_animation.animation_finished
		
		side_bar.hide()
		busy = false
		menuopen = false
	
func _on_quit_pressed() -> void:
	confirmation_dialog.popup_centered()

func _on_confirmation_dialog_confirmed() -> void:
	GameState.saveData()
	get_tree().quit()

func _on_stat_exit_pressed() -> void:
	#if not busy:
		#busy = true
		#side_bar.show()
		#side_bar_animation.play("show")
	busy = false
	stat_animations.play_backwards("show")
	await stat_animations.animation_finished
	stats.hide()
	
		#busy = false

func _on_interact_enter_mouse_shape_entered(_shape_idx: int) -> void: #idek if this ones better but dont touch it if it aint broken
	if not menuopen:
		if GameState.first_start:
			tutorial.hide()
		menu_toggle(true)

func do_the_particle(smoke_position):
	var particle = smoke.duplicate()
	particle.finished.connect(particle.queue_free)
	particle.global_position = smoke_position
	particle.show()
	particle.emitting = true
	add_child(particle)

func _on_clear_pressed() -> void:
	for child in clone_holder.get_children():
		do_the_particle(child.global_position)
		child.queue_free()

func _on_button_2_pressed() -> void:
	GameState.saveData()

func _on_itch_button_pressed() -> void:
	if not busy:
		busy = true
		stat_animations.play_backwards("show")
		await stat_animations.animation_finished
		stats.hide()
		busy = false

func _on_clear_button_pressed() -> void:
	deletion_dialog.popup_centered()

func _on_deletion_dialog_confirmed() -> void:
	GameState.clearData()

func _on_save_interval_pressed() -> void:
	GameState.change_save_interval()
	var save_interval = str(GameState.possible_save_times[GameState.current_interval_index])
	if save_interval == "Disabled":
		save_interval_button.text = "Autosave Disabled"
	else:
		save_interval_button.text = "Save Interval: " + save_interval + "s"
