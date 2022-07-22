extends RigidBody

func _on_Bullet_body_entered(_body):
	queue_free()
