// Inherit the parent event
event_inherited();
	
if (action == ACTCODE_CHARACTER.IDLE) {
	var _tx = tracking_pos_x
	if (abs(x - tracking_pos_x) > abs(x - tracking_pos_x + room_width)) { _tx -= room_width }
	else if (abs(x - tracking_pos_x) > abs(x - tracking_pos_x - room_width)) { _tx += room_width }
	m_direction_h = (x < _tx) ? DIRECTION.RIGHT : DIRECTION.LEFT
	m_direction_v = (y < tracking_pos_y) ? DIRECTION.DOWN : DIRECTION.UP
	var _tracking_dist = point_distance(x, y, _tx, tracking_pos_y)
	m_speedMax_x = 1 + min(_tracking_dist/25, 3)
	m_speedMax_y = m_speedMax_x
	m_acceleration = 0.05 + clamp((_tracking_dist/1000) - 0.02, 0, 0.1)
	if (facing_h != DIRECTION.RIGHT and x < _tx - 5) { facing_h = DIRECTION.RIGHT }
	else if (facing_h != DIRECTION.LEFT and x > _tx - 5) { facing_h = DIRECTION.LEFT }
	
	dev_debugMessage($"<<COM>>\[tracking] {_tx} ({tracking_pos_x}), {tracking_pos_y}")
} 
else if (action == ACTCODE_COMPANION.TETHER) {
	x = tracking_pos_x
	y = tracking_pos_y
	
	dev_debugMessage($"<<COM>>\[tracking] {tracking_pos_x}, {tracking_pos_y}")
}

