extends Spatial

export var is_firing = false
export var fire_rate = 0.1
export var projectile_spread = 0 #TODO
export var projectile_scalar = 25
export var look_angle = 0
export var weapon_pitch = 0

var time_since_fire = 0

var Bullet = preload("res://assets/weapons/goo_gun/Bullet.tscn")

func _physics_process(delta):
	if is_firing:
		time_since_fire += delta
		if time_since_fire >= fire_rate:
			time_since_fire -= fire_rate
			do_fire_projectile()
	else:
		time_since_fire = fire_rate

func do_fire_projectile():
	var bullet = Bullet.instance()
	$Nozzle.add_child(bullet)
	bullet.set_as_toplevel(true)
	var shoot_direction = Vector3.FORWARD.rotated(Vector3.LEFT, weapon_pitch)
	shoot_direction = shoot_direction.rotated(Vector3.UP, look_angle)
	bullet.apply_central_impulse(shoot_direction.normalized() * projectile_scalar)
