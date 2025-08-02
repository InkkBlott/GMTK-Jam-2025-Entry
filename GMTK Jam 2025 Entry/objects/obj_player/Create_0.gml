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
#macro TETHER_TURN_SPEED 4
tether = {
	x: 0,
	y: 0,
	points: [], //alternating x/y
	point_count: 0,
	polygon: undefined, //when defined: array with alternating x/y, last point connects to the first
	polygon_start_index: 0,
	polygon_end_index: 0,
	left_x: 0,
	right_x: 0,
	direction: 0,
	speed: 2,
	///@function addPosition()
	addPosition: function() {
		array_push(points, x, y)
		point_count ++
		if (point_count == 1) {
			left_x = x
			right_x = x
		} else {
			if (x < left_x) left_x = x
			if (x > right_x) right_x = x
		}
	},
	///@function move()
	move: function() {
		if (point_count == 0) addPosition()
		x += dcos(direction) * speed
		y -= dsin(direction) * speed
		//polygon generation (making a loop with the tether)
		if (point_distance(x, y, getPointX(point_count-1), getPointY(point_count-1)) >= TETHER_POINT_DISTANCE) {
			addPosition()
			if (polygon == undefined and point_count > 3) {
				var l1x1 = x
				var l1y1 = y
				var l1x2 = getPointX(point_count-2)
				var l1y2 = getPointY(point_count-2)
				var l2x1, l2y1, l2x2, l2y2
				for (var i=point_count-3; i>0; i--) {
					l2x1 = getPointX(i)
					l2y1 = getPointY(i)
					l2x2 = getPointX(i-1)
					l2y2 = getPointY(i-1)
					if (line_segments_intersect(l1x1,l1y1,l1x2,l1y2,l2x1,l2y1,l2x2,l2y2)) { //create poly
						polygon_start_index = i - 1
						polygon_end_index = point_count - 1
						polygon = array_create((point_count - i) * 2) //should be the number of points needed for the poly (x2 for interleaved coordinates)
						var intersection_multiplier = line_intersection(l1x1,l1y1,l1x2,l1y2,l2x1,l2y1,l2x2,l2y2)
						polygon[0] = lerp(l1x1, l1x2, intersection_multiplier) //point of collision
						polygon[1] = lerp(l1y1, l1y2, intersection_multiplier)
						var _ind
						for (var j=i; j<point_count-1; j++) {
							_ind = 2 + ((j - i) * 2)
							polygon[_ind] = getPointX(j)
							polygon[_ind + 1] = getPointY(j)
						}
						break;
					}
				}
			}
		}
	},
	///@function getPointX(point_index)
	getPointX: function(_ind) {
		return points[_ind * 2]
	},
	///@function getPointY(point_index)
	getPointY: function(_ind) {
		return points[(_ind * 2) + 1]
	},
	///@function getPointY(point_index)
	
	///@function reset()
	reset: function() {
		points = []
		point_count = 0
		polygon = undefined
		polygon_start_index = 0
		polygon_end_index = 0
		left_x = x
		right_x = x
	},
}

companion = instance_create_layer(x, y - 50, "lyr_instances", obj_companion)
companion_tracking_x = 0
companion_tracking_y = -15

//action
action_init = function(act) {
	if (act == ACTCODE_CHARACTER.IDLE) {
		anisprite.set_anim(0)
		companion.action_set(ACTCODE_CHARACTER.IDLE)
	}
	else if (act == ACTCODE_PLAYER.TETHER) {
		anisprite.set_anim(2)
		m_speed_x = 0
		m_speed_y = 0
		m_gravity_ignore = true
		tether.x = x
		tether.y = y
		if (facing_v == DIRECTION.UP) {
			tether.direction = 90
		} else if (facing_h == DIRECTION.RIGHT) {
			tether.direction = 0
		} else { //facing_h == DIRECTION.LEFT)
			tether.direction = 180
		}
		companion.action_set(ACTCODE_COMPANION.TETHER)
	}
}

action_end = function(act) {
	if (act == ACTCODE_CHARACTER.IDLE) {
		m_direction_h = DIRECTION.NEUTRAL;
	}
	else if (act == ACTCODE_PLAYER.TETHER) {
		tether.reset()
		m_gravity_ignore = false
	}
}