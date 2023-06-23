extends CharacterBody2D

var pickups = 0

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

@onready var animatedSprite = $AnimatedSprite

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_pressed("Right"):
		$AnimatedSprite2D.play("Walking")
		$AnimatedSprite2D.flip_h = false
	elif Input.is_action_pressed("Left"):
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("Walking")
	else:
		$AnimatedSprite2D.play("Idle")
	
	#if not is_on_floor():
		$AnimatedSprite2D.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func add_pickup():
	pickups = pickups + 1
