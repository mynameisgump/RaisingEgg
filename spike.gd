extends RigidBody3D

var shoot = false;

const DAMAGE = 50;
const SPEED = 0.5;

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true);

func _on_body_entered(body):
	print("SPIKE HIT");
	if body.is_in_group("Enemy"):
		body.health -= DAMAGE
		queue_free()
	else:
		queue_free()


func _on_lifetime_timeout():
	queue_free();
