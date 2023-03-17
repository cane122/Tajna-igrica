extends Area2D

@export var speed = 400 # How fast the player will move (pixels/sec).
@export var hp = 100
var incar = false
var carInRadius
var damage = 0
var screen_size # Size of the game window.
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#taking damage
	hp = hp - (damage * delta)
	$"../UI".change_hp_value(hp)
	
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("mount"):
		if incar:
			leaveCar()
		else: 
			takeCar()
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("MainMenu"):
		get_tree().change_scene_to_file("res://scene/Menu.tscn")

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	if (carInRadius != null) and incar:
		carInRadius.followPlayer()
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "hodanje"
		$AnimatedSprite2D.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "skakanje"
		$AnimatedSprite2D.flip_v = velocity.y > 0
		
func takeDMG(dmg):
	damage = damage + dmg
	
func stopTakingDMG(dmg):
	damage = 0

func takeCar():
	if carInRadius != null:
		speed = 1000
		incar = true
	
func leaveCar():
	carInRadius.stopFollowPlayer()
	speed = 400
	incar = false

func _on_body_entered(body):
	if body.name == "Car":
		carInRadius = body


func _on_body_exited(body):
	if body.name == "Car":
		carInRadius = null
		
