extends Node3D


@onready var bb_egg := $bb_egg
#@onready var player := $Player
@onready var player := $PlayerFlat
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var camera_pos = player.get_camera_position();
	camera_pos.y = 0;
	bb_egg.set_movement_target(camera_pos);
	pass