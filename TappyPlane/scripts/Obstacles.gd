extends CanvasLayer


@export var max_obstacle_delay:float = 2
@export var min_obstacle_delay:float = 0.25
@export var obstacles:Array[PackedScene]

var time_until_next_obstacle:float = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		var notifier := child.get_node("./VisibleOnScreenNotifier2D") as VisibleOnScreenNotifier2D
		notifier.screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited.bind(notifier.get_parent()))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scroll_terrain()
	if time_until_next_obstacle <= 0:
		spawn_obstacle()
		time_until_next_obstacle = randf_range(min_obstacle_delay, max_obstacle_delay)
	else:
		time_until_next_obstacle -= delta


func spawn_obstacle():
	var next_obstacle:Node2D = obstacles.pick_random().instantiate()
	next_obstacle.position.x = get_viewport().size.x
	add_child(next_obstacle)

func scroll_terrain():
	for child in get_children():
		var obstacle := child as Node2D
		obstacle.position.x -= BluePlane.flight_speed


func _on_visible_on_screen_notifier_2d_screen_exited(obstacle:Node2D):
	if obstacle.name.begins_with("GroundDirt"):
		obstacle.position.x += 3 * obstacle.get_node("Sprite").get_rect().size.x
	else:
		obstacle.queue_free()


func _on_plane_crashed():
	process_mode = Node.PROCESS_MODE_DISABLED


func _on_visible_on_screen_notifier_2d_screen_entered(obstacle:Node2D):
	pass # Replace with function body.
