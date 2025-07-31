/// @function Anisprite(animset, handler) 
/// @param {array} animset Array containing sprites to use for animations and animation speeds
/// @param {instance} handler Instance that this Anisprite is attached to. Used for animation function reference
/// @desc creates a struct-based "anisprite" instance used for sprite animation in this game

function Anisprite(animset, inp_handler=noone) constructor {
	if (typeof(animset) == "string") {
		animations = global.anisprite_types[$ animset];
	} else {
		animations = animset;
	}
	x = 0
	y = 0
	offset_x = 0
	offset_y = 0
	secondary_offset_x = 0 //these secondary offsets WILL NOT be affected by offset rotation
	secondary_offset_y = 0
	offset_rotation = false //causes anisprite to rotate its drawing position around offset values
	scale_x = 1
	scale_y = 1
	flipped_x = false
	flipped_y = false
	face_direction = 0
	face_direction_horizontal_flip = false
	angle = 0
	alpha = 1
	anim = 0
	anim_orientation = 0
	anim_frame = 0
	anim_speed_scale = 1
	anim_tracker = -1
	anim_frame_tracker = -1
	anim_functions_active = true
	anim_finished = false
	anim_end_invisibility = false
	anim_vars = undefined //reset on animation change. Can be manipulated by frame methods to store values
	handler = inp_handler
	current_anim_step = undefined
	tick_counter = 0 //generic counter. Increments by 1 every step() and resets at 216000 (1 hour at 60fps)
	/// @function step()
	/// @desc processes anisprite animation
	static step = function() {
		var num_frames = frame_count()
		var current_anim = animations[anim]
		if (anim_tracker != anim) {
			anim_tracker = anim
			anim_frame = 0
			anim_frame_tracker = -1
			anim_finished = false
			if (!is_undefined(current_anim.anim_step)) { current_anim_step = method(self,current_anim.anim_step) }
			else current_anim_step = undefined
		} else {
			anim_frame += current_anim.default_speed*anim_speed_scale
			if (anim_frame >= num_frames) {
				if (not(anim_finished)) {
					anim_finished = true
					if (anim_end_invisibility) alpha = 0
				}
				if (is_undefined(current_anim.loop_frame)) {
					anim_frame = num_frames-1
				} else {
					//[DEV] Find out if this is still needed. The issue (whatever the hell it was) may have been fixed at some point.
					//anim_frame = current_anim.loop_frame+frac(real(string(anim_frame))) //THIS SEEMINGLY POINTLESS CONVERSION IS NECESSARRY. Some kind of floating point error will cause 4.00 (example) to floor() to 3 otherwise. Modulus will also similarly malfunction.
					anim_frame = current_anim.loop_frame+frac(anim_frame) //It would appear that, at some point, the above issue was corrected in a Game Maker update. I'm not sure when, or what, or how, but this seems to work normally now
					//TODO: Finalize this change by deleting the commented-out old work-around version after verifying that this is actually fine now
				}
			}
		}
		if (!is_undefined(current_anim_step)) current_anim_step()
		var fr = floor(anim_frame)
		if (anim_functions_active) {
			while (anim_frame_tracker != fr) {
				anim_frame_tracker ++
				if (anim_frame_tracker >= num_frames) { anim_frame_tracker = min(current_anim.loop_frame, fr) }
				if (!is_undefined(current_anim.frame_function)) { 
					var funcs = current_anim.frame_function
					for (var i=0; i<array_length(funcs); i++) {
						if (fr == funcs[i][0]) { method(self,funcs[i][1])() }
					}
				}
			}
		} else if (anim_frame_tracker != fr) { anim_frame_tracker = fr }
		//horizontal flip
		if (face_direction_horizontal_flip) {
			var c = dcos(face_direction)
			if (c > 0 and flipped_x) { flipped_x = false }
			else if (c < 0 and !flipped_x) { flipped_x = true }
		}
		//iterate tick counter
		tick_counter ++
		if (tick_counter >= 216000) tick_counter %= 216000
	}
	/// @function draw(x,y)
	/// @desc draw anisprite with current settings
	static draw = function(inp_x=undefined,inp_y=undefined) {
		if (alpha <= 0) return;
		var draw_x = inp_x ?? x
		var draw_y = inp_y ?? y
		var current_anim = animations[anim]
		var draw_scale_x = scale_x
		var draw_scale_y = scale_y
		var draw_frame = floor(anim_frame)
		if (flipped_x) { draw_scale_x *= -1 }
		if (flipped_y) { draw_scale_y *= -1 }
		var draw_offset_x = offset_x + current_anim.offset_x
		var draw_offset_y = offset_y + current_anim.offset_y
		if (!is_undefined(current_anim.frame_offset)) {
			draw_offset_x += current_anim.frame_offset[draw_frame][0]
			draw_offset_y += current_anim.frame_offset[draw_frame][1]
		}
		var subimg
		if (!is_undefined(current_anim.frame_sequence)) { subimg = current_anim.frame_sequence[draw_frame] }
		else { subimg = draw_frame }
		if (offset_rotation and angle != 0) {
			var ang = point_direction(0,0,draw_offset_x,draw_offset_y) + angle
			var dist = point_distance(0,0,draw_offset_x,draw_offset_y)
			draw_offset_x = dcos(ang)*dist
			draw_offset_y = 0-dsin(ang)*dist
		}
	}
	/// @function set_anim(new_anim)
	/// @param {real} new_anim Index of new animation to set
	/// @desc Change current anisprite animation
	static set_anim = function(new_anim) {
		anim = new_anim
		anim_frame = 0
		anim_frame_tracker = -1
		anim_finished = false
		anim_vars = undefined
		if (anim_orientation >= array_length(animations[anim].sprites)) { anim_orientation = 0 }
	}
	/// @function set_anim_frame(new_frame, ignore_tracker)
	/// @param {real} new_frame Animation frame to set
	/// @desc Change current anisprite animation frame without causing the frame tracker to produce bugs
	static set_anim_frame = function(new_frame, ignore_tracker=false) {
		anim_frame = new_frame
		if (ignore_tracker) { anim_frame_tracker = new_frame }
		else { anim_frame_tracker = new_frame-1 }
		anim_tracker = anim
		anim_finished = false
	}
	/// @function current_asset()
	/// @desc returns an array containing the sprite asset and sub-image index that the selected Anisprite is currently set to draw
	static current_asset = function() {
		var subimg
		if (!is_undefined(animations[anim].frame_sequence)) { subimg = animations[anim].frame_sequence[floor(anim_frame)] }
		else { subimg = floor(anim_frame) }
		return [animations[anim].sprites[anim_orientation],subimg]
	}
	/// @function frame_count()
	/// @desc returns number of frames in current animation
	static frame_count = function() {
		if (!is_undefined(animations[anim].frame_sequence)) { return array_length(animations[anim].frame_sequence) }
		else { return sprite_get_number(animations[anim].sprites[0]) }
	}
	/// @function orientation_count()
	/// @desc returns number of orientations in current animation
	static orientation_count = function() {
		 return array_length(animations[anim].sprites)
	}
}