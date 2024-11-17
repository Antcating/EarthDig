extends Node2D

# Graphics parameters
var tile_size = 16
# World parameters
var chunk_size = 32
var map_height = chunk_size * 20
var map_width = chunk_size * 5

@onready var tile_map : TileMapLayer = $MidLayer
# @onready var camera : Camera2D = $DevCamera

# Get the noise textures from the editor
@export var noise_iron: NoiseTexture2D
@export var noise_gold: NoiseTexture2D
@export var noise_cave: NoiseTexture2D
# Noises
var iron_noise : Noise
var gold_noise : Noise
var cave_noise : Noise
# Map of the world
var map: Array[Array]
# Flag to check if the map is updated with autotiles
var is_map_autotiled = false
# Paint dictionary to store the changes
var paints : Array[Dictionary]
# Number of vertical chunks to process at a time
var v_chunk_size = 5
# Graphics vertical chunk id (for painting) 
var v_chunk_id = 0
# Changeset
var change 

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
func calculate_map():
	var h_min_iron = 3.0
	var h_min_gold: int = map_height/2
	var h_max_iron: int = map_height/2
	var h_max_gold: int = map_height

	var is_specific_block : bool = false
	var curr_v_chunk : int = -1
	for y in range(map_height):
		for x in range(map_width):
			# Split the map in chunks of 5 vertical chunks (for painting)
			if (y / chunk_size) / v_chunk_size != curr_v_chunk:
				paints.append({})
				curr_v_chunk = (y / chunk_size) / v_chunk_size
			while not is_specific_block:
				if iron_noise.get_noise_2d(x, y) * weight(y, h_min_iron, h_max_iron, 250) > 0.5:
					map[x][y] = 2
					BetterTerrain.set_cell(tile_map, Vector2i(x, y), 2)
					paints[curr_v_chunk][Vector2i(x, y)] = 2
					is_specific_block = true

				if gold_noise.get_noise_2d(x, y) * weight(y, h_min_gold, h_max_gold, 250) > 0.3:
					map[x][y] = 3
					BetterTerrain.set_cell(tile_map, Vector2i(x, y), 3)
					paints[curr_v_chunk][Vector2i(x, y)] = 3
					is_specific_block = true

				if cave_noise.get_noise_2d(x, y) > 0.6:
					map[x][y] = 0
					BetterTerrain.set_cell(tile_map, Vector2i(x, y), -1)
					paints[curr_v_chunk][Vector2i(x, y)] = -1
					is_specific_block = true

				if not is_specific_block:
					map[x][y] = 1
					BetterTerrain.set_cell(tile_map, Vector2i(x, y), 1)
					paints[curr_v_chunk][Vector2i(x, y)] = 1
					is_specific_block = true
			is_specific_block = false

func _ready():
	# Initialize noise textures
	iron_noise = noise_iron.noise
	cave_noise = noise_cave.noise
	gold_noise = noise_gold.noise
	# Initialize empty arrays
	initialize_map()
	# Fill the map, graphics and paint dictionary
	calculate_map()
	change = BetterTerrain.create_terrain_changeset(tile_map, paints[v_chunk_id])
# Process function to handle updates
func _process(delta):
	# Check if the map is autotiled
	if not is_map_autotiled and BetterTerrain.is_terrain_changeset_ready(change):
		print("Applying changeset")
		BetterTerrain.apply_terrain_changeset(change)
		v_chunk_id += 1
		# Check if there are more vertical chunks to process
		if v_chunk_id < paints.size():
			change = BetterTerrain.create_terrain_changeset(tile_map, paints[v_chunk_id])
		else:
			is_map_autotiled = true
			print("Map autotiled successfully")
		
	pass 