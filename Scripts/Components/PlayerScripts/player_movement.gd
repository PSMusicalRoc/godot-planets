class_name PlayerMovement
extends CharacterBody3D

## Important Concepts:
## -------------------
## 
## - The player body (child to the root) controls
##   the direction of movement, while the root
##   of the player defines the basis of the axes.

var gravity_component:GravityComponent = null

@export var body:Node3D

@export_group("Movement Settings")

@export var move_acceleration:float = 30.0
@export var move_speed:float = 20.0
@export var jump_strength:float = 15.0

@export var aerial_drift:float = 2.0

## Hidden Physics variables

var should_snap:bool = false
var snap_length:float = 4.0

@export_group("Children Settings")

@export var collision:CollisionShape3D
@export var spring_arm:SpringArm3D

@export_group("Camera Options")

@export var mouse_sensitivity_x:float = 0.5
@export var mouse_sensitivity_y:float = 0.5
var mouse_movement:Vector2 = Vector2.ZERO

@export_group("")

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity_component = GravityComponent.new(body, 10.0, true)


## Returns a normalized movement vector
## based on player input.
func process_movement() -> Vector2:
	var output:Vector2 = Vector2.ZERO
	if Input.is_action_pressed("MoveForward"):
		output.y -= 1
	if Input.is_action_pressed("MoveBackward"):
		output.y += 1
	if Input.is_action_pressed("MoveLeft"):
		output.x -= 1
	if Input.is_action_pressed("MoveRight"):
		output.x += 1
	return output.normalized()


func _input(event):
	if event is InputEventMouseMotion:
		mouse_movement -= event.relative * .01


## Quaternion thing right here!
## Note that important values where this does
## not "just work" are if the vector we
## rotate to is (0, 1, 0) (Y+) or
## (0, -1, 0) (Y-). For these, we have to find
## a workaround.
#print(temp_var)
#var test_direction = Vector3(
	#sin(deg_to_rad(temp_var)),
	#cos(deg_to_rad(temp_var)),
	#0).normalized()
#print(test_direction)
#temp_var += 1
#if temp_var >= 360:
	#temp_var -= 360
#
#var new_quat = Quaternion(Vector3.UP, test_direction).normalized()
#transform.basis = Basis(new_quat)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Do rotations on the camera before anything else
	spring_arm.rotate_y(mouse_sensitivity_x * mouse_movement.x)
	spring_arm.rotation.x = clamp(
		spring_arm.rotation.x + (mouse_sensitivity_y * mouse_movement.y),
		deg_to_rad(-80), deg_to_rad(80)
	)
	mouse_movement = Vector2.ZERO
	
	var just_landed = is_on_floor() and not should_snap
	var grounded = is_on_floor() and should_snap
	
	var movement_vector:Vector2 = process_movement()
	if movement_vector == Vector2.ZERO:
		if is_on_floor():
			velocity.x = 0
			velocity.z = 0
	else:
		# Rotation Code
		rotation.y = spring_arm.rotation.y
		movement_vector = movement_vector.rotated(-spring_arm.rotation.y)
		var movement_angle = Vector2(0, -1).angle_to(movement_vector)
		rotation.y = movement_angle
		
		if is_on_floor():
			velocity.x = movement_vector.x * move_speed
			velocity.z = movement_vector.y * move_speed
		else:
			velocity.x = movement_vector.x * aerial_drift
			velocity.z = movement_vector.y * aerial_drift
			
	
	# Jump Handling
	if Input.is_action_pressed("Jump") and is_on_floor():
		should_snap = false
		velocity.y = jump_strength
	if just_landed:
		should_snap = true
	
	# Gravity Handling
	if grounded: velocity.y = 0
	
	if gravity_component == null:
		pass
	else:
		var gdir = gravity_component.get_gravity_direction(
			position
		).normalized()
		velocity.y -= gravity_component.gravity_strength * delta
		
		# now, rotate the basis of the root node
		get_parent_node_3d().transform.basis = gravity_component.generate_gravity_basis(
			gdir
		)
	
	if should_snap:
		floor_snap_length = snap_length
	else:
		floor_snap_length = 0.0
		
	move_and_slide()
	
	# After we move, make sure that the
	# player root also follows this position exactly.
	get_parent_node_3d().global_position = global_position
	transform.origin = Vector3(0, 0, 0)
