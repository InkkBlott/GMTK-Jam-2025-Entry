if (instance_number(object_index) > 1) { //cancel if this object is a duplicate
	instance_destroy()
	exit;
}

persistent = true
global.game = id

global.devMode = true //[DEV] turn off in release candidate

width = 800
height = 600
window_set_size(width, height)

collision_layer = noone

player = noone
camera = noone