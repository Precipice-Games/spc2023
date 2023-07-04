extends CharacterBody2D

@export var direction = 1
@export var WALK_SPEED = 65


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	#Checks if the sprite should be flipped or not at the start
	if direction == 1:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	
	#Find the extents of the collision shape and the x position of the raycast
	$RayCast.position.x = $CollisionShape2D.shape.get_size().x * direction
	

func _physics_process(delta):
	
	#Wall Direction
	if is_on_wall() or (not $RayCast.is_colliding() and is_on_floor()): 
		print("change direction!")
		direction = direction * -1
		$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h
		$RayCast.position.x = $CollisionShape2D.shape.get_size().x * direction
		#velocity.x = WALK_SPEED * direction
	
	
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	velocity.x += 20
	
	#Could write it simply like this
	if direction == 1:
		velocity.x = WALK_SPEED
		$AnimatedSprite2D.play("Walking")
	elif direction == -1:
		velocity.x = WALK_SPEED * -1
		$AnimatedSprite2D.play("Walking")
	
	#You can write it this way as well
	#velocity.x = 40 * direction 
	
	
	
	move_and_slide()


func _on_edge_body_entered(body):
	edge_movement(body)


func edge_movement(body):
	if body.is_in_group("Enemies") && direction == 1:
		direction = -1
	elif body.is_in_group("Enemies") && direction == -1:
		direction = 1


func _on_head_check_body_entered(body):
	$AnimatedSprite2D.play("Death")
	WALK_SPEED = 0
	#Makes it not collide with the player
	set_collision_layer_value(3, false)
	set_collision_mask_value(1, false)
	$"head check".set_collision_layer_value(3, false)
	$"head check".set_collision_mask_value(1, false)
	$"side check".set_collision_layer_value(3, false)
	$"side check".set_collision_mask_value(1, false)
	$Timer.start()
	
	


func _on_side_check_body_entered(body):
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_timer_timeout():
	queue_free()
