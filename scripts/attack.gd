extends Node

@onready var player: CharacterBody2D = $".."  # Get parent (player)
@onready var animated_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"  # Correct reference

var is_attacking = false  # Track attack state

func attack():
	if is_attacking or not player.is_on_floor():  # Prevent attack spam & mid-air attacks
		return
	
	is_attacking = true
	player.velocity = Vector2.ZERO  # Stop movement while attacking
	animated_sprite.play("attack")

	await animated_sprite.animation_finished  # Wait for animation to finish
	is_attacking = false  # Allow movement again
