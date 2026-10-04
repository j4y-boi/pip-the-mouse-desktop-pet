extends Control
@onready var confirmation_dialog: ConfirmationDialog = $ConfirmationDialog

@onready var side_bar: PanelContainer = $SideBar
@onready var stats: PanelContainer = $Stats

@onready var side_bar_animation: AnimationPlayer = $SideBar/SideBarAnimation
@onready var stat_animations: AnimationPlayer = $Stats/StatAnimations

@onready var alive_time: RichTextLabel = $Stats/Content/AliveTime
@onready var feed_count: RichTextLabel = $Stats/Content/FeedCount
@onready var playtime_total: RichTextLabel = $Stats/Content/PlaytimeTotal
@onready var restart_count: RichTextLabel = $Stats/Content/RestartCount

func convert_int_time_to_string(time:int) -> String:
	@warning_ignore("integer_division") var seconds = time % 60 
	@warning_ignore("integer_division") var minutes = time / 60 % 60
	@warning_ignore("integer_division") var hour = time / 3600 % 24
	var result = "%02d:%02d:%02d" % [hour, minutes, seconds]
	return result

func _process(delta: float) -> void:
	GameState.total_playtime += delta
	alive_time.text = convert_int_time_to_string(GameState.time_alive)
	feed_count.text = str(GameState.times_fed)
	playtime_total.text = convert_int_time_to_string(GameState.total_playtime)
	restart_count.text = str(GameState.times_restarted)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		side_bar_animation.play("show")

func _on_feed_pressed() -> void:
	GameState.times_fed += 1

func _on_play_pressed() -> void:
	pass # Replace with function body.

func _on_stats_pressed() -> void:
	stat_animations.play("show")
	side_bar_animation.play_backwards("show")
	await side_bar_animation.animation_finished
	
func _on_quit_pressed() -> void:
	confirmation_dialog.popup_centered()

func _on_confirmation_dialog_confirmed() -> void:
	get_tree().quit()

func _on_stat_exit_pressed() -> void:
	stat_animations.play_backwards("show")
	side_bar_animation.play("show")
