extends CharacterBody3D

@onready var main = $".."
@onready var gun = $gun
@onready var camera_3d = $Camera3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Recoil variables
var recoil_strength = 2  # How far the gun moves back
var recoil_recovery_speed = 0.7  # How quickly the gun returns to its original position
var recoil_offset = Vector3.ZERO  # Current recoil offset

# Smooth gun movement variables
var gun_target_position = Vector3.ZERO  # Target position for the gun
var gun_smooth_speed = 10.0  # How quickly the gun moves to its target

# Camera rotation variables
var camera_rotation_strength = 0.01  # How much the camera rotates when shooting
var camera_target_rotation = Vector3.ZERO  # Target rotation for the camera
var camera_rotation_recovery_speed = 5.0  # How quickly the camera returns to its original rotation

# Smooth gun rotation variables
var gun_target_rotation = Basis()  # Target rotation for the gun
var gun_rotation_smooth_speed = 10.0  # How quickly the gun rotates to its target

# Recoil variables
var recoil_rotation = Basis()  # Current recoil rotation
#var recoil_strength = 0.1  # How much the gun rotates when shooting
#var recoil_recovery_speed = 10.0  # How quickly the gun returns to its original rotation

func _ready():
	camera_target_rotation = camera_3d.position
	gun_target_position = gun.position


func _physics_process(delta):
	# Get mouse position
	var pos = main.get_mouse_pos()
	if pos:
		# Smoothly rotate the gun to look at the mouse position
		var target_direction = (pos - gun.global_transform.origin).normalized()
		var target_basis = Basis.looking_at(target_direction, Vector3.UP)
		gun_target_rotation = target_basis
	
	# Apply recoil recovery
	recoil_rotation = recoil_rotation.slerp(Basis(), recoil_recovery_speed * delta)
	
	# Combine the target rotation and recoil rotation
	gun.transform.basis = gun.transform.basis.slerp(gun_target_rotation * recoil_rotation, gun_rotation_smooth_speed * delta)
	
	
	# Handle shooting
	if Input.is_action_just_pressed("mouse_left"):
		if main.equiped_gun == 1:
			shoot()
	
	if Input.is_action_pressed("mouse_left"):
		if main.equiped_gun == 2:
			shoot()
	
	# Apply recoil recovery
	#gun_target_position = gun_target_position.lerp(gun_target_position + recoil_offset, recoil_recovery_speed * delta)
	#gun.position = gun_target_position
	recoil_offset = recoil_offset.lerp(Vector3.ZERO, recoil_recovery_speed * delta)
	gun.position = gun_target_position + recoil_offset
	
	# Smoothly move the gun to its target position
	gun.position = gun.position.lerp(gun_target_position, gun_smooth_speed * delta)
	
	# Smoothly rotate the camera back to its original rotation
	#camera_3d.rotation = camera_3d.rotation.lerp(camera_target_rotation, camera_rotation_recovery_speed * delta)

func shoot():
	# Spawn a bullet
	main.spawn_bullet()
	
	# Apply recoil
	var forward_dir = -gun.global_transform.basis.z
	recoil_offset = forward_dir * -recoil_strength
	
	# Add camera rotation effect
	#var random_rotation = Vector3(
		#randf_range(-camera_rotation_strength, camera_rotation_strength),
		#randf_range(-camera_rotation_strength, camera_rotation_strength),
		#0
	#)
	#camera_3d.rotation += random_rotation
	
	# Add shooting effects (e.g., muzzle flash, sound)
	# Example: Play a sound effect
	# $ShootSound.play()
	
	# Example: Trigger a muzzle flash animation
	# $MuzzleFlash.visible = true
	# await get_tree().create_timer(0.1).timeout
	# $MuzzleFlash.visible = false
