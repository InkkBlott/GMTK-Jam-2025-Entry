// Inherit the parent event
event_inherited();

//graphics
depth = DEPTH_LEVELS.NPC

//movement
m_acceleration = 0.3
m_deceleration = 0.5
m_speedMax_x = 3
m_speedMax_y = 5
m_collision_active = true

m_jumping = false
m_jumpPower = 5
m_grav_normal = 0.4
m_grav_jumping = 0.2
m_grounded = false

//combat
c_hp = 1
c_hp_max = 1

facing_h = DIRECTION.RIGHT
facing_v = DIRECTION.NEUTRAL

//state machine
action = ACTCODE_CHARACTER.IDLE
action_phase = 0
action_counter = 0
action_cancel_ready = false //set true when actions are allowed to be canceled by new actions from skills, commands, inputs, etc.
action_default = ACTCODE_CHARACTER.IDLE //action to revert to after completing generic actions. Use if ACTCODE constants is reccommended.
action_parameters = [] //specific settings provided for a particular action, where applicable
action_queue = [] //an array of [action_code, [action_params] (optional)] arrays for characters to complete before reverting to default action
					//action codes can be inserted without an array, if they don't have any params
action_previous = [action, action_parameters] //set by action_set(). Records prior action code and params



///@function jump([strength], [temp_gravity])
jump = function(_strength = undefined, _grav = undefined) {
	m_speed_y = -(_strength ?? m_jumpPower)
	m_gravity_temp = _grav
	m_grounded = false
	m_jumping = true
}

/// @function action_init(current_action)
//Initialize effects of current action. Used in action_set, overwritten in child objects' Create event
action_init = function(act) {
	
}
/// @function action_end(current_action)
//Conclude effects of current action. Used in action_set, overwritten in child objects' Create event
action_end = function(act) {
	
}
/// @function action_set(new_action, args)
/// @param {real} new_action Action value to set
/// @param {array} args Action-specific parameters
//Change action variable of a character while resetting action-related parameters
action_set = function(act, args=[]) {
	var debug_msg = ">> Instance of "+object_get_name(object_index)+" - ACTION CHANGE: "+string(action)+" -> "+string(act)
	show_debug_message(debug_msg)
	action_end(action)
	if (action != ACTCODE_CHARACTER.WAIT) action_previous = [action, action_parameters]
	action = act
	action_parameters = args
	action_phase = 0
	action_counter = 0
	action_cancel_ready = false
	action_init(action)
}

/// @function get_next_action()
//Returns [action_code, action_parameters] that will be used when action_next() is next called
get_next_action = function() { 
	if (array_length(action_queue) > 0) return action_queue[0] else return action_default
}

/// @function action_next()
// changes action to the next logical one determined by the action queue and default
action_next = function() {
	if (array_length(action_queue) > 0) {
		var _code, _args
		if (is_array(action_queue[0])) {
			_code = action_queue[0][0]
			_args = (array_length(action_queue[0]) > 1) ? action_queue[0][1] : undefined
		} else {
			_code = action_queue[0]
			_args = undefined
		}
		array_delete(action_queue,0,1)
		action_set(_code, _args)
	} else action_set(action_default)
}