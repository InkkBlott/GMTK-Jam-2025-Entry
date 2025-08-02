///@function dev_debugMessage(text)
function dev_debugMessage(txt) {
	global.dev_text += txt + "\n"
}

///@function point_distance_wrap(x1, y1, x2, y2)
function point_distance_wrap(x1, y1, x2, y2) {
	return min(point_distance(x1, y1, x2, y2), point_distance(x1, y1, x2 + room_width, y2), point_distance(x1 + room_width, y1, x2, y2))
}

/// @function line_intersection(x1,y1,x2,y2,x3,y3,x4,y4,[segment_only])
//
//  Returns a vector multiplier (t) for an intersection on the
//  first line. A value of (0 <= t <= 1) indicates an intersection 
//  within the line segment, a value of 0 indicates no intersection, 
//  other values indicate an intersection beyond the endpoints.
//
//      x1,y1,x2,y2     1st line segment
//      x3,y3,x4,y4     2nd line segment
//
//  By substitutin0g the return value (t) into the parametric form
//  of the first line, the point of intersection can be determined.
//  eg. x = x1 + t * (x2 - x1)
//      y = y1 + t * (y2 - y1)
//
// original function "lines_intersect()" from GMLscripts.com
// Modified by Dominic Hunter
/// GMLscripts.com/license
function line_intersection(x1,y1,x2,y2,x3,y3,x4,y4,segment=true) {
    var ua, ub, ud, ux, uy, vx, vy, wx, wy;
    ua = 0;
    ux = x2 - x1; //line A change in x
    uy = y2 - y1; //line A change in y
    vx = x4 - x3; //line B change in x
    vy = y4 - y3; //line B change in y
    wx = x1 - x3; //difference in x from point 1 of line B to point 1 of line A
    wy = y1 - y3; //difference in y from point 1 of line B to point 1 of line A
    ud = vy * ux - vx * uy;
    if (ud != 0) {
        ua = (vx * wy - vy * wx) / ud;
		if (segment) {
	        ub = (ux * wy - uy * wx) / ud;
	        if (ua < 0 || ua > 1 || ub < 0 || ub > 1) return false; //return false when checking segment and no overlap is found
		}
    }
	// if ua >= 0 and ua <= 1, the segments overlap
	return ua;
}

/// @function line_segments_intersect(x1,y1,x2,y2,x3,y3,x4,y4)
// Checks to see if each segment's points are on opposite sides of the other segment's line. If either segment has both points on the same side of the other line, return false.
function line_segments_intersect(l1x1,l1y1,l1x2,l1y2,l2x1,l2y1,l2x2,l2y2) {
	//if (abs(((ll1x2-ll1x1) * (py-ll1y1) / (ll1y2-ll1y1)) + ll1x1 - px) < 1) return true
	return ((((l2x2-l2x1) * (l1y1-l2y1) / (l2y2-l2y1)) + l2x1 - l1x1 > 0) != (((l2x2-l2x1) * (l1y2-l2y1) / (l2y2-l2y1)) + l2x1 - l1x2 > 0) and (((l1x2-l1x1) * (l2y1-l1y1) / (l1y2-l1y1)) + l1x1 - l2x1 > 0) != (((l1x2-l1x1) * (l2y2-l1y1) / (l1y2-l1y1)) + l1x1 - l2x2 > 0))
}

/// @function point_in_polygon(px,py,polygon)
//	polygon formatted as [x1, y1, x2, y2, ...], where the last point connects to the first.
function point_in_polygon(px,py,polygon) {
	var len = array_length(polygon)
	var count = 0
	var lx1,ly1,lx2,ly2
	for (var i=0; i<len; i+=2) {
		ly1 = polygon[i+1] 
		ly2 = (i != len-2) ? polygon[i+3] : polygon[1]
		if (ly1 == ly2) continue; //"raycast" won't hit horozontal lines. Also avoids dividing by 0
		lx1 = polygon[i]
		lx2 = (i != len-2) ? polygon[i+2] : polygon[0]
		if ((py <= ly1) != (py <= ly2) and px <= ((lx2-lx1) * (py-ly1) / (ly2-ly1)) + lx1) count ++
	}
	return (count % 2 == 1)
}

/// @function polygon_is_ccw(polygon)
///	@param {array} polygon Point list defining a polygon. Format [x1, y1, x2, y2, ...], where the last point connects to the first.
// Returns true if a polygon is counter-clockwise (ccw), false if it is clockwise
function polygon_is_ccw(polygon) {
	var poly_len = array_length(polygon)
	var edge_total = 0
	var point1x, point1y, point2x, point2y
	for (var i=0; i<poly_len; i+=2) {
		point1x = polygon[i]
		point1y = polygon[i + 1]
		if (i < poly_len-2) {
			point2x = polygon[i+2]
			point2y = polygon[i+3]
		} else {
			point2x = polygon[0]
			point2y = polygon[1]
		}
		edge_total += (point2x-point1x)*(point2y+point1y)
	}
	return (edge_total >= 0)
}

/// @function polygon_triangulate(polygon,ccw) {
///	@param {array} polygon Point list defining a polygon. Format [[x,y], [x,y], ...], where the last point connects to the first. Intersecting vectors will cause this method to fail and return an empty array.
///	@param {boolean} ccw Set true if the polygon's vertexes are listed in counter-clockwise winding order.
//	Reducs a polygon to a series of triangles. Useful for drawing polygons
//	Returns an array of triangles in [a,b,c] format. Each value points to an index of a vertex in the source polygon
function polygon_triangulate(polygon, counter_clockwise=false) {
	var vertex_list = []
	var poly_len = array_length(polygon)
	if (counter_clockwise) { for (var i=0; i<poly_len; i++) vertex_list[i] = poly_len-1-i }
	else { for (var i=0; i<poly_len; i++) vertex_list[i] = i }
	var acting_index,prev_index, next_index, acting_vert, prev_vert, next_vert, check_vert, list_len, pass
	var triangles = []
	var cycles = 0
	while (array_length(vertex_list) > 3) {
		list_len = array_length(vertex_list)
		for (acting_index=0; acting_index<list_len; acting_index++) {
			prev_index = (acting_index - 1 +list_len) % list_len
			next_index = (acting_index + 1) % list_len
			acting_vert = polygon[vertex_list[acting_index]]
			prev_vert = polygon[vertex_list[prev_index]]
			next_vert = polygon[vertex_list[next_index]]
			if (angle_difference(point_direction(acting_vert[0],acting_vert[1],next_vert[0],next_vert[1]),point_direction(acting_vert[0],acting_vert[1],prev_vert[0],prev_vert[1])) < 0) continue;
			pass = true
			for (var i=0; i<list_len; i++) {
				if (i == acting_index or i == prev_index or i == next_index) continue
				check_vert = polygon[vertex_list[i]]
				if (point_in_triangle(check_vert[0],check_vert[1],acting_vert[0],acting_vert[1],next_vert[0],next_vert[1],prev_vert[0],prev_vert[1])) {
					pass = false
					break;
				}
			}
			if (pass) {
				array_push(triangles,[vertex_list[acting_index],vertex_list[next_index],vertex_list[prev_index]])
				array_delete(vertex_list,acting_index,1)
				cycles = 0
				break;
			}
		}
		cycles ++
		if (cycles > array_length(vertex_list)) {
			if (polygon_is_ccw(polygon) != counter_clockwise) return polygon_triangulate(polygon, !counter_clockwise) else return []
		}
	}
	array_push(triangles,[vertex_list[0],vertex_list[1],vertex_list[2]])
	return triangles
}