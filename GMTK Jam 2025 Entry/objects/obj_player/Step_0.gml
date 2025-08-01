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
			m_direction = DIRECTION.LEFT;
			facing_h = DIRECTION.LEFT
			anisprite.face_direction = 180
			break;
		case 1: 
			m_direction = DIRECTION.RIGHT; 
			facing_h = DIRECTION.RIGHT
			anisprite.face_direction = 0
			break;
		default: 
			m_direction = DIRECTION.NEUTRAL;
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
			facing_v = DIRECTION.NEUTRAL;
	}
	//jump
	if (m_grounded and keyboard_check_pressed(vk_space)) {
		jump()
	}
	if (m_jumping and !keyboard_check(vk_space)) m_jumping = false
}
else if (action == ACTCODE_PLAYER.TETHER) {
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
}

//Action Set
if (action == ACTCODE_CHARACTER.IDLE and keyboard_check_pressed(ord("X"))) {
	action_set(ACTCODE_PLAYER.TETHER)
}
else if (action == ACTCODE_PLAYER.TETHER and keyboard_check_pressed(ord("X"))) {
	action_set(action_default)
}