extends RigidBody3D

@onready var mesh = $bub
@onready var area = $Area3D/CollisionShape3D

var rng = RandomNumberGenerator.new()
var size = 0.5
var bit2Mask = 1 << 2
var hits_remaining := 2

func _ready():
	add_to_group("bubbles")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mesh.scale = Vector3(size, size, size)
	area.shape.radius = size * 3

func _on_mouse_entered():
	size = size + 0.3

func _on_mouse_exited():
	size = size - 0.3

#func _on_area_3d_body_entered(body):
	#if body.is_in_group("bubbles"):
		#var t = rng.randi() % 4
		#if t == 0:
			#queue_free()
		#if t == 1:
			#size *= 1.5

func _on_area_3d_area_entered(area):
	var bb = area.get_parent()
	print("POP?")  # Debug check
	if bb.is_in_group("bubbles"):
		var t = rng.randi() % 4
		if t == 0:
			queue_free()
		if t == 1:
			size *= 1.5
	if hits_remaining <= 0:
		return
	if area.is_in_group("bullets"):
		print("yeeew")  # Debug check
		queue_free()
		hits_remaining -= 1
		if hits_remaining <= 0:
			area.queue_free()
