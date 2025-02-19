extends RigidBody3D

var shoot = false;

const DAMAGE = 50;
const SPEED = 0.5;

@export var curve: Curve;
var injection_amount = 0;
var r_total = 0;
var g_total = 0;
var b_total = 0;

@onready var egg_mesh = $Sketchfab_Scene/Sketchfab_model/egg_fbx/RootNode/Sphere/Sphere_DefaultMaterial_0;
@onready var splat_sound := $SplatSound;

@onready var splat_particles := $GPUParticles3D;
@onready var decal := $Decal
@onready var animation_player = $AnimationPlayer
@onready var splash_zone = $Area3D

@export var power_curve: Curve;
var power_level = 1

func remove_splat():
	queue_free()
func _ready():
	set_as_top_level(true);

func set_egg_power(power: float) -> void:
	print("Setting Egg Power:", power)
	power_level = power_curve.sample(power);
	
func egg_explode():
	decal.set_as_top_level(true);
	splat_particles.set_as_top_level(true);
	splash_zone.set_as_top_level(true);
	decal.rotation = Vector3(0,0,0);
	splat_particles.rotation = Vector3(0,0,0);
	splash_zone.rotation = Vector3(0,0,0);
	
	decal.scale = Vector3(power_level,power_level,power_level)
	#splat_particles.scale = Vector3(power_level,power_level,power_level)
	splat_particles.amount = splat_particles.amount *power_level
	splash_zone.scale = Vector3(power_level,power_level,power_level)
	

func _on_body_entered(body):
	splat_sound.play();
	animation_player.play("Explode");
	if body.is_in_group("enemy"):
		body.health -= 10*power_level
	

func set_egg_mat(material: ShaderMaterial):
	egg_mesh.set_surface_override_material(0,material);


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("Hit:", body)
	if body.is_in_group("enemy"):
		body.acid_hit();
	
