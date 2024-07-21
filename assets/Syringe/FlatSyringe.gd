extends Node3D

@onready var LiquidMat: ShaderMaterial = $syringe/LiquidCenter.get_surface_override_material(0);

var fill_amount: float = 1;
var held = false;
var injecting = false;

# Timers:
@onready var shaker_tick_timer = $ShakeTickTimer;
@onready var shake_end_timer = $EndShakeTimer;
@onready var shake_audio = $AudioStreamPlayer3D;

@onready var animation_player := $AnimationPlayer
@onready var animation_tree := $AnimationTree

func _process(delta):
	LiquidMat.set_shader_parameter("fill_amount", fill_amount)

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
