extends Node3D
class_name EggMesh
@export var animation_player: AnimationPlayer;
@onready var footstep_player: AudioStreamPlayer3D = $AudioStreamPlayer3D;



var footstep_sounds = [
	preload("res://assets/Sounds/bbegg/footsteps/bbeg_footstep_1.wav"),
	preload("res://assets/Sounds/bbegg/footsteps/bbeg_footstep_2.wav"),
	preload("res://assets/Sounds/bbegg/footsteps/bbeg_footstep_3.wav"),
	preload("res://assets/Sounds/bbegg/footsteps/bbeg_footstep_4.wav"),
	preload("res://assets/Sounds/bbegg/footsteps/bbeg_footstep_5.wav"),
	preload("res://assets/Sounds/bbegg/footsteps/bbeg_footstep_6.wav"),
	preload("res://assets/Sounds/bbegg/footsteps/bbeg_footstep_7.wav"),
	preload("res://assets/Sounds/bbegg/footsteps/bbeg_footstep_8.wav")
]



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

func set_random_footstep():
	var random_sound = footstep_sounds[randi() % footstep_sounds.size()]
	if footstep_player != null:
		footstep_player.stream = random_sound
		
func play_walking_animation():
	animation_player.play("Walkin")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print("Animation player Finished")
	set_random_footstep();
	play_walking_animation();

func _on_animation_player_animation_started(anim_name: StringName) -> void:
	print("Why :()")
	pass # Replace with function body.
