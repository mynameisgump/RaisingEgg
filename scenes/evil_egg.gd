extends CharacterBody3D
class_name EvilEgg

#@export var base_movement_speed: float = 0.5;
@export var max_movement_speed: float = 10;
@export var added_accel: float = 0.05;
var current_movement_speed: float;
@export var movement_multiplier: float = 20;
var movement_target_position: Vector3 = Vector3(-3.0,0.0,2.0)

@export var animation_speed_curve: Curve;
#@export var egg_mesh: EggMesh;
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player := $AnimationPlayer;

var scuttle = false

func _ready():
	current_movement_speed = 0;
	call_deferred("actor_setup")
	animation_player.play("Runnin")

func actor_setup():
	await get_tree().physics_frame
	set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector3):
	movement_target.y = position.y 
	look_at(movement_target);
	navigation_agent.set_target_position(movement_target)

func start_scuttle():
	scuttle = true
	pass

func disable_scuttle():
	scuttle = false
	pass

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		velocity = Vector3(0,0,0);
		current_movement_speed = 0; 
		#egg_mesh.reset_animations();
		move_and_slide();
	else:
		if scuttle == true:
			print("SCUTTLIN")
			var current_agent_position: Vector3 = global_position
			var next_path_position: Vector3 = navigation_agent.get_next_path_position()
			current_movement_speed += added_accel;
			var animation_speed = animation_speed_curve.sample(current_movement_speed/max_movement_speed);
			if current_movement_speed > max_movement_speed:
				current_movement_speed = max_movement_speed;
			velocity = current_agent_position.direction_to(next_path_position) * movement_multiplier
			move_and_slide()


func _on_main_bb_egg_location(location):
	set_movement_target(location)
	pass # Replace with function body.
