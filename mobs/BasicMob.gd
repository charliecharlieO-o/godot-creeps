extends RigidBody2D

func _ready():
	# Select a random animation for the mob
	$AnimatedSprite.playing = true
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]


func _on_VisibilityNotifier2D_screen_exited():
	# Make the mobs delete themselves when they leave the screen
	queue_free()
