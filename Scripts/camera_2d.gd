extends Camera2D

@onready var rigid_body_2d = $RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


const speed = 1000

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if Input.is_key_pressed(KEY_W):
		#position.y -= 5
		#
	#elif Input.is_key_pressed(KEY_S):
		#rigid_body_2d.linear_velocity.x += 1
	#
	#elif Input.is_key_pressed(KEY_A):
		#position.x -= 5
	#
	#elif Input.is_key_pressed(KEY_D):
		#position.x += 5
		
func _physics_process(delta):
	var vel = speed * delta
	if Input.is_key_pressed(KEY_W):
		position.y -= vel
		
	elif Input.is_key_pressed(KEY_S):
		position.y += vel
	
	elif Input.is_key_pressed(KEY_A):
		position.x -= vel
	
	elif Input.is_key_pressed(KEY_D):
		position.x += vel
	
	
