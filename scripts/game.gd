extends Node2D
@onready var game_floor: StaticBody2D = $boundaries

func get_taskbar_height():
	return DisplayServer.screen_get_size().y - DisplayServer.screen_get_usable_rect().size.y

func _ready():
	game_floor.position.y = 1090 - get_taskbar_height() #idek why 1090, magic number i suppose :P










#func _ready() -> void:
	#get_window().mouse_passthrough = false
	#set_passthrough()
	#
#func set_passthrough(sprite: Sprite2D):
	#var texture_center: Vector2 = sprite.texture.get_size() / 2 # Center
	#var texture_corners: PackedVector2Array = [
		#sprite.global_position + texture_center * Vector2(-1, -1), # Top left corner
		#sprite.global_position + texture_center * Vector2(1, -1), # Top right corner
		#sprite.global_position + texture_center * Vector2(1 , 1), # Bottom right corner
		#sprite.global_position + texture_center * Vector2(-1 ,1) # Bottom left corner
	#]
#
	#DisplayServer.window_set_mouse_passthrough(texture_corners)
#






# fuhadiushifuashfiouashfioudshfioshfoihfiahsoiufshaoiufhdsiuhiusahfuishfiudshiufhadsiu
# fuhadiushifuashfiouashfioudshfioshfoihfiahsoiufshaoiufhdsiuhiusahfuishfiudshiufhadsiu
# fuhadiushifuashfiouashfioudshfioshfoihfiahsoiufshaoiufhdsiuhiusahfuishfiudshiufhadsiu
# fuhadiushifuashfiouashfioudshfioshfoihfiahsoiufshaoiufhdsiuhiusahfuishfiudshiufhadsiu
# fuhadiushifuashfiouashfioudshfioshfoihfiahsoiufshaoiufhdsiuhiusahfuishfiudshiufhadsiu
# fuhadiushifuashfiouashfioudshfioshfoihfiahsoiufshaoiufhdsiuhiusahfuishfiudshiufhadsiu
# fuhadiushifuashfiouashfioudshfioshfoihfiahsoiufshaoiufhdsiuhiusahfuishfiudshiufhadsiu
# fuhadiushifuashfiouashfioudshfioshfoihfiahsoiufshaoiufhdsiuhiusahfuishfiudshiufhadsiu
# fuhadiushifuashfiouashfioudshfioshfoihfiahsoiufshaoiufhdsiuhiusahfuishfiudshiufhadsiu
# fuhadiushifuashfiouashfioudshfioshfoihfiahsoiufshaoiufhdsiuhiusahfuishfiudshiufhadsiu
# fuhadiushifuashfiouashfioudshfioshfoihfiahsoiufshaoiufhdsiuhiusahfuishfiudshiufhadsiu
# fuhadiushifuashfiouashfioudshfioshfoihfiahsoiufshaoiufhdsiuhiusahfuishfiudshiufhadsiu
# fuhadiushifuashfiouashfioudshfioshfoihfiahsoiufshaoiufhdsiuhiusahfuishfiudshiufhadsiu
# fuhadiushifuashfiouashfioudshfioshfoihfiahsoiufshaoiufhdsiuhiusahfuishfiudshiufhadsiu
