extends Area2D

signal hit

export var speed = 400
var OS_NAME = OS.get_name()
var target = Vector2() # Stores the clicked/touched position
var screen_size

func process_key_input(velocity: Vector2):
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	return velocity

func process_touch_input(velocity: Vector2):
	if position.distance_to(target) > 10:
		return target - position
	return Vector2.ZERO

func process_input() -> Vector2:
	var velocity = Vector2.ZERO
	if OS_NAME == "OSX" or OS_NAME == "Windows":
		return process_key_input(velocity)
	else:
		return process_touch_input(velocity)

func update_animation(velocity):
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		# Boolean ssignment
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

func start(pos):
	position = pos
	target = pos # Initial "target" is the start position
	show()
	$CollisionShape2D.disabled = false

# Change the target whenever a touch event happens
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = process_input()
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	# Clamping the player's position to restrict the player to a rangeposition
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	update_animation(velocity)


func _on_Player_body_entered(body):
	# Player disappears after being hit
	hide()
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	# Disabling the area's collision shape can cause an error if it happens in the
	# middle of the engine's collision processing. Using set_deferred()
	# tells Godot to wait to disable the shape until it's safe to do so.
	$CollisionShape2D.set_deferred("disabled", true)
