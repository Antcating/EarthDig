extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


const acc = 1000.0
var vel = Vector2(0.0, 0.0)

func _physics_process(delta):
	
	if Input.is_key_pressed(KEY_W):
		vel[1] -= acc * delta / zoom.x
		
	if Input.is_key_pressed(KEY_S):
		vel[1] += acc * delta / zoom.x
	
	if Input.is_key_pressed(KEY_A):
		vel[0] -= acc * delta / zoom.x
	
	if Input.is_key_pressed(KEY_D):
		vel[0] += acc * delta / zoom.x

	vel[0] -= 0.2 * vel[0]
	vel[1] -= 0.2 * vel[1]
	
	position.x += vel[0]
	position.y += vel[1]
		
	
func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if zoom.x < 1:
				zoom.x *= 1.5
				zoom.y *= 1.5
			else:
				zoom.x += 1
				zoom.y += 1
		
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if zoom.x <= 1:
				zoom.x /= 1.5
				zoom.y /= 1.5
			else:
				zoom.x -= 1
				zoom.y -= 1
		
		if event.button_index == MOUSE_BUTTON_XBUTTON1:
			zoom.x = 1
			zoom.y = 1
		
		if event.button_index == MOUSE_BUTTON_XBUTTON2:
			zoom.x = 4
			zoom.y = 4
		
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# Get the mouse position in screen coordinates
			var mouse_pos = get_viewport().get_mouse_position()
			print(mouse_pos)
