extends Node3D


@export var spawning_enemies = false;

@onready var bb_egg := $bb_egg
#@onready var player := $Player
@onready var player := $PlayerFlat
signal bb_egg_location(location: Vector3)
# Called when the node enters the scene tree for the first time.
@onready var spawn_timer := $SpawnTimer
@onready var evil_egg = preload("res://scenes/evil_egg.tscn");
@onready var enemies = $Enemies

@onready var track_1 = $AudioStreamPlayer;
@onready var animation_player = $AnimationPlayer;

var egg_being_eaten = false;
signal egg_eaten;
signal egg_dropped;

var wave_total = 5;
var enemies_left = 5;
@onready var environment := $WorldEnvironment;
@onready var wave_timer = $WaveTimer;
var first_wave = true;
var enemies_alive = 0;
var max_speed_diff = 1.5

func _ready():
	#track_1.playing = true;
	if spawning_enemies == false:
		animation_player.play("StartingWave")
		#animation_player.queue("LowerFog")
	pass # Replace with function body.


func begin():
	if first_wave:
		spawning_enemies = true;
		first_wave = false
	else:
		spawning_enemies = true;
		max_speed_diff *= 1.5
		wave_total *= 2
		enemies_left = wave_total
		spawn_timer.wait_time *= 0.9
		environment.environment.volumetric_fog_density *= 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var camera_pos = player.get_camera_position();
	enemies_alive = enemies.get_child_count();
	camera_pos.y = 0;
	bb_egg.set_movement_target(camera_pos);
	bb_egg_location.emit(bb_egg.position);
	
	if enemies_left <= 0 and enemies_alive <= 0 and wave_timer.is_stopped():
		spawning_enemies = false
		wave_timer.start();
		animation_player.play("NewWave");
	#if wave_timer.is_stopped() and spawning_enemies == false:
		#animation_player.play("NewWave")
		
	if spawn_timer.is_stopped() and enemies_left > 0 and egg_being_eaten == false and spawning_enemies == true:
		enemies_left -= 1;
		spawn_timer.start()
		spawn_random_enemy()


func spawn_random_enemy():
	var angle = randf()*PI*2;
	var x = cos(angle)*50;
	var z = sin(angle)*50;
	var y = 0.943
	var new_enemy = evil_egg.instantiate();
	enemies.add_child(new_enemy)
	new_enemy.randomize_speed(max_speed_diff)
	new_enemy.position = Vector3(x,y,z);
	new_enemy.connect("drop_egg", bb_egg._on_evil_egg_drop_egg);
	new_enemy.connect("eat_egg", bb_egg._on_evil_egg_eat_egg);
	
	egg_eaten.connect(new_enemy._on_someone_eat_egg)
	egg_dropped.connect(new_enemy._on_someone_drop_egg)
	
	bb_egg_location.connect(new_enemy._on_main_bb_egg_location)


func _on_bb_egg_eaten_signal():
	egg_being_eaten = true
	egg_eaten.emit()
	pass # Replace with function body.


func _on_bb_egg_dropped_signal():
	egg_being_eaten = false
	egg_dropped.emit()
	pass # Replace with function body.
