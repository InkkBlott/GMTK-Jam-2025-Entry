global.game.camera = id

width = camera_get_view_width(view_camera[0])
height = camera_get_view_height(view_camera[0])

backdrop_layer = noone
backdrop_width = 0
backdrop_height = 0

display_raw_x = x - (width / 2)
display_raw_y = y - (height / 2)
display_x = display_raw_x
display_y = display_raw_y
scroll_factor_x = 0
scroll_factor_y = 0
tracking_pos_x = x
tracking_pos_y = y
tracking_instance = noone
tracking_speed = 0.2 //lerp factor between current coordinates and tracking position

enum VIEW_WRAP_MODE { NONE, LEFT, RIGHT }
wrap_mode = VIEW_WRAP_MODE.NONE