extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


const speed = 1000

func _physics_process(delta):
	var vel = speed * delta
	if Input.is_key_pressed(KEY_W):
		position.y -= vel
		
	if Input.is_key_pressed(KEY_S):
		position.y += vel
	
	if Input.is_key_pressed(KEY_A):
		position.x -= vel
	
	if Input.is_key_pressed(KEY_D):
		position.x += vel
		
		
	
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
		
