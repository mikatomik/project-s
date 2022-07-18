extends Spatial

export var aim_sensitivity = 0.035
export var movement_speed = 7
export var jump_strength = 12.5
export var gravity = 35

var velocity = Vector3.ZERO
var snap = Vector3.DOWN

onready var character = $BaseCharacter
onready var anchor = $Anchor
onready var spring_arm = $Anchor/SpringArm

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta):
	# The character model and the spring arm anchor are independent to allow them to rotate
	# independently.  Recouple their translations here so that the camera follows the model through
	# space.
	anchor.translation = character.translation

func _physics_process(delta):
	# Intended movement direction with the rotational angle adjusted by the camera's aim direction
	var move_direction = Vector3.ZERO
	move_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	move_direction.z = Input.get_action_strength("back") - Input.get_action_strength("forward")
	move_direction = move_direction.rotated(Vector3.UP, spring_arm.rotation.y).normalized()
	
	# Update velocity by new movement direction and continued effect of "gravity"
	velocity.x = move_direction.x * movement_speed
	velocity.z = move_direction.z * movement_speed
	velocity.y -= gravity * delta
	
	# Snap vector management: set to ZERO to enable jumping, DOWN otherwise to stick to surfaces.
	# Allow jump action for only one frame if already standing on a floor.
	var just_landed = character.is_on_floor() and snap == Vector3.ZERO
	var jump = character.is_on_floor() and Input.is_action_just_pressed("jump")
	if jump:
		velocity.y = jump_strength
		snap = Vector3.ZERO
	elif just_landed:
		snap = Vector3.DOWN
	
	# Move character.  Param 4 (true) means stop on slopes
	velocity = character.move_and_slide_with_snap(velocity, snap, Vector3.UP, true)
	
	# Update character look direction if moved
	if move_direction.length() > 0.2:
		var look_direction = Vector2(-velocity.z, -velocity.x)
		character.rotation.y = look_direction.angle()

func _unhandled_input(event):
	# Implement mouse aim direction
	if event is InputEventMouseMotion:
		spring_arm.rotation_degrees.x -= event.relative.y * aim_sensitivity
		spring_arm.rotation_degrees.x = clamp(spring_arm.rotation_degrees.x, -90, 90)
		
		spring_arm.rotation_degrees.y -= event.relative.x * aim_sensitivity
		spring_arm.rotation_degrees.y = wrapf(spring_arm.rotation_degrees.y, 0, 360)
