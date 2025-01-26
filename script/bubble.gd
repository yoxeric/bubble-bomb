extends RigidBody3D

@onready var mesh = $bub
@onready var area = $Area3D/CollisionShape3D
@onready var pop_vfx = $pop
@onready var pop_vfx2 = $pap

var rng = RandomNumberGenerator.new()
var size = 0.5
var target_size = size  # Target size for smooth interpolation
var speed = 7
var target_velocity = Vector3.ZERO  # Target velocity for smooth interpolation
var bit2Mask = 1 << 2
var hits_remaining := 2
var smooth_factor = 0.4

func _ready():
	add_to_group("bubbles")
	#body_entered.connect(_on_area_entered)
	target_velocity = Vector3(rng.randf() * speed, -rng.randf() * speed, rng.randf() * speed)
	linear_velocity = target_velocity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Smoothly interpolate size
	size = lerp(size, target_size, smooth_factor)
	if mesh != null:
		mesh.scale = Vector3(size, size, size)
	area.shape.radius = size * 5


func _on_mouse_entered():
	target_size = size + 0.3

func _on_mouse_exited():
	target_size = size - 0.3

#die
func pop(type):
	if mesh != null:
		mesh.queue_free()
	mesh = null
	if (type == 1):
		pop_vfx.emitting = true
	if (type == 2):
		pop_vfx2.emitting = true
	await get_tree().create_timer(0.5).timeout
	queue_free()

func _on_area_3d_body_entered(body):
	if body.is_in_group("bubbles"):
		#print("POP?")  # Debug check
		var t = rng.randi() % 4
		if t == 0:
			pop(2)
		if t == 1:
			target_size *= 1.5
			speed *= 0.8
			target_velocity = Vector3(rng.randf() * speed, rng.randf() * speed, rng.randf() * speed)

func _on_area_3d_area_entered(area):
	if hits_remaining <= 0:
		return
	if area.is_in_group("bullets"):
		#print("yeeew")  # Debug check
		get_tree().call_group("game", "add_money", size)
		hits_remaining -= 1
		pop(1)
		if hits_remaining <= 0:
			area.queue_free()
