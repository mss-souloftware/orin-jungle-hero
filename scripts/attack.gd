extends Node

@onready var player: CharacterBody2D = $".."  
@onready var animated_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"

var is_attacking = false  
var enemy_in_attack_zone: Node2D = null  # Store the enemy inside attack area

func attack():
	if is_attacking or not player.is_on_floor():
		return
	
	is_attacking = true
	player.velocity = Vector2.ZERO  
	animated_sprite.play("attack")

	await animated_sprite.animation_finished  
	is_attacking = false  

	# Damage the enemy **only if** they are inside attack zone
	if enemy_in_attack_zone and enemy_in_attack_zone.is_inside_tree():
		print("Attacking enemy:", enemy_in_attack_zone.name)
		enemy_in_attack_zone.take_damage()  # Reduce enemy health

# Detect enemy entering attack area
func _on_area_entered(area: Area2D) -> void:
	print("Something entered attack area:", area.name)

	var enemy = area.get_parent()  # Get the enemy node

	if enemy.is_in_group("enemies"):
		print("Enemy detected:", enemy.name)
		enemy_in_attack_zone = enemy  # Store reference

# Detect enemy leaving attack area
func _on_area_exited(area: Area2D) -> void:
	print("Enemy left attack area!")
	
	var enemy = area.get_parent()
	
	if enemy == enemy_in_attack_zone:
		enemy_in_attack_zone = null  # Clear reference if the enemy left
