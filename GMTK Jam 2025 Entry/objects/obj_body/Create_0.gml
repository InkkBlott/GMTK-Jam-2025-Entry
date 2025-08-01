//graphics
anisprite = noone
anisprite_attached = true
depth = DEPTH_LEVELS.BACKGROUND

//movement
m_speed_x = 0
m_speed_y = 0
m_gravity = 0
m_gravity_ignore = false
m_direction = MOVE_DIRECTION.NEUTRAL
m_acceleration = 0
m_deceleration = 0
m_speedMax_x = 5
m_speedMax_y = 5
m_collision_active = false
m_collision_targets = noone
mask_index = msk_rect

///@function setCollisionMask(w, h)
setCollisionMask = function(w, h) {
	image_xscale = w / sprite_get_width(mask_index)
	image_yscale = h / sprite_get_height(mask_index)
}

///@function move(dx, dy)
move = function(_x, _y) {
	if (!m_collision_active) { x += _x; y += _y; return; }
		
	var _ang = point_direction(0, 0, _x, _y)
	var _dist = point_distance(0, 0, _x, _y)
	var _mx = dcos(_ang)
	var _my = -dsin(_ang)
	var _fail = 0
	var _n	
	repeat(floor(_dist)) {
		_fail = 0
		//movement checks for wrapping
		if (place_empty(x + _mx, y, m_collision_targets) and (bbox_left + _mx >= 0 or place_empty(x + room_width + _mx, y, m_collision_targets)) and (bbox_right + _mx < room_width or place_empty(x - room_width + _mx, y, m_collision_targets))) x += _mx else _fail ++
		if (place_empty(x, y + _my, m_collision_targets) and (bbox_left >= 0 or place_empty(x + room_width, y + _my, m_collision_targets)) and (bbox_right < room_width or place_empty(x - room_width, y + _my, m_collision_targets))) y += _my else _fail ++
		if (_fail == 2) break; //no X or Y movement
	}
	var _f = frac(_dist) //fractional movment
	if (_f == 0) return;
	_mx *= _f
	_my *= _f
	if (place_empty(x + _mx, y, m_collision_targets) and (bbox_left + _mx >= 0 or place_empty(x + room_width + _mx, y, m_collision_targets)) and (bbox_right + _mx < room_width or place_empty(x - room_width + _mx, y, m_collision_targets))) x += _mx
	if (place_empty(x, y + _my, m_collision_targets) and (bbox_left >= 0 or place_empty(x + room_width, y + _my, m_collision_targets)) and (bbox_right < room_width or place_empty(x - room_width, y + _my, m_collision_targets))) y += _my
}