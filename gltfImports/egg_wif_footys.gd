extends Node3D
class_name EggMesh

@export var min_pitch: float = 0.9;
@export var max_pitch: float = 1.1;
@onready var animation_player := $AnimationPlayer;
@onready var footstep_player := $AudioStreamPlayer3D;



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

func set_animation_speed(animationSpeed: float) -> void:
	animation_player.speed_scale = animationSpeed;

func animation_playing() -> bool:
	return animation_player.is_playing();

func reset_animations() -> void:
	animation_player.play("RESET");

func play_animation(animationName: String, animationSpeed: float):
	animation_player.speed_scale = animationSpeed;
	animation_player.play(animationName);

func stop_animation():
	animation_player.stop();

func set_random_footstep() -> void:
	var random_sound = footstep_sounds[randi() % footstep_sounds.size()];
	if footstep_player != null:
		footstep_player.stream = random_sound;
		footstep_player.pitch_scale = randf_range(min_pitch, max_pitch);;
		
func play_walking_animation():
	animation_player.play("Walkin");

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Walkin":
		set_random_footstep();
		play_walking_animation();
	

