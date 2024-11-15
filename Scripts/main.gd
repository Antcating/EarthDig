extends Node2D

var chunk_size = 32
var tile_size = 16
var map_height = chunk_size * 20
var map_width = chunk_size * 5

@onready var tile_map : TileMapLayer = $MidLayer
@onready var camera : Camera2D = $DevCamera

@export var noise_iron: NoiseTexture2D
@export var noise_gold: NoiseTexture2D
@export var noise_cave: NoiseTexture2D
var iron_noise : Noise
var gold_noise : Noise
var cave_noise : Noise
# @onready var background = $ParallaxBackground/ParallaxLayer/Background
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

# Initialize the map with default values
func initialize_map():
	print("Initializing map")
	for i in range(map_width + 2):
		map.append([])
		for j in range(map_height):
			map[i].append(1)

# Draw the map based on the current chunk position
func draw_map():
	var h_min_iron = 3.0
	var h_min_gold: int = map_height/2
	var h_max_iron: int = map_height/2
	var h_max_gold: int = map_height

	var is_specific_block : bool = false
	for x in range(map_width):
		for y in range(map_height):
			while not is_specific_block:
				if iron_noise.get_noise_2d(x, y) * weight(y, h_min_iron, h_max_iron, 250) > 0.5:
					map[x][y] = 2
					BetterTerrain.set_cell(tile_map, Vector2i(x, y), 2)
					is_specific_block = true

				if gold_noise.get_noise_2d(x, y) * weight(y, h_min_gold, h_max_gold, 250) > 0.3:
					map[x][y] = 3
					BetterTerrain.set_cell(tile_map, Vector2i(x, y), 3)
					is_specific_block = true

				if cave_noise.get_noise_2d(x, y) > 0.6:
					map[x][y] = 0
					BetterTerrain.set_cell(tile_map, Vector2i(x, y), -1)
					is_specific_block = true

				if not is_specific_block:
					map[x][y] = 1
					BetterTerrain.set_cell(tile_map, Vector2i(x, y), 1)
					is_specific_block = true

			is_specific_block = false

	BetterTerrain.update_terrain_area(tile_map, Rect2i(0, 0, map_width, map_height))
func _ready():
	iron_noise = noise_iron.noise
	cave_noise = noise_cave.noise
	gold_noise = noise_gold.noise
	initialize_map()
	draw_map()

# # Process function to handle updates
func _process(delta):
	if Input.is_key_pressed(KEY_1):
		var update_cells = []
		for j in range(10):
			for i in range(map_width):
				if i > 10 and i < 50:
					BetterTerrain.set_cell(tile_map, Vector2i(i, j), -1)
		
		BetterTerrain.update_terrain_area(tile_map, Rect2i(0, 0, map_width, 10))

	if Input.is_key_pressed(KEY_F9):
		# Reset the map
		initialize_map()
		draw_map()
