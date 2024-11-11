extends CharacterBody2D

@onready var tile_map_layer: TileMapLayer = $"../TileMapLayer"

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

func block_place(tilepos):
	#print("Block place")
	tile_map_layer.set_cell(tilepos, 0, Vector2i(9, 3), 0)

func block_break(tilepos):
	#print("Block break")
	#print(tile_map_layer.get_cell_tile_data(tilepos))
	tile_map_layer.erase_cell(tilepos)

func _input(event):
	if event is InputEventMouseButton and event.pressed :
		if event.button_index == MOUSE_BUTTON_LEFT:
			block_break($Camera2D2.tile_pos)
		elif event.button_index == MOUSE_BUTTON_RIGHT and tile_map_layer.get_cell_tile_data($Camera2D2.tile_pos) == null:
			block_place($Camera2D2.tile_pos)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
