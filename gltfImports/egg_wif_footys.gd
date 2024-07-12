extends Node3D
class_name EggMesh
@export var animation_player: AnimationPlayer;

func _ready():
	pass # Replace with function body.

func set_animation_speed(animationSpeed: float):
	animation_player.speed_scale = animationSpeed;

func animation_playing():
	return animation_player.is_playing()

func play_animation(animationName: String, animationSpeed: float):
	animation_player.speed_scale = animationSpeed;
	animation_player.play(animationName);

func stop_animation():
	animation_player.stop()

func _process(delta):
	pass
