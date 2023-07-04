extends CharacterBody2D

@export var direction = 1
@export var FLY_SPEED = 65

@onready var player = get_tree().get_root().get_node("res://Scenes/player.tscn")

enum State {PATROL, ATTACK}

var state = State.PATROL


func ready():
	#Checks if the sprite should be flipped or not at the start
	if direction == 1:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true


func _physics_process(delta):
	match state:
		State.PATROL:
			velocity.x += 30
			if direction == 1:
				velocity.x = FLY_SPEED
				$AnimatedSprite2D.play("Flying")
			elif direction == -1:
				velocity.x = FLY_SPEED * -1
				$AnimatedSprite2D.play("Flying")
			if $PlayerDetector.is_colliding():
				var collider = $PlayerDetector.get_collider()
				if collider.is_in_group("Player"):
					player = collider
					state = State.ATTACK
					
		State.ATTACK:
			var collider = $PlayerDetector.get_collider()
			#if not colliding or first collider is not player then switch back to PATROL
			if not $PlayerDetector.is_colliding() or collider.is_in_group("Player"):
				state = State.PATROL
			var motion = Vector2.ZERO
			motion += position.direction_to(player.position)
			velocity = motion 
					
					

func _on_turn_around_timer_timeout():
	if direction == 1:
		direction *= -1
	elif direction == -1:
		direction *= 1
