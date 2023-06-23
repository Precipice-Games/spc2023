extends CanvasLayer

var pickups = 0

func _ready():
	$Panel/Score.text = str(pickups)


func _on_pickup_collected():
	pickups = pickups + 1
	_ready()

