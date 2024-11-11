extends Camera2D

@onready var tile_map_layer = $"../../TileMapLayer"
@onready var highlighter = $"../../TileMapLayer/Highlighter"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var viewport_size = get_viewport().size / Vector2i(zoom)
	var camera_top_left = Vector2i(get_screen_center_position()) - viewport_size / 2
	var start_tile = tile_map_layer.local_to_map(camera_top_left)
	var end_tile = tile_map_layer.local_to_map(camera_top_left + viewport_size - Vector2i(2, 2))
	
	var mouse_pos = tile_map_layer.get_local_mouse_position()
	print(mouse_pos)
	var tile_pos = mouse_pos.ceil() / Vector2(16.0, 16.0)
	print(Vector2i(tile_pos))
	print(start_tile)
	print(end_tile)
	
	highlighter.clear()
	highlighter.set_cell(Vector2i(tile_pos.floor()), 0, Vector2i(0, 0), 0)
