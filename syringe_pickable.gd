extends XRToolsPickable

@onready var LiquidMat: ShaderMaterial = $syringe/LiquidCenter.get_surface_override_material(0);

var fill_amount: float = 0;
var held = false;

# Variables to store previous states
var prev_position = Vector3()
var prev_velocity = Vector3()
var prev_accelerations: Array = []
var max_accel_history = 20  # Number of frames to keep track of accelerations
var acceleration_threshold = 8.0  # Adjust this value based on your needs
var shake_count_threshold = 5  # Minimum count of significant shakes to consider it a shake

# Timers:
@onready var shaker_tick_timer = $ShakeTickTimer;
@onready var shake_end_timer = $EndShakeTimer;
@onready var shake_audio = $AudioStreamPlayer3D;

func _ready() -> void:
	super._ready();
	print(LiquidMat)
	prev_position = global_transform.origin

func _process(delta):
	LiquidMat.set_shader_parameter("fill_amount", fill_amount)
	if shake_end_timer.is_stopped():
		shake_audio.stop();
	if held:
		var current_position = global_transform.origin

		# Calculate velocity
		var velocity = (current_position - prev_position) / delta

		# Calculate acceleration
		var acceleration = (velocity - prev_velocity) / delta

		# Store acceleration in history
		prev_accelerations.append(acceleration.length())
		if prev_accelerations.size() > max_accel_history:
			prev_accelerations.pop_at(0)

		# Detect shakes
		if detect_shake():
			_on_shake_detected()

		# Update previous states
		prev_position = current_position
		prev_velocity = velocity

func detect_shake() -> bool:
	var shake_count = 0
	for accel in prev_accelerations:
		if accel > acceleration_threshold:
			shake_count += 1

	return shake_count > shake_count_threshold

func _on_shake_detected():
	# Handle the shake event (e.g., play sound, particle effects, etc.)
	shake_end_timer.start();
	if shake_audio.playing == false:
		shake_audio.play();
	if shaker_tick_timer.is_stopped():
		shaker_tick_timer.start()
		fill_amount += 0.01
	

# Called when the node enters the scene tree for the first time.
func _inject() -> void:
	print("Injecting")

func _on_action_pressed(pickable) -> void:
	print("Injectin")

func _on_picked_up(pickable):
	held = true

func _on_dropped(pickable):
	held = false;
