@tool
extends Node3D

@export_group("Children")
@export var planet_collision:CollisionShape3D
@export var planet_mesh:CSGSphere3D
@export var gravity_area:CollisionShape3D
@export var gravity_mesh:CSGSphere3D

@export_group("Planet Properties")

@export var planet_material:Material:
	get:
		if planet_mesh != null:
			return planet_mesh.material
		return null
	
	
	set(val):
		if planet_mesh != null:
			planet_material = val
			planet_mesh.material = val

@export var planet_radius:float = 5.0:
	set(val):
		if val <= 0.0:
			val = 0.0
		planet_radius = val
		if planet_collision != null:
			planet_collision.scale.x = val
			planet_collision.scale.z = val
			planet_collision.scale.y = val


@export_group("Gravity Properties")
@export var gravity_material:Material:
	get:
		if gravity_mesh != null:
			return gravity_mesh.material
		return null
	
	
	set(val):
		if gravity_mesh != null:
			gravity_material = val
			gravity_mesh.material = val

@export var gravity_radius:float = 8.0:
	set(val):
		if val <= 0.0:
			val = 0.0
		gravity_radius = val
		if gravity_area != null:
			gravity_area.scale.x = val
			gravity_area.scale.z = val
			gravity_area.scale.y = val

## TODO finish set here when we write the area
## code for the gravity
@export var gravity_strength:float = 10.0



