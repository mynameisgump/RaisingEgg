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
@onready var EatZone := $EatZone

var invincible = false;
var health = 100;

signal eat_egg();
signal drop_egg(pos: Vector3);

var scuttle = false
var holding_egg = false
var acidic = false
var someone_eating_egg = false;

func set_invincible():
	invincible = true;

func _on_someone_eat_egg():
	animation_player.play("Prayer")
	scuttle = false
	someone_eating_egg = true;
	pass
	
func _on_someone_drop_egg():
	someone_eating_egg = false;
	animation_player.play("RESET");
	animation_player.queue("Runnin");
	scuttle = true
	pass
	
func _ready():
	current_movement_speed = 0;
	call_deferred("actor_setup")
	animation_player.play("Runnin")

func acid_hit():
	if not invincible:
		scuttle = false;
		acidic = true;
		animation_player.play("Acidic")

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

func health_tick():
	health -= 5

func _process(delta: float) -> void:
	if holding_egg and acidic:
		print("Dropping egg in evil egg")
		drop_egg.emit(global_position);
		holding_egg = false
	if acidic:
		health -= 0.1;
	if health < 0:
		queue_free()
		
func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		velocity = Vector3(0,0,0);
		current_movement_speed = 0; 
		#egg_mesh.reset_animations();
		move_and_slide();
	else:
		if scuttle == true and not holding_egg:
			var current_agent_position: Vector3 = global_position
			var next_path_position: Vector3 = navigation_agent.get_next_path_position()
			current_movement_speed += added_accel;
			var animation_speed = animation_speed_curve.sample(current_movement_speed/max_movement_speed);
			if current_movement_speed > max_movement_speed:
				current_movement_speed = max_movement_speed;
			if acidic: 
				velocity = current_agent_position.direction_to(next_path_position) * movement_multiplier
			else:
							velocity = current_agent_position.direction_to(next_path_position) * movement_multiplier/2
			move_and_slide()


func _on_main_bb_egg_location(location):
	set_movement_target(location)
	pass # Replace with function body.


func _on_eat_zone_body_entered(body: Node3D) -> void:
	print("Body Entered: ", body)
	if body.is_in_group("bbegg") and not acidic:
		if body.being_eaten == false:
			eat_egg.emit()
			animation_player.play("EatEgg");
			animation_player.queue("Munchin")
			holding_egg = true

func crash_game():
	var a = null
	a.kill()
