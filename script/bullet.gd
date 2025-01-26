extends Area3D

const BULLET_SPEED = 100.0
var lifetime = 20.0
var hits_remaining := 2
var direction := Vector3.FORWARD

func _ready():
	add_to_group("bullets")
	# Start movement and lifetime timer
	var timer = get_tree().create_timer(lifetime)
	timer.timeout.connect(queue_free)
	
func _physics_process(delta):
	# Move bullet forward manually
	global_translate(direction * BULLET_SPEED * delta)
