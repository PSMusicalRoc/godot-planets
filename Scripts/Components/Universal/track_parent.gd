class_name TrackParentComponent
extends Node3D

@export var offset:Vector3 = Vector3.ZERO

func track(obj:Node3D, parent:Node3D):
	obj.global_transform.origin = parent.global_position + offset
