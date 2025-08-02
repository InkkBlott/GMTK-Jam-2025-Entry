//movement
switch(m_direction_h) {
	case DIRECTION.LEFT:
		if (m_speed_x > 0) m_speed_x -= min(m_speed_x, m_deceleration)
		m_speed_x -= m_acceleration
		break;
	case DIRECTION.RIGHT:
		if (m_speed_x < 0) m_speed_x += min(-m_speed_x, m_deceleration)
		m_speed_x += m_acceleration
		break;
	default: //DIRECTION.NEUTRAL
		if (m_speed_x != 0) m_speed_x -= min(m_deceleration, abs(m_speed_x)) * sign(m_speed_x)
}
switch(m_direction_v) {
	case DIRECTION.UP:
		if (m_speed_y > 0) m_speed_y -= min(m_speed_y, m_deceleration)
		m_speed_y -= m_acceleration
		break;
	case DIRECTION.DOWN:
		if (m_speed_y < 0) m_speed_y += min(-m_speed_y, m_deceleration)
		m_speed_y += m_acceleration
		break;
	default: //DIRECTION.NEUTRAL
	if (m_speed_y != 0 and (m_gravity == 0 or m_gravity_ignore)) m_speed_y -= min(m_deceleration, abs(m_speed_y)) * sign(m_speed_y)
}
//gravity
m_grounded = (!m_gravity_ignore and m_speed_y >= 0 and (place_meeting(x, y + 1, m_collision_targets) or (bbox_left < 0 and place_meeting(x + room_width, y + 1, m_collision_targets)) or (bbox_right > room_width and place_meeting(x - room_width, y + 1, m_collision_targets))))
if (m_grounded and m_speed_y > 0) m_speed_y = 0
if (m_grounded and m_gravity_temp != undefined) m_gravity_temp = undefined
if (!m_gravity_ignore and !m_grounded and m_direction_v == DIRECTION.NEUTRAL) m_speed_y += m_gravity_temp ?? m_gravity
//motion
m_speed_x = clamp(m_speed_x, -m_speedMax_x, m_speedMax_x)
m_speed_y = clamp(m_speed_y, -m_speedMax_y, m_speedMax_y)

if (m_speed_x != 0 or m_speed_y != 0) move(m_speed_x, m_speed_y)