extends CharacterBody3D
class_name Player

@onready var camera = $XROrigin3D/XRCamera3D
func _ready():
	pass
	
func get_camera_position():
	return camera.global_position
