extends Node2D

const SURFACE_COLOR = Color(1, 1, 1, 1)
const DEPTH_COLOR = Color(0, 0, 0, 1)

@onready var canvas_modulate = $"CanvasModulate"
@onready var point_light = $"PointLight2D2"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	canvas_modulate.color = SURFACE_COLOR.lerp(DEPTH_COLOR, max(0, get_parent().position.y) / 16 / (get_parent().get_parent().map_height / 10))
	if get_parent().position.y  / 16 < 15:
		point_light.energy = lerp(0.0, 5.0, max(0, get_parent().position.y / 16) / 15)
	# else:

	# point_light.energy = lerp(0.0, 5.0, max(0, get_parent().position.y) / 16 / (get_parent().get_parent().map_height / 2))
	pass
