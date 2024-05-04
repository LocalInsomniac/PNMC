function read_bbmod_vertex_format(_buffer) {
	gml_pragma("forceinline")
	
	var position = buffer_read(_buffer, buffer_bool),
		normals = buffer_read(_buffer, buffer_bool),
		uvs = buffer_read(_buffer, buffer_bool),
		uvs2 = buffer_read(_buffer, buffer_bool),
		colors = buffer_read(_buffer, buffer_bool),
		tangents = buffer_read(_buffer, buffer_bool),
		bones = buffer_read(_buffer, buffer_bool),
		ids = buffer_read(_buffer, buffer_bool)
	
	return {
		position,
		normals,
		uvs,
		uvs2,
		colors,
		tangents,
		bones,
		ids,
	}
}