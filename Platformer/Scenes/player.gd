extends CharacterBody2D

signal landed

var pickups = 0

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

@onready var animatedSprite = $AnimatedSprite

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 0
var grounded = false

#Only runs when input happens
func _input(event):
	if event.is_action("Move"):
		move(Input.get_axis("Left", "Right"))
	if Input.is_action_pressed("Jump") and is_on_floor():
		jump()
	
	

func _physics_process(delta):
	# Add the gravity.
	ground_check(delta)
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func add_pickup():
	pickups = pickups + 1

func ground_check(delta):
	var was_grounded = grounded
	grounded = is_on_floor()
	if not grounded:
		velocity.y += gravity * delta
	elif not was_grounded:
		landed.emit()

func jump():
	velocity.y = JUMP_VELOCITY
	$AnimatedSprite2D.play("Jump")

func move(dir):
	direction = dir
	if dir == 0:
		$AnimatedSprite2D.play("Idle")
	else:
		$AnimatedSprite2D.play("Walking")
	$AnimatedSprite2D.flip_h = dir < 0

func _on_landed():
	if direction == 0:
		$AnimatedSprite2D.play("Idle")
	else:
		$AnimatedSprite2D.play("Walking")

func jump_finished():
	if grounded:
		$AnimatedSprite2D.play("Idle")
	else:
		$AnimatedSprite2D.play("Fall")
