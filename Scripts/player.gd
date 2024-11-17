extends CharacterBody2D

@onready var tile_map_layer: TileMapLayer = $"../MidLayer"

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

func block_place(tilepos):
	if $Camera2D2.in_range:
		print(tile_map_layer.get_cell_tile_data(tilepos))
		BetterTerrain.set_cell(tile_map_layer, tilepos, 1)
		BetterTerrain.update_terrain_cell(tile_map_layer, tilepos)

func block_break(tilepos):
	if $Camera2D2.in_range:
		BetterTerrain.set_cell(tile_map_layer, tilepos, -1)
		BetterTerrain.update_terrain_cell(tile_map_layer, tilepos)

var left_pressed = false
var right_pressed = false
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				left_pressed = true
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				right_pressed = true

		elif event.button_index == MOUSE_BUTTON_LEFT:
			left_pressed = false
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			right_pressed = false
			
	if left_pressed:
		block_break($Camera2D2.tile_pos)
	elif right_pressed:
		if tile_map_layer.get_cell_tile_data($Camera2D2.tile_pos) == null:
			block_place($Camera2D2.tile_pos)
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
