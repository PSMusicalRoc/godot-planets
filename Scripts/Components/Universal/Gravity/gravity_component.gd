class_name GravityComponent

var gravity_strength:float = 10.0
var forced_direction:bool = false
var body:Node3D = null

func _init(body_to_attact_to:Node3D,
	grav_strength:float = 10.0,
	forced_dir:bool = false
):
	body = body_to_attact_to
	forced_direction = forced_dir
	gravity_strength = grav_strength

## Generates a basis such that the new
## "up" vector will be pointing along N
## 
## @param N The target normal vector
## @returns The newly constructed basis
func generate_gravity_basis(N:Vector3) -> Basis:
	var up = Vector3.UP
	if up.dot(N) > 0.7071:
		up = Vector3.BACK
	var R = up.cross(N).normalized()
	var U = N.cross(R).normalized()
	return Basis(R, N, U)

func get_gravity_direction(obj_pos:Vector3) -> Vector3:
	if forced_direction:
		return body.transform.basis.y
	else:
		return (obj_pos - body.global_position).normalized()
