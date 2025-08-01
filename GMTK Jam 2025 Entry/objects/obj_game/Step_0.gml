//level wrap
with (obj_body) {
	if (x >= room_width or x < 0) {
		var _old_x = x
		while (x < 0) x += room_width //wrap to right side
		x %= room_width //wrap to left side
		if (global.game.camera.tracking_instance == id) global.game.camera.x += x - _old_x
	}
}