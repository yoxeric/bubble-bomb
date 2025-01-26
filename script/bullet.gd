extends Area3D

const BULLET_SPEED = 100.0
var lifetime = 20.0
var hits_remaining := 2
var direction := Vector3.FORWARD

func _ready():
	add_to_group("bullets")
	#body_entered.connect(_on_area_entered)
	# Start movement and lifetime timer
	var timer = get_tree().create_timer(lifetime)
	timer.timeout.connect(queue_free)
	
func _physics_process(delta):
	# Move bullet forward manually
	global_translate(direction * BULLET_SPEED * delta)

# Called when the bullet collides with another body
#func _on_body_entered(body):
	#if hits_remaining <= 0:
		#return
	#if body.is_in_group("bubbles"):
		#print("POP?")  # Debug check
		#body.queue_free()
		#get_tree().call_group("game", "add_money", body.size)
		#hits_remaining -= 1
		#
		#if hits_remaining <= 0:
			#queue_free()


#func _on_area_entered(area):
	#if hits_remaining <= 0:
		#return
	#var bb = area.get_parent()
	#if bb.is_in_group("bubbles"):
		#print("POP?")  # Debug check
		#get_tree().call_group("game", "add_money", bb.size)
		#bb.queue_free()
		#hits_remaining -= 1
		#if hits_remaining <= 0:
			#queue_free()
