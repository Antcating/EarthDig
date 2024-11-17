extends Camera2D

var tile_pos = Vector2i(0, 0) #cursor position over the tilemap

@onready var tile_map_layer = $"../../TileMapLayer"
@onready var highlighter = $"../../TileMapLayer/Highlighter"


# Called when the node enters the scene tree for the first time.
func _ready():
	print(tile_map_layer.seed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#calculating cursor position and drawing tiles outline
	var viewport_size = get_viewport().size / Vector2i(zoom)
	var camera_top_left = Vector2i(get_screen_center_position()) - viewport_size / 2
	var start_tile = tile_map_layer.local_to_map(camera_top_left)
	var end_tile = tile_map_layer.local_to_map(camera_top_left + viewport_size - Vector2i(2, 2))
	
	var mouse_pos = tile_map_layer.get_local_mouse_position()
	tile_pos = mouse_pos.ceil() / Vector2(16.0, 16.0)
	tile_pos = Vector2i(tile_pos.floor())
	
	highlighter.clear()
	highlighter.set_cell(tile_pos, 0, Vector2i(0, 0), 0)
