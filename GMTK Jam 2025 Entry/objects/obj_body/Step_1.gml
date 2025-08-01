//movement
switch(m_direction) {
	case DIRECTION.LEFT:
		if (m_speed_x > 0) m_speed_x -= min(m_speed_x, m_deceleration)
		m_speed_x -= m_acceleration
		break;
	case DIRECTION.RIGHT:
		if (m_speed_x < 0) m_speed_x += min(-m_speed_x, m_deceleration)
		m_speed_x += m_acceleration
		break;
	case DIRECTION.UP:
		if (m_speed_y > 0) m_speed_y -= min(m_speed_y, m_deceleration)
		m_speed_y -= m_acceleration
		break;
	case DIRECTION.DOWN:
		if (m_speed_x < 0) m_speed_y += min(-m_speed_y, m_deceleration)
		m_speed_y += m_acceleration
		break;
	default: //DIRECTION.NEUTRAL
		if (m_speed_x != 0) m_speed_x -= min(m_deceleration, abs(m_speed_x)) * sign(m_speed_x)
		if (m_speed_y != 0 and (m_gravity == 0 or m_gravity_ignore)) m_speed_y -= min(m_deceleration, abs(m_speed_y)) * sign(m_speed_y)
}

if (!m_gravity_ignore and m_direction != DIRECTION.UP and m_direction != DIRECTION.DOWN) m_speed_y += m_gravity_temp ?? m_gravity

m_speed_x = clamp(m_speed_x, -m_speedMax_x, m_speedMax_x)
m_speed_y = clamp(m_speed_y, -m_speedMax_y, m_speedMax_y)

if (m_collision_active) {
	//move_and_collide(m_speed_x, m_speed_y, m_collision_targets, point_distance(0, 0, m_speed_x, m_speed_y), undefined, undefined, m_speedMax_x, m_speedMax_y)
	move(m_speed_x, m_speed_y)
} else {
	x += m_speed_x
	y += m_speed_y
}