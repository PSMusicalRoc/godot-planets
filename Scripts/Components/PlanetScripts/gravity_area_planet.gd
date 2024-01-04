extends Area3D

"""
Long and short here is that we're gonna be checking if the thing
that enters the area is affected by gravity (ie. it has a parameter
somewhere for a GravityComponent to go). If it does, add ours to that
parameter. If the thing is leaving, and has our gravity component,
strip it away. If not, do nothing.
"""

var my_gravity_component:GravityComponent
var players_affected:Array

@export var planet_body:Node3D = null
@export var gravity_strength:float = 10.0:
	set(val):
		gravity_strength = val
		update_my_gravity()

func _ready():
	update_my_gravity()


func update_my_gravity():
	my_gravity_component = GravityComponent.new(
		planet_body, gravity_strength, false
	)
	for body in players_affected:
		body.gravity_component = my_gravity_component


func on_body_enter(body):
	if body is PhysicsBody3D:
		if body.get_collision_layer_value(4): # is it a gravity character
			body.gravity_component = my_gravity_component
			if not players_affected.has(body):
				players_affected.append(body)


func on_body_exit(body):
	pass
	#if body is PhysicsBody3D:
		#if body.get_collision_layer_value(4): # is it a gravity character
			#if body.gravity_component == my_gravity_component:
				#body.gravity_component = null
			#if players_affected.has(body):
				#var loc = players_affected.find(body)
				#players_affected.remove_at(loc)
