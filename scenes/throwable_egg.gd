extends Node3D

@export var curve: Curve;
@onready var animation_tree = $AnimationTree
var injection_amount = 0;
var r_total = 0;
var g_total = 0;
var b_total = 0;

@onready var egg_mat = $Sketchfab_Scene/Sketchfab_model/egg_fbx/RootNode/Sphere/Sphere_DefaultMaterial_0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	animation_tree.set("parameters/VeinsAmount/blend_amount", injection_amount);
	animation_tree.set("parameters/GreenAmount/add_amount", injection_amount);
	
	if injection_amount > 1:
		injection_amount = 1
	if r_total > 1:
		r_total = 1;
	if g_total > 1:
		g_total = 1;
	if b_total > 1:
		b_total = 1;

func injection_tick(type: String) -> void:
	injection_amount += 0.04 
	if type == "green":
		g_total += 0.04


func _on_flat_syringe_injection_tick(type: String):
	injection_tick(type)

func reset_egg_mat():
	print("???")
	injection_amount = 0.0
	g_total = 0.0
	animation_tree.set("parameters/VeinsAmount/blend_amount", 0.0);
	animation_tree.set("parameters/GreenAmount/add_amount", 0.0);

func get_egg_mat():
	return egg_mat.get_surface_override_material(0);
