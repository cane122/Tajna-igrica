extends RigidBody2D

var canFollow = false
var target = null
const SPEED = 1200
var screen_size
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

func followPlayer():
	canFollow = true

func stopFollowPlayer():
	canFollow = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if target and canFollow:
		velocity = global_position.direction_to(target.global_position)
		move_and_collide(velocity * SPEED * delta)
		if velocity.length() > 0:
			$AnimatedSprite2D.play()
		else:
			$AnimatedSprite2D.stop()
		
		position += velocity * delta
		position.x = clamp(position.x, 0, screen_size.x)
		position.y = clamp(position.y, 0, screen_size.y)

func _on_area_2d_area_entered(area):
	if area.name == "Player":
		target = area

