extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

signal player_death;
@onready var body = $Body;
@onready var animation_player := $AnimationPlayer
@onready var animation_player_syringe := $SyringeShaker
@onready var shake_sound := $ShakeSound
@onready var syringe := $Body/FlatSyringe
var injecting = false;
var syringe_pos = "right"

@onready var projectile_egg = preload("res://scenes/ProjectileEgg.tscn");
@onready var ThrowPoint = $Body/Camera3D/ThrowPoint
var egg_speed = 20;

@onready var hand_egg = $Body/RightHand/ThrowableEgg
@onready var egg_reload_timer: Timer = $EggReloadTimer

var holding_egg = false;

func get_camera_position():
	return position

func throw_that_egg():
	var new_egg = projectile_egg.instantiate();
	add_child(new_egg);
	var new_mat = hand_egg.get_egg_mat().duplicate()
	new_egg.set_egg_mat(new_mat);
	new_egg.transform = ThrowPoint.global_transform;
	new_egg.linear_velocity = -new_egg.transform.basis.z*egg_speed;

func _process(delta):
	if holding_egg == false and egg_reload_timer.is_stopped():
		holding_egg = true
		animation_player.play("ReloadEgg")
		pass
func _physics_process(delta: float) -> void:
	
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta
	

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("inject"):
		animation_player.play("InjectEgg");
		injecting = true
	
	if Input.is_action_just_pressed("throw egg") and holding_egg == true:
		animation_player.play("ThrowEgg");
		egg_reload_timer.start();
		holding_egg = false
		
	
	if Input.is_action_just_pressed("shake_left") and injecting == false and syringe_pos == "right" and not (animation_player.is_playing() and animation_player.current_animation == "ReloadEgg"):
		syringe_pos="left"
		animation_player.play("ShakeLeft");
		shake_sound.play()
		syringe.shake()
		
	
	if Input.is_action_just_pressed("shake_right") and injecting == false and syringe_pos == "left" and not (animation_player.is_playing() and animation_player.current_animation == "ReloadEgg"):
		syringe_pos = "right"
		animation_player.play("ShakeRight");
		shake_sound.play()
		syringe.shake()

	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_flat_syringe_no_juice():
	animation_player.stop()

func _on_flat_syringe_finished_injection():
	injecting = false
	animation_player.play("FinishInjection")
