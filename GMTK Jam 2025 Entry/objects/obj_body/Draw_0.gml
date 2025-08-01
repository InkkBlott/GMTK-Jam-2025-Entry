if (anisprite != noone) {
	anisprite.draw()
	var _off = anisprite.get_draw_offset()[0]
	var _w = sprite_get_width(anisprite.current_asset()[0]) / 2
	if (anisprite.x + _off - _w < 0) anisprite.draw(anisprite.x + room_width, undefined)
	if (anisprite.x + _off + _w >= room_width) anisprite.draw(anisprite.x - room_width, undefined)
	//_off = sprite_get_bbox_right(_spr)
	//_spr = false
	//anisprite.draw(anisprite.x - room_width, undefined)
	//anisprite.draw(anisprite.x + room_width, undefined)
		
}