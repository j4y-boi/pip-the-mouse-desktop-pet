extends Control
@onready var confirmation_dialog: ConfirmationDialog = $ConfirmationDialog
@onready var food_original: RigidBody2D = $SideBar/food
@onready var ball_original: RigidBody2D = $SideBar/ball

@onready var side_bar: PanelContainer = $SideBar
@onready var stats: PanelContainer = $Stats

@onready var side_bar_animation: AnimationPlayer = $SideBar/SideBarAnimation
@onready var stat_animations: AnimationPlayer = $Stats/StatAnimations

@onready var alive_time: RichTextLabel = $Stats/Content/AliveTime
@onready var feed_count: RichTextLabel = $Stats/Content/FeedCount
@onready var playtime_total: RichTextLabel = $Stats/Content/PlaytimeTotal
@onready var restart_count: RichTextLabel = $Stats/Content/RestartCount

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

func _process(delta: float) -> void:
	GameState.total_playtime += delta
	if stats.visible:
		alive_time.text = convert_int_time_to_string(GameState.time_alive)
		feed_count.text = str(GameState.times_fed)
		playtime_total.text = convert_int_time_to_string(GameState.total_playtime)
		restart_count.text = str(GameState.times_restarted)
	
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

func _on_feed_pressed() -> void:
	GameState.times_fed += 1
	var buffer = food_original.duplicate() #WHAT THE HELL IS THIS FOR THEN IF I NEED TO ADD IT ANYWAY
	buffer.show()
	buffer.process_mode = Node.PROCESS_MODE_INHERIT
	add_child(buffer)

func _on_play_pressed() -> void:
	var buffer = ball_original.duplicate()
	buffer.show()
	buffer.process_mode = Node.PROCESS_MODE_INHERIT
	add_child(buffer)

func _on_stats_pressed() -> void:
	if not busy:
		busy = true
		
		stats.show()
		stat_animations.play("show")
		side_bar_animation.play_backwards("show")
		
		await side_bar_animation.animation_finished
		
		side_bar.hide()
		busy = false
	
func _on_quit_pressed() -> void:
	confirmation_dialog.popup_centered()

func _on_confirmation_dialog_confirmed() -> void:
	get_tree().quit()

func _on_stat_exit_pressed() -> void:
	if not busy:
		busy = true
		side_bar.show()
		side_bar_animation.play("show")
		stat_animations.play_backwards("show")
		await stat_animations.animation_finished
		stats.hide()
		busy = false

func _on_interact_enter_mouse_shape_entered(_shape_idx: int) -> void: #idek if this ones better but dont touch it if it aint broken
	if not menuopen:
		menu_toggle(true)
