extends Node3D


@onready var bb_egg := $bb_egg
#@onready var player := $Player
@onready var player := $PlayerFlat
signal bb_egg_location(location: Vector3)
# Called when the node enters the scene tree for the first time.
@onready var spawn_timer := $SpawnTimer
@onready var evil_egg = preload("res://scenes/evil_egg.tscn");
@onready var enemies = $Enemies

@onready var track_1 = $AudioStreamPlayer

var egg_being_eaten = false;
signal egg_eaten;
signal egg_dropped;

func _ready():
	track_1.playing = true;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var camera_pos = player.get_camera_position();
	camera_pos.y = 0;
	bb_egg.set_movement_target(camera_pos);
	bb_egg_location.emit(bb_egg.position);
	if spawn_timer.is_stopped() and egg_being_eaten == false:
		spawn_timer.start()
		spawn_random_enemy()


func spawn_random_enemy():
	var angle = randf()*PI*2;
	var x = cos(angle)*50;
	var z = sin(angle)*50;
	var y = 0.943
	var new_enemy = evil_egg.instantiate();
	enemies.add_child(new_enemy)
	new_enemy.position = Vector3(x,y,z);
	new_enemy.connect("drop_egg", bb_egg._on_evil_egg_drop_egg);
	new_enemy.connect("eat_egg", bb_egg._on_evil_egg_eat_egg);
	
	egg_eaten.connect(new_enemy._on_someone_eat_egg)
	
	bb_egg_location.connect(new_enemy._on_main_bb_egg_location)


func _on_bb_egg_eaten_signal():
	egg_being_eaten = true
	egg_eaten.emit()
	pass # Replace with function body.


func _on_bb_egg_dropped_signal():
	egg_being_eaten = false
	egg_dropped.emit()
	pass # Replace with function body.
