extends RigidBody3D

var shoot = false;

const DAMAGE = 50;
const SPEED = 0.5;

@export var curve: Curve;
var injection_amount = 0;
var r_total = 0;
var g_total = 0;
var b_total = 0;

@onready var egg_mesh = $Sketchfab_Scene/Sketchfab_model/egg_fbx/RootNode/Sphere/Sphere_DefaultMaterial_0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true);

func _on_body_entered(body):
	print("Body Entered")
	if body.is_in_group("Enemy"):
		body.health -= DAMAGE
		queue_free()
	#else:
		#queue_free()
func set_egg_mat(material: ShaderMaterial):
	egg_mesh.set_surface_override_material(0,material);
