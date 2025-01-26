extends Node3D

const BUBBLE = preload("res://scene/bubble.tscn")
const BULLET = preload("res://scene/bullet.tscn")
const BLOWER = preload("res://scene/blower.tscn")

@onready var gun = $plyr/gun
@onready var camera_3d = $plyr/Camera3D
@onready var score = $UI/score

const BULLET_SPEED = 100.0  # Adjust speed as needed
const RAY_LENGTH = 500.0  # Adjust speed as needed
const view = Vector2(20, 20)  # Adjust speed as needed

var money = 0
var equiped_gun = 1
var rng = RandomNumberGenerator.new()

# Add this node to the "game" group for communication with bullets
func _ready():
	add_to_group("game")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	# Make the gun look at the mouse position

# Get the mouse position in 3D space
func get_mouse_pos():
	var mousePos = get_viewport().get_mouse_position()
	var from = camera_3d.project_ray_origin(mousePos)
	var to = from + camera_3d.project_ray_normal(mousePos) * RAY_LENGTH
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

func spawn_blower(position: Vector3, typ: int):
	print("t ", typ)
	var instance = BLOWER.instantiate()
	instance.position = position
	instance.type = typ
	add_child(instance)

# Called when the bubble spawner timer times out
func _on_timer_timeout():
	spawn_bubble(Vector3(rng.randf_range(-view.x, view.x), view.y, rng.randf_range(-view.x, view.x)))

# Add money when a bubble is popped
func add_money(amount):
	money += amount
