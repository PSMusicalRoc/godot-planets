@tool
extends Node3D

@export var target:Node3D = null

@export var target_position:Vector3 = Vector3.ZERO:
	set(val):
		target_position = val
		if target != null:
			target.position = val
		rotate_self()

@export var y_rotation:float = 0.0:
	set(val):
		val = clamp(val, deg_to_rad(0), deg_to_rad(360))
		y_rotation = val
		get_child(0).rotation.y = val


## Generates a basis such that the new
## "up" vector will be pointing along N
## 
## @param N The target normal vector
## @returns The newly constructed basis
func generate_basis(N:Vector3) -> Basis:
	var up = Vector3.UP
	if up.dot(N) > 0.7071:
		up = Vector3.BACK
	var R = up.cross(N).normalized()
	var U = N.cross(R).normalized()
	return Basis(R, N, U)


func rotate_self():
	var new_y_axis = (position - target_position).normalized()
	transform.basis = generate_basis(new_y_axis)
