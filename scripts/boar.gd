extends Node2D

@export var health: int = 3  # Enemy health

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D  # Reference to sprite

func take_damage():
	health -= 1
	print("Boar hit! Health:", health)
	
	# Flash effect
	animated_sprite.modulate = Color(1, 0.5, 0.5)  # Red tint
	await get_tree().create_timer(0.15).timeout  # Wait 0.15 seconds
	animated_sprite.modulate = Color(1, 1, 1)  # Reset color

	if health <= 0:
		die()

func die():
	print("Boar defeated!")
	animated_sprite.play("die")  # Play death animation
	await animated_sprite.animation_finished  # Wait for animation to finish
	queue_free()  # Remove from the game
