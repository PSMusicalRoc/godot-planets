extends Node3D

@export var camera_offset_from_player:Vector3 = Vector3.ZERO:
	set(val):
		if track_parent != null:
			track_parent.offset = val
		camera_offset_from_player = val

@export var parent_node:Node3D = null

var track_parent:TrackParentComponent


func _ready():
	track_parent = TrackParentComponent.new()
	track_parent.offset = camera_offset_from_player

func _process(delta):
	track_parent.track(self, parent_node)
