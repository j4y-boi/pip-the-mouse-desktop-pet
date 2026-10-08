extends Node

@onready var game_floor: StaticBody2D = $"../game/boundaries"
@onready var save_icon: Sprite2D = $SaveIcon
@onready var save_icon_timer: Timer = $SaveIconTimer
@onready var autosave_timer: Timer = $AutosaveTimer

var times_played = 0
var times_fed = 0
var total_playtime = 0.0
var items_spawned = 0
var first_start = false

var possible_save_times = [30,60,120,"Disabled"]
var current_interval_index = 0

var blinky := create_tween().set_loops().set_trans(Tween.TRANS_SINE)
func _ready() -> void:
	if get_tree().current_scene.name == "game":
		game_floor.position.y = 1090 - get_taskbar_height() #idek why 1090, magic number i suppose :P

	blinky.tween_property(save_icon, "modulate:a", 0.6, 0.5)
	blinky.tween_property(save_icon, "modulate:a", 1.0, 0.5)
	loadData()

func get_taskbar_height():
	return DisplayServer.screen_get_size().y - DisplayServer.screen_get_usable_rect().size.y

#everything under this is related to savesystem
#mostly adapted from https://github.com/j4y-boi/Pip-the-Mouse-Godot/blob/main/scripts/savesystem.gd

const save_location = "user://savefile.json"
var contents_to_save: Dictionary = {
	"times_played" : 0,
	"times_fed" : 0,
	"total_playtime" : 0.0,
	"items_spawned" : 0,
	"current_interval_index" : 0,
}

func saveData():
	var file
	contents_to_save["times_fed"] = times_fed
	contents_to_save["times_played"] = times_played
	contents_to_save["total_playtime"] = total_playtime
	contents_to_save["items_spawned"] = items_spawned
	contents_to_save["current_interval_index"] = current_interval_index
	print("saving")
	print(contents_to_save)
	file = FileAccess.open_encrypted_with_pass(save_location, FileAccess.WRITE, "woahsecurity")
	file.store_var(contents_to_save.duplicate())
	file.close()
	save_icon.show()
	save_icon_timer.start()

func clearData():
	DirAccess.remove_absolute(save_location)
	times_fed = 0
	times_played = 0
	total_playtime = 0.0
	items_spawned = 0
	$"../game/GUI"._on_clear_pressed()
	loadData()

func loadData():
	if FileAccess.file_exists(save_location):
		print("Loading save data")
		var file
		file = FileAccess.open_encrypted_with_pass(save_location, FileAccess.READ,"woahsecurity")
		
		var data = file.get_var()
		file.close()
		
		for key in contents_to_save.keys():
			if data.has(key) and typeof(data[key]) == typeof(contents_to_save[key]):
				contents_to_save[key] = data[key]
		
		if typeof(data) != TYPE_DICTIONARY:
			data = contents_to_save.duplicate()
		print(data)
		
		times_fed = contents_to_save["times_fed"]
		times_played = contents_to_save["times_played"]
		total_playtime = contents_to_save["total_playtime"]
		items_spawned = contents_to_save["items_spawned"]
		current_interval_index = contents_to_save["current_interval_index"]
	else:
		first_start = true
		print("Created save data")
		saveData()

func change_save_interval(index:int=9999):
	if index == 9999:
		current_interval_index = (current_interval_index + 1) % len(possible_save_times)
	else:
		current_interval_index = index
	
	if str(possible_save_times[current_interval_index]) == "Disabled":
		autosave_timer.stop()
	else:
		autosave_timer.wait_time = possible_save_times[current_interval_index]
		autosave_timer.stop()
		autosave_timer.start()

func _on_timer_timeout() -> void:
	saveData()

func _on_save_icon_timer_timeout() -> void:
	save_icon.hide()
