#region Anisprite Methods
//predefined method functions for anisprites to use
global.anisprite_methods = {}

global.anisprite_methods[$ "character horizontal flip"] = function() { //flip Anisprite based on Character's horizontal orientation
	var c = dcos(face_direction)
	if (c > 0 and flipped_x) { flipped_x = false }
	else if (c < 0 and !flipped_x) { flipped_x = true }
}
#endregion Anisprite Methods

#region Anisprite Types
//preset anisprite types

//sprites: array contining sprite assets. Anisprite anim_orientation value determines which sprite it pulls frames from
//loop_frame: Frame for animation to loop back to. Set to -1 for no loop
//frame_sequence: array that lists image indexes to use for the animation's frames, allowing animations to 
//		diverge from the sprite's contents without the need for duplicate/redundant sprites/frames. 
//		Set to false to use the sprite assets frames normally.
//frame_function: an array containing multiple 2-value arrays that contain [#frame , ()method] for Anisprite instances
//		to call on the defined frames. Set to false to ignore.
//anim_step: function to use as the animation's step() method
//frame_offset: array containing additional frame-by-frame [x,y] offsets to draw the sprite with. Set the value or individual indexes to undefined to ignore.

global.anisprite_types = {}

#region Characters
#region Player Character
global.anisprite_types[$ "Alchemist"] = [ //hacker aijou gameplay sprite
	{sprites: [spr_player_00], //0: idle
	offset_x: 0,
	offset_y: 0,
	frame_offset: undefined,
	default_speed: 0.2,
	frame_sequence: undefined,
	loop_frame: 0,
	frame_function: undefined,
	anim_step: global.anisprite_methods[$ "character horizontal flip"]
	},
	{sprites: [spr_player_01], //1: walking
	offset_x: 0,
	offset_y: 0,
	frame_offset: undefined,
	default_speed: 0.2,
	frame_sequence: undefined,
	loop_frame: 0,
	frame_function: undefined,
	anim_step: global.anisprite_methods[$ "character horizontal flip"]
	},
	{sprites: [spr_player_01], //2: jumping/falling
	offset_x: 0,
	offset_y: 0,
	frame_offset: undefined,
	default_speed: 0,
	frame_sequence: [4, 6],
	loop_frame: undefined,
	frame_function: undefined,
	anim_step: global.anisprite_methods[$ "character horizontal flip"]
	},
	{sprites: [spr_player_02], //3: attack
	offset_x: 0,
	offset_y: 0,
	frame_offset: undefined,
	default_speed: 0.2,
	frame_sequence: undefined,
	loop_frame: 0,
	frame_function: undefined,
	anim_step: global.anisprite_methods[$ "character horizontal flip"]
	},
	{sprites: [spr_player_03], //4: hurt
	offset_x: 0,
	offset_y: 0,
	frame_offset: undefined,
	default_speed: 0.2,
	frame_sequence: undefined,
	loop_frame: 0,
	frame_function: undefined,
	anim_step: global.anisprite_methods[$ "character horizontal flip"]
	},
	{sprites: [spr_player_04], //5: death
	offset_x: 0,
	offset_y: 0,
	frame_offset: undefined,
	default_speed: 0.2,
	frame_sequence: undefined,
	loop_frame: undefined,
	frame_function: undefined,
	anim_step: global.anisprite_methods[$ "character horizontal flip"]
	},
]
#endregion Player Character
#endregion Characters

#endregion Anisprite Types