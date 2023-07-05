extends CharacterBody2D

@export var direction = 1

## Speed of enemy while attacking (in pixels/sec)
@export var ATTACK_SPEED = 150
## Speed of enemy while patrolling (in pixels/sec)
@export var PATROL_SPEED = 75

@export var player:CharacterBody2D

enum State {PATROL, ATTACK}

var state = State.PATROL


func _ready():
	#Checks if the sprite should be flipped or not at the start
	if not player:
		player = $Player
	if direction == 1:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	$AnimatedSprite2D.play("Flying")


func _physics_process(delta):
	if is_player_in_line_of_sight():
		state = State.ATTACK
	else:
		state = State.PATROL

	match state:
		State.PATROL:
			$AnimatedSprite2D.speed_scale = 1
			velocity = Vector2.RIGHT if direction == 1 else Vector2.LEFT
			velocity *= PATROL_SPEED
		State.ATTACK:
			$AnimatedSprite2D.speed_scale = ATTACK_SPEED / PATROL_SPEED
			velocity = $PlayerDetector.target_position.normalized()
			velocity *= ATTACK_SPEED

	move_and_slide()


func _on_turn_around_timer_timeout():
	direction *= -1


func is_player_in_line_of_sight():
	$PlayerDetector.target_position = player.position - position
	return not $PlayerDetector.is_colliding()
