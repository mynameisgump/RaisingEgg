extends Node3D

const MOUSE_SENS : float = 3.0

@onready var character : CharacterBody3D = get_parent()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event : InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		rotation.x -= event.relative.y * MOUSE_SENS * 0.001
		rotation.x = clamp(rotation.x, -1.5, 1.5)
		#print(event.relative.x * MOUSE_SENS * 0.001)
		character.rotation.y -= event.relative.x * MOUSE_SENS * 0.001
		character.rotation.y = wrapf(character.rotation.y, 0.0, TAU)

