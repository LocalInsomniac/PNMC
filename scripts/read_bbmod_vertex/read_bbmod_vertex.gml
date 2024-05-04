function read_bbmod_vertex(_buffer, _format) {
	var position
	
	if _format.position {
		var _x = buffer_read(_buffer, buffer_f32)
		var _y = buffer_read(_buffer, buffer_f32)
		var _z = buffer_read(_buffer, buffer_f32)
		
		position = [_x, _y, _z]
	} else {
		position = [0, 0, 0]
	}
	
	var normals
	
	if _format.normals {
		var _x = buffer_read(_buffer, buffer_f32)
		var _y = buffer_read(_buffer, buffer_f32)
		var _z = buffer_read(_buffer, buffer_f32)
		
		normals = [_x, _y, _z]
	} else {
		normals = [0, 0, -1]
	}
	
	var uvs
	
	if _format.uvs {
		var _u = buffer_read(_buffer, buffer_f32)
		var _v = buffer_read(_buffer, buffer_f32)
		
		uvs = [_u, _v]
	} else {
		uvs = [0, 0]
	}
	
	var uvs2
	
	if _format.uvs2 {
		var _u = buffer_read(_buffer, buffer_f32)
		var _v = buffer_read(_buffer, buffer_f32)
		
		uvs2 = [_u, _v]
	} else {
		uvs2 = [0, 0]
	}
	
	var colors
	
	if _format.colors {
		var _r = buffer_read(_buffer, buffer_u8)
		var _g = buffer_read(_buffer, buffer_u8)
		var _b = buffer_read(_buffer, buffer_u8)
		var _a = buffer_read(_buffer, buffer_u8)
		
		colors = [_r, _g, _b, _a]
	} else {
		colors = [255, 255, 255, 255]
	}
	
	var tangents
	
	if _format.tangents {
		var _x = buffer_read(_buffer, buffer_f32)
		var _y = buffer_read(_buffer, buffer_f32)
		var _z = buffer_read(_buffer, buffer_f32)
		var _w = buffer_read(_buffer, buffer_f32)
		
		tangents = [_x, _y, _z, _w]
	} else {
		tangents = [0, 0, 0, 0]
	}
	
	var bone_indices, bone_weights
	
	if _format.bones {
		var _i1 = buffer_read(_buffer, buffer_f32)
		var _i2 = buffer_read(_buffer, buffer_f32)
		var _i3 = buffer_read(_buffer, buffer_f32)
		var _i4 = buffer_read(_buffer, buffer_f32)
		
		bone_indices = [_i1, _i2, _i3, _i4]
		
		var _w1 = buffer_read(_buffer, buffer_f32)
		var _w2 = buffer_read(_buffer, buffer_f32)
		var _w3 = buffer_read(_buffer, buffer_f32)
		var _w4 = buffer_read(_buffer, buffer_f32)
		
		bone_weights = [_w1, _w2, _w3, _w4]
	} else {
		bone_indices = [0, 0, 0, 0]
		bone_weights = [0, 0, 0, 0]
	}
	
	var index = _format.ids ? buffer_read(_buffer, buffer_f32) : 0
	
	return {
		position,
		normals,
		uvs,
		uvs2,
		colors,
		tangents,
		bone_indices,
		bone_weights,
		index,
	}
}