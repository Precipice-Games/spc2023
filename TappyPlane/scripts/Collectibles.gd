extends CanvasLayer


@export var max_reward_delay:float = 3
@export var min_reward_delay:float = 0.5
@export var rewards:Array[PackedScene]

var time_until_next_reward:float = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		var notifier := child.get_node("./VisibleOnScreenNotifier2D") as VisibleOnScreenNotifier2D
		notifier.screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited.bind(notifier.get_parent()))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scroll()
	if time_until_next_reward <= 0:
		spawn_obstacle()
		time_until_next_reward = randf_range(min_reward_delay, max_reward_delay)
	else:
		time_until_next_reward -= delta


func spawn_obstacle():
	var next_reward:Node2D = rewards.pick_random().instantiate()
	next_reward.position.x = get_viewport().size.x
	next_reward.position.y = randf_range(40, get_viewport().size.y - 40)
	add_child(next_reward)

func scroll():
	for child in get_children():
		var reward := child as Node2D
		reward.position.x -= BluePlane.flight_speed


func _on_visible_on_screen_notifier_2d_screen_exited(reward:Node2D):
	reward.queue_free()


func _on_plane_crashed():
	process_mode = Node.PROCESS_MODE_DISABLED


func _on_visible_on_screen_notifier_2d_screen_entered(reward:Node2D):
	pass # Replace with function body.
