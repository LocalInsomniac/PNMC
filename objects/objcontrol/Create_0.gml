draw_enable_drawevent(false)

var open_directory = working_directory
var save_directory = working_directory

while true {
	var input = get_open_filename_ext("BBMOD Model File|*.bbmod", "", open_directory, "Open a model file to convert");
	
	if input == "" {
		game_end()
		
		break
	}
	
	open_directory = filename_dir(input)
	
	var input_name = filename_name(input)
	var pos = string_length(input_name)
	
	while pos > 1 {
	    if string_char_at(input_name, pos) == "." {
	        input_name = string_copy(input_name, 1, pos - 1)
			
	        break
	    }
		
	    --pos
	}
	
	var output = get_save_filename_ext("PNEngine Collision File|*.col", input_name, save_directory, "Save output")
	
	if output == "" {
		game_end()
		
		break
	}
	
	save_directory = filename_dir(output)
	
	switch filename_ext(input) {
		case ".bbmod":
			var input_buffer = buffer_load(input)
			var output_file_name = filename_name(output)
			var output_name = filename_path(output) + string_copy(output_file_name, 1, string_length(output_file_name) - 4)
			
			// Header
			var header = buffer_read(input_buffer, buffer_string)
			var has_minor_version = header == "BBMOD"
			
			if header != "bbmod" and not has_minor_version {
				show_message(input + " has an invalid file format!")
				buffer_delete(input_buffer)
				
				break
			}
			
			buffer_read(input_buffer, buffer_u8)
			
			if has_minor_version {
				if buffer_read(input_buffer, buffer_u8) < 3 {
					show_message(input + " has outdated minor version!")
					buffer_delete(input_buffer)
				
					break
				}
			}
			
			var meshes = buffer_read(input_buffer, buffer_u32)
			
			show_debug_message("Found " + string(meshes) + " meshes")
			
			repeat meshes {
				var material_index = buffer_read(input_buffer, buffer_u32)
				
				repeat 6 {
					buffer_read(input_buffer, buffer_f32)
				}
				
				var _format = read_bbmod_vertex_format(input_buffer)
				
				if not _format.position {
					show_message(input + " has no vertex positions!")
					buffer_delete(input_buffer)
					
					break
				}
				
				buffer_read(input_buffer, buffer_f32)
				
				var _triangles = buffer_read(input_buffer, buffer_u32) div 3
				var output_buffer = buffer_create(1, buffer_grow, 1)
				
				buffer_write(output_buffer, buffer_string, "PNECOL")
				buffer_write(output_buffer, buffer_u32, _triangles)
				
				repeat _triangles {
					var _v1 = read_bbmod_vertex(input_buffer, _format)
					var _v2 = read_bbmod_vertex(input_buffer, _format)
					var _v3 = read_bbmod_vertex(input_buffer, _format)
					
					var _tp1 = _v1.position
					var _tx1 = _tp1[0]
					var _ty1 = _tp1[1]
					var _tz1 = _tp1[2]
					
					var _tp2 = _v2.position
					var _tx2 = _tp2[0]
					var _ty2 = _tp2[1]
					var _tz2 = _tp2[2]
					
					var _tp3 = _v3.position
					var _tx3 = _tp3[0]
					var _ty3 = _tp3[1]
					var _tz3 = _tp3[2]
					
					// Get the position of B and C relative to A.
					var _ax = _tx2 - _tx1
					var _ay = _ty2 - _ty1
					var _az = _tz2 - _tz1
					var _bx = _tx3 - _tx1
					var _by = _ty3 - _ty1
					var _bz = _tz3 - _tz1
					
				    // Get the normal of the triangle by using the normalized cross product.
					var _cpx = _ay * _bz - _az * _by
					var _cpy = _az * _bx - _ax * _bz
					var _cpz = _ax * _by - _ay * _bx
					var d = 1 / point_distance_3d(0, 0, 0, _cpx, _cpy, _cpz)
					
					_cpx *= d
					_cpy *= d
					_cpz *= d
					
					buffer_write(output_buffer, buffer_f32, _tx1)
					buffer_write(output_buffer, buffer_f32, _ty1)
					buffer_write(output_buffer, buffer_f32, _tz1)
					buffer_write(output_buffer, buffer_f32, _tx2)
					buffer_write(output_buffer, buffer_f32, _ty2)
					buffer_write(output_buffer, buffer_f32, _tz2)
					buffer_write(output_buffer, buffer_f32, _tx3)
					buffer_write(output_buffer, buffer_f32, _ty3)
					buffer_write(output_buffer, buffer_f32, _tz3)
					buffer_write(output_buffer, buffer_f32, _cpx)
					buffer_write(output_buffer, buffer_f32, _cpy)
					buffer_write(output_buffer, buffer_f32, _cpz)
				}
				
				var _final_output = output_name + "_" + string(material_index) + ".col"
				
				show_debug_message(_final_output)
				buffer_save(output_buffer, _final_output)
				buffer_delete(output_buffer)
			}
			
			buffer_delete(input_buffer)
		break
		
		default:
			game_end()
			
			exit
	}
}