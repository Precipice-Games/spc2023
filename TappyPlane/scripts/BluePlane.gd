class_name BluePlane
extends Area2D

signal crashed
signal scored

const flight_speed:float = 10

@export var fall_speed:float = 9.8
@export var tap_strength:float = 20
@export var sprite:Sprite2D

var velocity:Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = get_node("Sprite")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event.is_action_released("tap"):
		velocity.y -= tap_strength * fall_speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y += fall_speed
	position += velocity * delta
	print(position.y)
	if position.y > 590:
		call_deferred("burn")


func crash():
	sprite.flip_v = true
	crashed.emit()


func burn():
	process_mode = Node.PROCESS_MODE_DISABLED


func _on_area_2d_area_entered(area):
	var layer:CanvasLayer = area.get_parent()
	match layer.name:
		"Obstacles":
			crash()
		"Collectibles":
			scored.emit()
			area.queue_free()
