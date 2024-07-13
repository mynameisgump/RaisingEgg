extends CharacterBody3D
class_name BbEgg

#@export var base_movement_speed: float = 0.5;
@export var max_movement_speed: float = 5;
@export var added_accel: float = 0.05;
var current_movement_speed: float;
var movement_target_position: Vector3 = Vector3(-3.0,0.0,2.0)

# Timer to control footstep interval
var footstep_timer = 0.0
var footstep_interval = 0.35

@export var animation_speed_curve: Curve;
@export var egg_mesh: EggMesh;
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

# List of footstep sounds
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


# Reference to the AudioStreamPlayer3D node
@onready var audio_player := $AudioStreamPlayer3D

func _ready():
	current_movement_speed = 0;
	call_deferred("actor_setup")

func actor_setup():
	await get_tree().physics_frame
	set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector3):
	movement_target.y = position.y 
	look_at(movement_target);
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		velocity = Vector3(0,0,0);
		current_movement_speed = 0; 
		move_and_slide();
	else:
		var current_agent_position: Vector3 = global_position
		var next_path_position: Vector3 = navigation_agent.get_next_path_position()
		current_movement_speed += added_accel;
		var animation_speed = animation_speed_curve.sample(current_movement_speed/max_movement_speed);
		if not egg_mesh.animation_playing():
			egg_mesh.play_animation("Walkin",animation_speed);
		else:
			egg_mesh.set_animation_speed(animation_speed);
		if current_movement_speed > max_movement_speed:
			current_movement_speed = max_movement_speed;
		velocity = current_agent_position.direction_to(next_path_position) * current_movement_speed
		move_and_slide()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Check if the object is moving
	if current_movement_speed > 0:
		# Update the footstep timer
		footstep_timer -= delta
		if footstep_timer <= 0:
			# Play a random footstep sound
			play_random_footstep()
 			# Reset the timer
			footstep_timer = footstep_interval
	else:
		# Stop the sound if the object is not moving
		if audio_player != null:
			audio_player.stop()

func play_random_footstep():
	# Select a random footstep sound
	var random_sound = footstep_sounds[randi() % footstep_sounds.size()]
	if audio_player != null:
		audio_player.stream = random_sound
		audio_player.play()
