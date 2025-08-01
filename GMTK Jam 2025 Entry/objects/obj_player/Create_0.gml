global.game.player = id

//inherit
event_inherited()

//graphics
anisprite = new Anisprite("Alchemist", id)
depth = DEPTH_LEVELS.PLAYER

//movement
setCollisionMask(10, 14)

//combat
c_hp_max = 10
c_hp = 10

//tether
#macro TETHER_POINT_DISTANCE 10
#macro TETHER_TURN_SPEED 3
tether = {
	x: 0,
	y: 0,
	points: [], //alternating x/y
	point_count: 0,
	direction: 0,
	speed: 1.5,
	///@function addPosition()
	addPosition: function() {
		array_push(points, x, y)
		point_count ++
	},
	///@function move()
	move: function() {
		if (point_count == 0) addPosition()
		x += dcos(direction) * speed
		y -= dsin(direction) * speed
		if (point_distance(x, y, getPointX(point_count-1), getPointY(point_count-1)) >= TETHER_POINT_DISTANCE) addPosition()
	},
	///@function getPointX(point_index)
	getPointX: function(_ind) {
		return points[_ind * 2]
	},
	///@function getPointY(point_index)
	getPointY: function(_ind) {
		return points[(_ind * 2) + 1]
	},
	///@function reset()
	reset: function() {
		points = []
		point_count = 0
	},
}

//action
action_init = function(act) {
	if (act == ACTCODE_CHARACTER.IDLE) {
		anisprite.set_anim(0)
	}
	else if (act == ACTCODE_PLAYER.TETHER) {
		tether.x = x
		tether.y = y
		anisprite.set_anim(2)
		m_speed_x = 0
		m_speed_y = 0
		m_gravity_ignore = true
		if (facing_v == DIRECTION.UP) {
			tether.direction = 90
		} else if (facing_h == DIRECTION.RIGHT) {
			tether.direction = 0
		} else { //facing_h == DIRECTION.LEFT)
			tether.direction = 180
		}
	}
}

action_end = function(act) {
	if (act == ACTCODE_CHARACTER.IDLE) {
		m_direction = DIRECTION.NEUTRAL;
	}
	else if (act == ACTCODE_PLAYER.TETHER) {
		tether.reset()
		m_gravity_ignore = false
	}
}