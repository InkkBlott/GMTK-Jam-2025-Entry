if (action == ACTCODE_PLAYER.TETHER and tether.point_count > 0) {
	//render tether
	var _scale, _ang, _px, _py
	var _f = dsin(action_counter * 24)
	var _w = sprite_get_width(spr_fx_star) / 2
	var _star_color = make_color_hsv(40 + (3 * _f), 255, 255)
	var _clr
	for (var i=floor(action_counter/2)%2; i < tether.point_count; i+=2) {
		_clr = (tether.polygon != undefined and i >= tether.polygon_start_index and i <= tether.polygon_end_index) ? c_red : _star_color
		_scale = 0.6 + ((((i * 17) % 5) / 4) * 0.4)
		_ang = (i * 17) % 360
		_px = tether.getPointX(i)
		_py = tether.getPointY(i)
		if (rectangle_in_rectangle(_px - _w, _py - _w, _px + _w, _py + _w, 0, 0, room_width, room_height) != 0) draw_sprite_ext(spr_fx_star, 0, _px, _py, _scale, _scale, _ang, _clr, 1)
		if (_px + _w > room_width) draw_sprite_ext(spr_fx_star, 0, _px - room_width, _py, _scale, _scale, _ang, _clr, 1)
		if (_px - _w < 0) draw_sprite_ext(spr_fx_star, 0, _px + room_width, _py, _scale, _scale, _ang, _clr, 1)
	}
	if (global.devMode) { //draw tether polygon
		if (tether.polygon != undefined) {
			draw_set_color(c_lime)
			draw_primitive_begin(pr_linestrip)
			var _len = array_length(tether.polygon)
			for (var i=0; i<_len; i+=2) draw_vertex(tether.polygon[i], tether.polygon[i+1])
			draw_vertex(tether.polygon[0], tether.polygon[1])
			draw_primitive_end()
			draw_set_color(c_white)
		}
	}
	//draw_line_width(tether.getPointX(tether.point_count-1), tether.getPointY(tether.point_count-1), tether.x, tether.y, 3)
}
// Inherit the parent event
event_inherited();