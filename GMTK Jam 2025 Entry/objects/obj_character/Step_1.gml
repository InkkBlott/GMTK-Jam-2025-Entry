

//movement
m_grounded = (m_speed_y >= 0 and place_meeting(x, y + 1, m_collision_targets))
if (m_grounded and m_speed_y > 0) m_speed_y = 0
m_gravity_ignore = m_grounded

if (m_jumping and m_speed_y >= 0) m_jumping = false
m_gravity = m_jumping ? m_grav_jumping : m_grav_normal

// Inherit the parent event
event_inherited()