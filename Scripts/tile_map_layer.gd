extends TileMapLayer

var seed = 3
@onready var background = $ParallaxBackground/ParallaxLayer/Background
var map: Array[Array]

func weight(h, h_min, h_max, smooth):
	# Weighting function for 1D depth based generation

	# Strictly within boundaries 
	# See graph using Desmos: \left(\frac{-\left(\left(x-a\right)-\left(b-a\right)\right)^{c}+\left(b-a\right)^{c}}{\left(b-a\right)^{c}}\right)
	#return (- ((h - h_min) - ((h_max - h_min)/2)) ** smooth + ((h_max - h_min)/2) ** smooth) / (((h_max - h_min)/2) ** smooth)
	
	# With leakage 
	# See graph e^{-\left(\frac{\left(x-a\right)-\frac{\left(b-a\right)}{2}}{c}\right)^{2}}
	return exp(-((((h - h_min) - (h_max - h_min)/2)/smooth) ** 2))

func generate_noise(noise_type, fractal_octaves, frequency):
	var noise = FastNoiseLite.new()
	noise.seed = seed + randi()
	noise.noise_type = noise_type
	noise.fractal_octaves = fractal_octaves
	noise.frequency = frequency
	
	return noise
	

func generate_noise_map(map):
	# Generate noises per ore
	var iron_ore_noise = generate_noise(5, 3, 0.2)
	var gold_ore_noise = generate_noise(5, 3, 0.05)
	var cave_noise = generate_noise(5, 2, 0.08)
	
	# Force float calculations of weight
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
			if cave_noise.get_noise_2d(i, j)  > .5 and j > 20:
				map[i][j] = 0
	return map
	 

# Called when the node enters the scene tree for the first time.
func _ready():
	
	for i in range(get_parent().map_width + 2):
		map.append([])
		for j in range(get_parent().map_height):
			map[i].append(1)
		
	map = generate_noise_map(map)
	
	# Cleaning function
	for i in range(len(map)):
		for j in range(len(map[0])):
			if i > 0 and i < len(map)-1 and j > 0 and j < len(map[0])-1:
				if map[i][j] != 1:
					if map[i-1][j] != map[i][j] and map[i+1][j] != map[i][j] and map[i][j-1] != map[i][j] and map[i][j+1] != map[i][j]:
						map[i][j] = 1
	
	# Main drawing cycle 
	for j in range(get_parent().map_height):
		for i in range(get_parent().map_width):
			if map[i][j] == 1:
				# Add variation to the ground
				if randf() > 0.5:
					set_cell(Vector2i(i, j), 0, Vector2i(9, 3), 0)
				else:
					set_cell(Vector2i(i, j), 0, Vector2i(1, 3), 0)
			elif map[i][j] == 2:
#				Draw iron
				set_cell(Vector2i(i, j), 0, Vector2i(17, 3), 0)
			elif map[i][j] == 3:
#				Draw gold
				set_cell(Vector2i(i, j), 0, Vector2i(25, 3), 0)
				
			# Generate backgroud using LEPR
			if (get_parent().map_height - float(j))/get_parent().map_height > randf() ** 3:
#				Regular stone
				background.set_cell(Vector2i(i, j), 0, Vector2i(15, 1), 0)
			else:
#				Depth stone
				background.set_cell(Vector2i(i, j), 0, Vector2i(9, 1), 0)
		
#		Generate level walls
		set_cell(Vector2i(-1, j), 1, Vector2i(9, 3), 0)
		set_cell(Vector2i(get_parent().map_width, j), 1, Vector2i(9, 3), 0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	if Input.is_key_pressed(KEY_1):
			for i in range(get_parent().map_width):
				map[i][0] = 0
				if i > 10 and i < 50:
					set_cell(Vector2i(i, -1), 0, Vector2i(0, 1), 0)
					set_cell(Vector2i(i, -2), 0, Vector2i(0, 1), 0)
				set_cell(Vector2i(i, 0), 0, Vector2i(0, 1), 0)
	
