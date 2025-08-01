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
hp = 1
hp_max = 1

///@function jump()
jump = function() {
	m_speed_y = -m_jumpPower
	m_grounded = false
	m_jumping = true
}