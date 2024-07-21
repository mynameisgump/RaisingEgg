extends Node3D

@onready var LiquidMat: ShaderMaterial = $syringe/LiquidCenter.get_surface_override_material(0);

var fill_amount: float = 1;
var held = false;
@export var injecting = false;
@export var shaking = false;
signal no_juice;

# Timers:
@onready var shaker_tick_timer = $ShakeTickTimer;
@onready var shake_end_timer = $EndShakeTimer;
@onready var shake_audio = $AudioStreamPlayer3D;
@onready var audio_syringe_use = $AudioSyringeUse;

@onready var animation_player := $AnimationPlayer
@onready var animation_tree := $AnimationTree

func _process(delta):
	animation_tree.set("parameters/Inject/blend_amount", fill_amount);
	
	if injecting and audio_syringe_use.playing == false:
		audio_syringe_use.playing = true;
	if injecting == false and audio_syringe_use.playing == true:
		audio_syringe_use.playing = false;
	
	if injecting:
		fill_amount -= 0.004;

	if fill_amount <= 0 and injecting == true:
		fill_amount = 0 
		no_juice.emit()
		injecting = false
	
	#if shaking == true:
		#fill_amount += 0.004
		#if audio_syringe_use.playing == false:
			#audio_syringe_use.play()
	#elif audio_syringe_use.playing == true:
		#audio_syringe_use.stop()
		#
func shake():
	fill_amount += 0.004

func _on_shake_detected():
	# Handle the shake event (e.g., play sound, particle effects, etc.)
	shake_end_timer.start();
	if shake_audio.playing == false:
		shake_audio.play();
	if shaker_tick_timer.is_stopped():
		shaker_tick_timer.start()
		fill_amount += 0.01

# Called when the node enters the scene tree for the first time.
#func _inject() -> void:
	#print("Injecting")
#
#func _on_action_pressed(pickable) -> void:
	#print("Injectin")