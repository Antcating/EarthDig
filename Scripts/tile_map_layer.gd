extends TileMapLayer

var generation_seed = 3
@onready var background = $ParallaxBackground/ParallaxLayer/Background
@onready var dev_camera = $"DevCamera"
var map: Array[Array]
var prev_chunk_pos

# Weighting function for 1D depth based generation
func weight(h, h_min, h_max, smooth):
	# Weighting function for 1D depth based generation

	# Strictly within boundaries 
	# See graph using Desmos: \left(\frac{-\left(\left(x-a\right)-\left(b-a\right)\right)^{c}+\left(b-a\right)^{c}}{\left(b-a\right)^{c}}\right)
	#return (- ((h - h_min) - ((h_max - h_min)/2)) ** smooth + ((h_max - h_min)/2) ** smooth) / (((h_max - h_min)/2) ** smooth)
	
	# With leakage 
	# See graph e^{-\left(\frac{\left(x-a\right)-\frac{\left(b-a\right)}{2}}{c}\right)^{2}}
	return exp(-((((h - h_min) - (h_max - h_min)/2)/smooth) ** 2))

# Generate noise with given parameters
func generate_noise(noise_type, fractal_octaves, frequency):
	var noise = FastNoiseLite.new()
	noise.seed = generation_seed + randi()
	noise.noise_type = noise_type
	noise.fractal_octaves = fractal_octaves
	noise.frequency = frequency
	return noise

# Generate noise map for ores and caves
func generate_noise_map():
	var iron_ore_noise = generate_noise(5, 3, 0.2)
	var gold_ore_noise = generate_noise(5, 3, 0.05)
	var cave_noise = generate_noise(5, 2, 0.08)
	
	var h_min_iron = float(3.0)
	var h_min_gold = float(get_parent().map_height/2)
	var h_max_iron = float(get_parent().map_height/2)
	var h_max_gold = float(get_parent().map_height)
	
	for i in range(get_parent().map_width):
		for j in range(get_parent().map_height):
			if iron_ore_noise.get_noise_2d(i, j) * weight(j, h_min_iron, h_max_iron, 250) > 0.33 and map[i][j] == 1:
				map[i][j] = 2
			elif gold_ore_noise.get_noise_2d(i, j) * weight(j, h_min_gold, h_max_gold, 250) > 0.33 and map[i][j] == 1:
				map[i][j] = 3
			if cave_noise.get_noise_2d(i, j) > .5 and j > 20:
				map[i][j] = 0
	return map

# Initialize the map with default values
func initialize_map():
	for i in range(get_parent().map_width + 2):
		map.append([])
		for j in range(get_parent().map_height):
			map[i].append(1)

# Draw the map based on the current chunk position
func draw_map(chunk_pos):
	for j in range(get_parent().map_height):
		for i in range(get_parent().map_width):
			if map[i][j] == 1:
				if randf() > 0.5:
					set_cell(Vector2i(i, j), 0, Vector2i(9, 3), 0)
				else:
					set_cell(Vector2i(i, j), 0, Vector2i(1, 3), 0)
			elif map[i][j] == 2:
				set_cell(Vector2i(i, j), 0, Vector2i(17, 3), 0)
			elif map[i][j] == 3:
				set_cell(Vector2i(i, j), 0, Vector2i(25, 3), 0)
			if (get_parent().map_height - float(j))/get_parent().map_height > randf() ** 3:
				background.set_cell(Vector2i(i, j), 0, Vector2i(15, 1), 0)
			else:
				background.set_cell(Vector2i(i, j), 0, Vector2i(9, 1), 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_map()
	map = generate_noise_map()
	draw_map(prev_chunk_pos)

# Process function to handle updates
func _process(delta):
	pass