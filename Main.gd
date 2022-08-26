extends Node

export (PackedScene) var mob_scene
var score

func _ready():
	# We randomize() here so that the random number generator
	# generates different random numbers each time the game is run
	randomize()

func game_over():
	$Music.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

func new_game():
	score = 0
	# Clear all previous mobs if still in screen
	get_tree().call_group("mobs", "queue_free")
	# Reset player
	$Player.start($StartPosition.position)
	$StartTimer.start()
	# Rest UI
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	# Play Some Music
	$Music.play()
	# Clear get ready message
	yield(get_tree().create_timer(2), "timeout")
	$HUD.show_message("")

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_MobTimer_timeout():
	var mob = mob_scene.instance()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI/2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += rand_range(-PI/4, PI/4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	
	# Why PI? In functions requiring angles, Godot uses radians, not degrees.
	# Pi represents a half turn in radians, about 3.1415 (there is also TAU which is
	# equal to 2 * PI). If you're more comfortable working with degrees, you'll
	# need to use the deg2rad() and rad2deg() functions to convert between the two.
