

//movement
if (m_jumping and m_speed_y >= 0) m_jumping = false
m_gravity = m_jumping ? m_grav_jumping : m_grav_normal

// Inherit the parent event
event_inherited()