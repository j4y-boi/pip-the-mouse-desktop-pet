extends Node

@onready var game_floor: StaticBody2D = $"../game/boundaries"
@onready var save_icon: Sprite2D = $SaveIcon
@onready var save_icon_timer: Timer = $SaveIconTimer

var times_played = 0
var times_fed = 0
var total_playtime = 0
var items_spawned = 0

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
	"total_playtime" : 0,
	"items_spanwed" : 0,
}

func saveData():
	var file
	contents_to_save["times_fed"] = times_fed
	contents_to_save["times_played"] = times_played
	contents_to_save["total_playtime"] = total_playtime
	contents_to_save["items_spanwed"] = items_spawned
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
	total_playtime = 0
	items_spawned = 0
	$"../game/GUI"._on_clear_pressed()
	loadData()

func loadData():
	if FileAccess.file_exists(save_location):
		print("Loading save data")
		var file
		file = FileAccess.open_encrypted_with_pass(save_location, FileAccess.READ,"woahsecurity")
		file.close()
		
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
		items_spawned = contents_to_save["items_spanwed"]
	else:
		print("Created save data")
		saveData()

func _on_timer_timeout() -> void:
	saveData()

func _on_save_icon_timer_timeout() -> void:
	save_icon.hide()
