extends RichTextLabel

@export var player_character:Node3D

const flat_surface:String = "Currently attracted to [color=blue]a flat surface[/color]."
const planet:String = "Currently attracted to [color=purple]a planet[/color]."

func _process(delta):
	if player_character.gravity_component != null:
		if player_character.gravity_component.forced_direction:
			text = flat_surface
		else:
			text = planet
	else:
		text = "No gravitational pull."
