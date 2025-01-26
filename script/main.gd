extends Node3D

const BUBBLE = preload("res://scene/bubble.tscn")
const BULLET = preload("res://scene/bullet.tscn")

const BULLET_SPEED = 100.0  # Adjust speed as needed

@onready var gun = $gun
@onready var camera_3d = $Camera3D
@onready var score = $UI/score

var money = 0
var rng = RandomNumberGenerator.new()

# Add this node to the "game" group for communication with bullets
func _ready():
	add_to_group("game")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	score.text = str(money)
	
	# Make the gun look at the mouse position
	var pos = get_mouse_pos()
	if pos:
		gun.look_at(pos)
	
	# Shoot bullets when the "magic" action is pressed
	if Input.is_action_just_pressed("magic"):
		spawn_bullet()

# Get the mouse position in 3D space
func get_mouse_pos():
	var mousePos = get_viewport().get_mouse_position()
	var from = camera_3d.project_ray_origin(mousePos)
	var to = from + camera_3d.project_ray_normal(mousePos) * 500  # Ray length
	var space = get_world_3d().direct_space_state
	var rayQuery = PhysicsRayQueryParameters3D.new()
	rayQuery.from = from
	rayQuery.to = to
	var result = space.intersect_ray(rayQuery)
	if result:
		return result.position
	return null

# Spawn a bullet
func spawn_bullet():
	var instance = BULLET.instantiate()
	add_child(instance)
	var spawn_pos = gun.global_position
	var forward_dir = -gun.global_transform.basis.z
	instance.global_position = spawn_pos + forward_dir * 1.5  # Spawn slightly in front of the gun
	#instance.linear_velocity = forward_dir * BULLET_SPEED
	instance.direction = forward_dir.normalized()

# Spawn a bubble at a random position
func spawn_bubble(position: Vector3):
	var instance = BUBBLE.instantiate()
	add_child(instance)
	instance.position = position
	instance.linear_velocity = Vector3(rng.randf(), 0, rng.randf())

# Called when the bubble spawner timer times out
func _on_timer_timeout():
	spawn_bubble(Vector3(rng.randf_range(-10, 10), 17, rng.randf_range(-10, 10)))

# Add money when a bubble is popped
func add_money(amount):
	money += amount
