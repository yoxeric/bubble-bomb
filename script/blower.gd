extends RigidBody3D

const BUBBLE = preload("res://scene/bubble.tscn")
var rng = RandomNumberGenerator.new()
@onready var main = get_parent()
@onready var timer = $Timer

const BUBBLE_MACHINE = preload("res://assets/bubble machine.blend")
const BLOWER = preload("res://assets/blower.blend")

var model

var type = 1
var rate = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	print(type)
	timer.wait_time = rate
	if type == 1:
		model = BLOWER.instantiate()
		gravity_scale = 0
		model.position = Vector3(0, 1, 0)
		add_child(model)
	if type == 2:
		model = BUBBLE_MACHINE.instantiate()
		gravity_scale = 0.5
		model.position = Vector3(0, -1, 0)
		add_child(model)
		rate = 2
	model.scale = Vector3(0.5, 0.5, 0.5)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_bubble(position: Vector3):
	#var random_index = rng.randi() % objects.size()
	#var object_scene = objects[random_index]
	var instance = BUBBLE.instantiate()
	main.add_child(instance)
	instance.position = position
	if type == 1:
		instance.linear_velocity = Vector3(rng.randf(), rng.randf(), rng.randf())
	if type == 2:
		instance.linear_velocity = Vector3(rng.randf(), rng.randf() * 10, rng.randf())


func _on_timer_timeout():
	spawn_bubble(position)
