extends RigidBody2D

var target = null
const SPEED = 200
var screen_size
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if target:
		velocity = global_position.direction_to(target.global_position)
		move_and_collide(velocity * SPEED * delta)
	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x > 0:
		$AnimatedSprite2D.animation = "desno"
	elif velocity.x < 0:
		$AnimatedSprite2D.animation = "levo"
	elif velocity.y < 0:
		$AnimatedSprite2D.animation = "desno"
	elif velocity.y > 0:
		$AnimatedSprite2D.animation = "gore"





func _on_field_of_view_area_entered(area):
	print(area.name)
	if area.name == "Player":
		target = area



func _on_field_of_view_area_exited(area):
	print(area.name)
	if area.name == "Player":
		target = null


func _on_area_of_damage_area_entered(area):
	if area.name == "Player":
		area.takeDMG(10)


func _on_area_of_damage_area_exited(area):
	if area.name == "Player":
		area.stopTakingDMG(10)
