extends Control

var rng = RandomNumberGenerator.new()
@onready var main = $".."
@onready var score = $score
@onready var tag = $DW2/tag

var blower_price = [30, 70]
var blower_zone = [Vector2(0, 0), Vector2(30, 0)]
var gun_price = [50, 200, 500]
var gun_unlocked = [1, 0, 0]
const zone = Vector3i(10, 5, 5)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	score.text = str(main.money)

#up
func _on_up_button_down():
	if (main.money >= blower_price[0]):
		var v = Vector3(blower_zone[0].x + rng.randi_range(-zone.x, zone.x), zone.y, blower_zone[0].y - rng.randi_range(-zone.z, zone.z))
		main.spawn_blower(v , 1)
		main.money -= blower_price[0]


func _on_up_2_button_down():
	if (main.money >= blower_price[1]):
		var v = Vector3(blower_zone[1].x + rng.randi_range(-zone.x, zone.x), zone.y, blower_zone[0].y - rng.randi_range(-zone.z, zone.z))
		main.spawn_blower(v , 2)
		main.money -= blower_price[1]

#gun
func _on_dw_button_down():
	main.equiped_gun = 1

func _on_dw_2_button_down():
	if (gun_unlocked[1] == 1 || main.money >= gun_price[1]):
		main.equiped_gun = 2
		if gun_unlocked[1] == 0:
			main.money -= gun_price[1]
			gun_unlocked[1] == 1
			tag.visible = false
