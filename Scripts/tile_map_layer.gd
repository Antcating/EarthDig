extends TileMapLayer
var map_height = 480
var map_width = 640

# Called when the node enters the scene tree for the first time.
func _ready():
	var texture = NoiseTexture2D.new()
	texture.width = map_width
	texture.height = map_height
	var noise = FastNoiseLite.new()
	noise.seed = 12345
	noise.noise_type = 3
	noise.frequency = 0.07
	
	texture.noise = noise
	await texture.changed
	
	$Sprite2D.texture = texture
	
	for i in range(72):
		for j in range(3):
			set_cell(Vector2i(i, j), 0, Vector2i(15, 7), 0)
	
	for i in range(map_width):
		for j in range(3, map_height):
			if noise.get_noise_2d(i, j) > 0.33:
				set_cell(Vector2i(i, j), 0, Vector2i(18, 7), 0)
			else:
				set_cell(Vector2i(i, j), 0, Vector2i(15, 7), 0)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
