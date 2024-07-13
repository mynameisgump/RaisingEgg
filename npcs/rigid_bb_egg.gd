extends RigidBody3D

@export var movement_speed: float = 1.0
@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")

func _ready() -> void:
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

func set_movement_target(movement_target: Vector3):
	#movement_target.y = position.y 
	#look_at(movement_target);
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return

	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	#print(next_path_position);
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_speed
	print(new_velocity)
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector3):
	linear_velocity = safe_velocity
