extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	set_visibility_layer(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("show_debug"):
		set_visibility_layer(!get_visibility_layer())
	if get_visibility_layer():
		set_text("FPS %d" % Engine.get_frames_per_second())
