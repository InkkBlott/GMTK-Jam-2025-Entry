// Inherit the parent event
event_inherited();

//Action Process
if (action == ACTCODE_CHARACTER.IDLE) {
	//movement
	var _m = 0
	if (keyboard_check(vk_left)) _m --
	if (keyboard_check(vk_right)) _m ++

	switch(_m) {
		case -1: 
			m_direction_h = DIRECTION.LEFT
			facing_h = DIRECTION.LEFT
			break;
		case 1: 
			m_direction_h = DIRECTION.RIGHT
			facing_h = DIRECTION.RIGHT
			break;
		default:
			m_direction_h = DIRECTION.NEUTRAL
	}
	//vertical facing
	_m = 0
	if (keyboard_check(vk_up)) _m --
	if (keyboard_check(vk_down)) _m ++

	switch(_m) {
		case -1:
			facing_v = DIRECTION.UP
			break;
		case 1:
			facing_v = DIRECTION.DOWN
			break;
		default:
			facing_v = DIRECTION.NEUTRAL
	}
	//jump
	if (m_grounded and keyboard_check_pressed(vk_space)) jump()
	if (m_jumping and !keyboard_check(vk_space)) m_jumping = false
	//companion
	if (action_counter >= 120) {
		action_counter = 0
		companion_tracking_x = random_range(-10, 10)
		companion_tracking_y = random_range(-20, -10)
	}
	companion.tracking_pos_x = x + companion_tracking_x
	companion.tracking_pos_y = y + companion_tracking_y
	//counter
	action_counter ++
}
else if (action == ACTCODE_PLAYER.TETHER) {
	//tether control
	var _mh = 0
	var _mv = 0
	if (keyboard_check(vk_left)) _mh --
	if (keyboard_check(vk_right)) _mh ++
	if (keyboard_check(vk_up)) _mv --
	if (keyboard_check(vk_down)) _mv ++
	var _inp_dir = (_mh != 0 or _mv != 0) ? point_direction(0, 0, _mh, _mv) : undefined
	if (_inp_dir != undefined) {
		tether.direction += clamp(angle_difference(_inp_dir, tether.direction), -TETHER_TURN_SPEED, TETHER_TURN_SPEED)
	}
	tether.move()
	//item pickup
	if (tether.polygon != undefined and action_phase == 0) {
		action_phase = 1
		var _p = tether.polygon
		var _left = tether.left_x
		var _right = tether.right_x
		with(obj_item) {
			if (point_in_polygon(x, y, _p) or (_left < 0 and point_in_polygon(x - room_width, y, _p)) or (_right > room_width and point_in_polygon(x + room_width, y, _p))) instance_destroy(id) //[DEV] Temporary until actual interaction is figured out
		}
	}
	//companion
	companion.tracking_pos_x = tether.x
	companion.tracking_pos_y = tether.y
	companion.anisprite.angle = tether.direction
	//counter
	action_counter ++
}

//Action Set
if (action == ACTCODE_CHARACTER.IDLE and keyboard_check_pressed(ord("X"))) {
	action_set(ACTCODE_PLAYER.TETHER)
}
//else if (action == ACTCODE_PLAYER.TETHER and keyboard_check_pressed(ord("X"))) {
else if (action == ACTCODE_PLAYER.TETHER and (keyboard_check_pressed(ord("X")) or action_counter >= 720)) {
	action_set(action_default)
}