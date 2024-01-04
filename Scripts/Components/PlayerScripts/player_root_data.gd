@tool
extends Node3D

@export var gravitational_body:Node3D = null:
	get:
		return get_child(0).body
	set(val):
		gravitational_body = val
		get_child(0).body = val
