extends Area2D

signal pickup_collected

func _on_body_entered(body):
	#"Deletes" the pickup
	queue_free()
	emit_signal("pickup_collected")
	
	#Player's code, because he is the body that we are interacting with
	body.add_pickup()
