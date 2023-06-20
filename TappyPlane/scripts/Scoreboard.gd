extends RichTextLabel

const REWARD_VALUE:int = 10

var score:int = 0
var text_placeholder = "Score: %s"

# Called when the node enters the scene tree for the first time.
func _ready():
	update_score(0)


func _on_plane_scored():
	update_score(REWARD_VALUE)


func update_score(points):
	score += points
	text = text_placeholder % score
