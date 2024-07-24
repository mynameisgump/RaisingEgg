extends XRToolsPickable

@onready var LiquidMat: ShaderMaterial = $syringe/LiquidCenter.get_surface_override_material(0);

var fill_amount: float = 0;
var held = false;

# Variables to store previous states
var prev_position = Vector3()
var prev_velocity = Vector3()
var prev_accelerations := [];
var prev_positions := []
var max_history = 20  # Number of frames to keep track of history
var acceleration_threshold = 10.0  # Adjust this value based on your needs
var position_change_threshold = 0.01  # Adjust based on needs
var shake_count_threshold = 15  # Minimum count of significant shakes to consider it a shake

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
		prev_positions.append((current_position - prev_position).length())
		
		if prev_accelerations.size() > max_history:
			prev_accelerations.pop_at(0)
			
		if prev_positions.size() > max_history:
			prev_positions.pop_at(0)
