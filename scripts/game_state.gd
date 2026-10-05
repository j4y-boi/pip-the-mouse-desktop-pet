extends Node

@onready var game_floor: StaticBody2D = $"../game/boundaries"

var time_alive = 0
var times_restarted = 0
var total_playtime = 0
var times_fed = 0

func _ready() -> void:
	if get_tree().current_scene.name == "game":
		game_floor.position.y = 1090 - get_taskbar_height() #idek why 1090, magic number i suppose :P

func get_taskbar_height():
	return DisplayServer.screen_get_size().y - DisplayServer.screen_get_usable_rect().size.y
