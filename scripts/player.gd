extends CharacterBody2D

const SPEED = 120.0
const JUMP_VELOCITY = -300.0

@onready var attack: Area2D = $attack
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_script = $attack  # Reference attack script

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Attack logic (delegates to attack script)
	if Input.is_action_just_pressed("attack") and not attack_script.is_attacking:
		attack_script.attack()
		return  # Stop further movement during attack

	# Handle movement when not attacking
	if not attack_script.is_attacking:
		handle_movement()

	move_and_slide()

func handle_movement():
	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get movement direction
	var direction := Input.get_axis("move_left", "move_right")
	# Set sprite direction
	if direction > 0:
		animated_sprite.flip_h = false
		attack.scale.x = 1
	elif direction < 0:
		animated_sprite.flip_h = true
		attack.scale.x = -1
	
	# Play movement animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("move")
	else:
		animated_sprite.play("jump")

	# Apply movement
	velocity.x = direction * SPEED if direction else move_toward(velocity.x, 0, SPEED)
