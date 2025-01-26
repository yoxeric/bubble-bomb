extends Node3D

const BUBBLE = preload("res://scene/bubble.tscn")
var rng = RandomNumberGenerator.new()
@onready var main = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func spawn_bubble(position: Vector3):
	#var random_index = rng.randi() % objects.size()
	#var object_scene = objects[random_index]
	var instance = BUBBLE.instantiate()
	main.add_child(instance)
	instance.position = position
	instance.linear_velocity = Vector3(rng.randf(), 0, rng.randf())


func _on_timer_timeout():
	spawn_bubble(position)
