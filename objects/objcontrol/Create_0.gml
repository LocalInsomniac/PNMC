draw_enable_drawevent(false)

var open_directory = working_directory
var save_directory = working_directory

while true {
	var input = get_open_filename_ext("SMF Model File|*.smf|BBMOD Model File|*.bbmod", "", open_directory, "Open a model file to convert");
	
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
	
	var output = get_save_filename_ext("Project Nightmare Model File|*.mdl|Project Nightmare Collision File|*.col", input_name, save_directory, "Save output")
	
	if output == "" {
		game_end()
		
		break
	}
	
	save_directory = filename_dir(output)
	
	switch filename_ext(input) {
		case ".smf":
			var input_buffer = buffer_load(input)
			var output_buffer = buffer_create(1, buffer_grow, 1)
			var size = buffer_get_size(input_buffer) * 0.025
			
			if filename_ext(output) == ".col" {
				var triangles = size / 3
				
				buffer_write(output_buffer, buffer_u32, triangles)
				
				var tri = array_create(9)
				
				repeat triangles {
					var i = 0
					
					repeat 3 {
						repeat 3 {
							tri[@ i] = buffer_read(input_buffer, buffer_f32);
							show_debug_message(tri[i]);
							++i
						}
					
						repeat 5 {
							buffer_read(input_buffer, buffer_f32)
						}
					
						repeat 8 {
							buffer_read(input_buffer, buffer_u8)
						}
					}
					
					var x1 = tri[0]
					var y1 = tri[1]
					var z1 = tri[2]
					var x2 = tri[3]
					var y2 = tri[4]
					var z2 = tri[5]
					var x3 = tri[6]
					var y3 = tri[7]
					var z3 = tri[8]
					
					buffer_write(output_buffer, buffer_f32, x1)
					buffer_write(output_buffer, buffer_f32, y1)
					buffer_write(output_buffer, buffer_f32, z1)
					buffer_write(output_buffer, buffer_f32, x2)
					buffer_write(output_buffer, buffer_f32, y2)
					buffer_write(output_buffer, buffer_f32, z2)
					buffer_write(output_buffer, buffer_f32, x3)
					buffer_write(output_buffer, buffer_f32, y3)
					buffer_write(output_buffer, buffer_f32, z3)
					
					// Get the position of B and C relative to A.
					var bx = x2 - x1
					var by = y2 - y1
					var bz = z2 - z1
					var cx = x3 - x1
					var cy = y3 - y1
					var cz = z3 - z1
					
				    // Get the normal of the triangle by using the normalized cross product.
					var cpx = by * cz - cy * bz
					var cpy = bz * cx - cz * bx
					var cpz = bx * cy - cx * by
					var d_inv = 1 / point_distance_3d(0, 0, 0, cpx, cpy, cpz)
					
					buffer_write(output_buffer, buffer_f32, cpx * d_inv)
					buffer_write(output_buffer, buffer_f32, cpy * d_inv)
					buffer_write(output_buffer, buffer_f32, cpz * d_inv)
					show_debug_message(string(cpx) + ", " + string(cpy) + ", " + string(cpz))
				}
			} else {
				repeat size {
					repeat 8 {
						buffer_write(output_buffer, buffer_f32, buffer_read(input_buffer, buffer_f32))
					}
				
					repeat 4 {
						buffer_write(output_buffer, buffer_u8, 255)
					}
				
					repeat 8 {
						buffer_write(output_buffer, buffer_u8, buffer_read(input_buffer, buffer_u8))
					}
				}
			}
			
			buffer_save(output_buffer, output)
			buffer_delete(input_buffer)
			buffer_delete(output_buffer)
		break
		
		case ".bbmod":
			
		break
		
		default:
			game_end()
			
			exit
		break
	}
}