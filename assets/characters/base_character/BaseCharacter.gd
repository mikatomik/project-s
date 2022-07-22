extends KinematicBody

export var is_firing = false
export var look_angle = 0
export var weapon_pitch = 0
export var weapon_pitch_bias = deg2rad(20)

func _process(_delta):
	var effective_weapon_pitch = weapon_pitch - weapon_pitch_bias if is_firing else weapon_pitch
	effective_weapon_pitch = clamp(effective_weapon_pitch, deg2rad(-90), deg2rad(90))
	$GooGun.is_firing = is_firing
	$GooGun.look_angle = look_angle
	$GooGun.weapon_pitch = effective_weapon_pitch
	$GooGun.rotation.x = effective_weapon_pitch
	rotation.y = look_angle
