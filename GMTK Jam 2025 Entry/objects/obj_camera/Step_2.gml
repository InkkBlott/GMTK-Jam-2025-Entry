//tracking
if (instance_exists(tracking_instance)) {
	tracking_pos_x = tracking_instance.x
	tracking_pos_y = tracking_instance.y
}
if (x != tracking_pos_x) {
	if (abs(x - tracking_pos_x) < 1) x = tracking_pos_x else x = lerp(x, tracking_pos_x, tracking_speed)
}
if (y != tracking_pos_y) {
	if (abs(y - tracking_pos_y) < 1) y = tracking_pos_y else y = lerp(y, tracking_pos_y, tracking_speed)
}

//view control
display_raw_x = x - (width / 2)
display_raw_y = y - (height / 2)
display_x = clamp(display_raw_x, 0, room_width - width)
display_y = clamp(display_raw_y, 0, room_height - height)

//level display wrap
if (display_raw_x < display_x) { //wrap left
	if (wrap_mode != VIEW_WRAP_MODE.LEFT) wrap_mode = VIEW_WRAP_MODE.LEFT
	if (!view_get_visible(1)) view_set_visible(1, true)
	var wrap_factor_1 = (display_x - display_raw_x) / width
	var wrap_factor_2 = 1 - wrap_factor_1
	camera_set_view_pos(view_camera[0], display_x, display_y)
	camera_set_view_pos(view_camera[1], room_width - (width * wrap_factor_1), display_y)
	camera_set_view_size(view_camera[1], width * wrap_factor_1, height)
	camera_set_view_size(view_camera[0], width * wrap_factor_2, height)
	view_set_wport(1, global.game.width * wrap_factor_1)
	view_set_wport(0, global.game.width * wrap_factor_2)
	view_set_xport(1, 0)
	view_set_xport(0, global.game.width * wrap_factor_1)
} else if (display_raw_x > display_x) { //wrap right
	if (wrap_mode != VIEW_WRAP_MODE.RIGHT) wrap_mode = VIEW_WRAP_MODE.RIGHT
	if (!view_get_visible(1)) view_set_visible(1, true)
	var wrap_factor_1 = (display_raw_x - display_x) / width
	var wrap_factor_2 = 1 - wrap_factor_1
	camera_set_view_pos(view_camera[0], display_x + (width * wrap_factor_1), display_y)
	camera_set_view_pos(view_camera[1], 0, display_y)
	camera_set_view_size(view_camera[1], width * wrap_factor_1, height)
	camera_set_view_size(view_camera[0], width * wrap_factor_2, height)
	view_set_wport(1, global.game.width * wrap_factor_1)
	view_set_wport(0, global.game.width * wrap_factor_2)
	view_set_xport(1, global.game.width * wrap_factor_2)
	view_set_xport(0, 0)
} else { //no wrap
	if (wrap_mode != VIEW_WRAP_MODE.NONE) wrap_mode = VIEW_WRAP_MODE.NONE
	if (view_get_visible(1)) view_set_visible(1, false)
	camera_set_view_pos(view_camera[0], display_x, display_y)
	if (camera_get_view_width(view_camera[0]) != width) camera_set_view_size(view_camera[0], width, height)
	if (view_xport[0] != 0) view_xport[0] = 0
	if (view_wport[0] != global.game.width) view_wport[0] = global.game.width
}

//backdrop parallax scrolling
scroll_factor_x = x / room_width
scroll_factor_y = display_y / (room_height - height)
//[DEV] using the proper background_layer handle in the layer_x/layer_y functions does not work right now for some reason
layer_x("lyr_backdrop", scroll_factor_x * backdrop_width)
layer_y("lyr_backdrop", display_y - (scroll_factor_y * (backdrop_height - height)))