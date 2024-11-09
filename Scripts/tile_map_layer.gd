extends TileMapLayer
var map_height = 480
var map_width = 640

func weight(h, h_min, h_max, smooth):
	# Weighting function for 1D depth based generation

	# Strictly within boundaries 
	# See graph using Desmos: \left(\frac{-\left(\left(x-a\right)-\left(b-a\right)\right)^{c}+\left(b-a\right)^{c}}{\left(b-a\right)^{c}}\right)
	#return (- ((h - h_min) - ((h_max - h_min)/2)) ** smooth + ((h_max - h_min)/2) ** smooth) / (((h_max - h_min)/2) ** smooth)
	
	# With leakage 
	# See graph e^{-\left(\frac{\left(x-a\right)-\frac{\left(b-a\right)}{2}}{c}\right)^{2}}
	return exp(-((((h - h_min) - (h_max - h_min)/2)/smooth) ** 2))
# Called when the node enters the scene tree for the first time.
func _ready():
	#var texture = NoiseTexture2D.new()
	#texture.width = map_width
	#texture.height = map_height
	var noise = FastNoiseLite.new()
	noise.seed = 12345
	noise.noise_type = 1
	noise.fractal_octaves = 3
	noise.frequency = 0.02
	
	var map: Array[Array]
	for i in range(map_width):
		map.append([])
		for j in range(map_width):
			map[i].append(0)
	
	for i in range(map_width):
		for j in range(3, map_height/1.5):
			if noise.get_noise_2d(i, j) * weight(j, 3.0, map_height/1.5, 150) > 0.33:
				map[i][j] = 1
	 
	# Cleaning function
	for i in range(len(map)):
		for j in range(len(map[0])):
			if i > 0 and i < len(map)-1 and j > 0 and j < len(map[0])-1:
				if map[i][j] != 0:
					if map[i-1][j] == 0 and map[i+1][j] == 0 and map[i][j-1] == 0 and map[i][j+1] == 0:
						map[i][j] = 0
	
	# Main drawing cycle 
	for i in range(map_width):
		for j in range(map_height):
			if map[i][j] == 0:
				# Add variation to the ground
				if randf() > 0.5:
					set_cell(Vector2i(i, j), 0, Vector2i(9, 3), 0)
				else:
					set_cell(Vector2i(i, j), 0, Vector2i(1, 3), 0)
			elif map[i][j] == 1:
				set_cell(Vector2i(i, j), 0, Vector2i(25, 3), 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
