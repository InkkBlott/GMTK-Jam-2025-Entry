#region Anisprite Methods
//predefined method functions for anisprites to use
global.anisprite_methods = {}

global.anisprite_methods[$ "character horizontal flip"] = function() { //flip Anisprite based on Character's horizontal orientation
	var c = dcos(face_direction)
	if (c > 0 and flipped_x) { flipped_x = false }
	else if (c < 0 and !flipped_x) { flipped_x = true }
}
global.anisprite_methods[$ "character vertical orientation"] = function() { //set Anisprite animation orientation based on character's vertical orientation
	var c = dsin(face_direction)
	if (c < 0 and anim_orientation != 0) { anim_orientation = 0 }
	else if (c > 0 and anim_orientation != 1) {  anim_orientation = 1 }
}

global.anisprite_methods[$ "basic character step"] = function() {
	face_direction = handler.face_direction
	method(self,global.anisprite_methods[$ "character horizontal flip"])()
	method(self,global.anisprite_methods[$ "character vertical orientation"])()
}

global.anisprite_methods[$ "aijou run fx 1"] = function() {
	var o = handler.world.create_instance(obj_h_fxAnim, handler.x-3, handler.y+14)
	o.set_anisprite("fxAnim: circlespark small")
	o.destroy_on_animation_end = true
}
global.anisprite_methods[$ "aijou run fx 2"] = function() {
	var o = handler.world.create_instance(obj_h_fxAnim, handler.x+3, handler.y+14)
	o.set_anisprite("fxAnim: circlespark small")
	o.destroy_on_animation_end = true
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
#region MC
global.anisprite_types[$ "hacker aijou"] = [ //hacker aijou gameplay sprite
	{sprites: [spr_hack_aijou_00_A, spr_hack_aijou_00_B], //0: standing
	offset_x: 0,
	offset_y: 0,
	frame_offset: undefined,
	default_speed: 0.1,
	frame_sequence: [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,2,2,2,2,0,0,3,0,0,0,0,3],
	loop_frame: 0,
	frame_function: undefined,
	anim_step: global.anisprite_methods[$ "basic character step"]
	},
]
#endregion MC
#endregion Characters

#endregion Anisprite Types