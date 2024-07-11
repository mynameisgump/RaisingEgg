extends Node3D
class_name EggMesh
@export var animation_player: AnimationPlayer;

func _ready():
	pass # Replace with function body.

func set_animation_speed(animationSpeed: float):
	animation_player.speed_scale = animationSpeed;

func play_animation(animationName: String, animationSpeed: float):
	animation_player.speed_scale = animationSpeed;
	animation_player.play(animationName);

func _process(delta):
	pass
