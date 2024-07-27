extends CharacterBody3D
class_name BbEgg

#@export var base_movement_speed: float = 0.5;
#@export var max_movement_speed: float = 5;
@export var max_movement_speed: float = 3;
@export var added_accel: float = 0.05;
var current_movement_speed: float;
var movement_target_position: Vector3 = Vector3(-3.0,0.0,2.0)

@export var animation_speed_curve: Curve;
@export var egg_mesh: EggMesh;
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

var being_eaten = false;

func _ready():
	current_movement_speed = 0;
	call_deferred("actor_setup")

func dropped(drop_position: Vector3) -> void:
	print("Droppp ed")
	being_eaten = false
	egg_mesh.visible = true
	position.x = drop_position.x
	position.z = drop_position.z
	
func eated():
	egg_mesh.visible = false;
	being_eaten = true;
	
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
		egg_mesh.reset_animations();
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


func _on_evil_egg_drop_egg(pos: Vector3) -> void:
	print("Dropping egg")
	dropped(pos);


func _on_evil_egg_eat_egg() -> void:
	eated()
