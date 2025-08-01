if (action == ACTCODE_PLAYER.TETHER and tether.point_count > 0) {
	draw_set_color(c_red)
	for (var i=1; i < tether.point_count; i++) {
		draw_line_width(tether.getPointX(i-1), tether.getPointY(i-1), tether.getPointX(i), tether.getPointY(i), 3)
	}
	draw_line_width(tether.getPointX(tether.point_count-1), tether.getPointY(tether.point_count-1), tether.x, tether.y, 3)
	draw_set_color(c_white)
}
// Inherit the parent event
event_inherited();