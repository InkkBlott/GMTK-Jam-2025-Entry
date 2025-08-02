// Inherit the parent event
event_inherited();

if (anisprite != noone) {
	var _mx = 0
	var _my = 0
	switch (facing_h) {
		case DIRECTION.LEFT :
			_mx = -1; break;
		case DIRECTION.RIGHT :
			_mx = 1; break;
	}
	switch (facing_v) {
		case DIRECTION.UP :
			_my = -3; break;
		case DIRECTION.DOWN :
			_my = 3; break;
	}
	anisprite.face_direction = point_direction(0, 0, _mx, _my)
}