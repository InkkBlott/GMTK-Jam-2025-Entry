// Inherit the parent event
event_inherited();

//movement
var _m = 0
if (keyboard_check(vk_left)) _m --
if (keyboard_check(vk_right)) _m ++

switch(_m) {
	case -1: 
		m_direction = MOVE_DIRECTION.LEFT;
		anisprite.face_direction = 180
		break;
	case 1: 
		m_direction = MOVE_DIRECTION.RIGHT; 
		anisprite.face_direction = 0
		break;
	default: 
		m_direction = MOVE_DIRECTION.NEUTRAL;
}
//jump
if (m_grounded and keyboard_check_pressed(vk_space)) {
	jump()
}
if (m_jumping and !keyboard_check(vk_space)) m_jumping = false