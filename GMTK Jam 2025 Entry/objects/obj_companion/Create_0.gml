// Inherit the parent event
event_inherited();

depth = DEPTH_LEVELS.COMPANION
//mask_index = noone
anisprite = new Anisprite("Companion", id)

m_gravity_ignore = true
m_collision_active = false
m_deceleration = 0
m_direction_h = DIRECTION.RIGHT
m_direction_v = DIRECTION.UP

tracking_pos_x = x
tracking_pos_y = y

action_init = function(act) {
	if (act == ACTCODE_CHARACTER.IDLE) {
		anisprite.set_anim(0)
		anisprite.angle = 0
	} else if (act == ACTCODE_COMPANION.TETHER) {
		anisprite.set_anim(1)
		m_speed_x = 0
		m_speed_y = 0
		anisprite.flipped_x = false
		depth = DEPTH_LEVELS.FOREGROUND
	}
}

action_end = function(act) {
	if (act == ACTCODE_COMPANION.TETHER) {
		depth = DEPTH_LEVELS.COMPANION
	}
}