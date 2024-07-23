extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

signal player_death;
@onready var body = $Body;
@onready var animation_player := $AnimationPlayer
@onready var shake_sound := $ShakeSound
@onready var syringe := $Body/FlatSyringe
var injecting = false;
var syringe_pos = "right"

func get_camera_position():
	return position

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
	
	if Input.is_action_just_pressed("shake_left") and injecting == false and syringe_pos == "right":
		syringe_pos="left"
		animation_player.play("ShakeLeft");
		shake_sound.play()
		syringe.shake()
		
	
	if Input.is_action_just_pressed("shake_right") and injecting == false and syringe_pos == "left":
		syringe_pos = "right"
		animation_player.play("ShakeRight");
		shake_sound.play()
		syringe.shake()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
	pass # Replace with function body.


func _on_flat_syringe_finished_injection():
	print("emmittted")
	injecting = false
	animation_player.play("FinishInjection")
