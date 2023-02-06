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
				
				if not buffer_read(input_buffer, buffer_bool) {
					show_message(input + " has no vertex positions!")
					buffer_delete(input_buffer)
					
					break
				}
				
				if not buffer_read(input_buffer, buffer_bool) {
					show_message(input + " has no normals!")
					buffer_delete(input_buffer)
					
					break
				}
				
				var has_uvs = buffer_read(input_buffer, buffer_bool)
				var has_secondary_uvs = buffer_read(input_buffer, buffer_bool)
				var has_colors = buffer_read(input_buffer, buffer_bool)
				var has_tangents = buffer_read(input_buffer, buffer_bool)
				var has_bones = buffer_read(input_buffer, buffer_bool)
				var has_ids = buffer_read(input_buffer, buffer_bool)
				
				buffer_read(input_buffer, buffer_f32)
				
				var vertices = buffer_read(input_buffer, buffer_u32)
				var output_buffer = buffer_create(1, buffer_grow, 1)
				
				repeat vertices {
					var _x = buffer_read(input_buffer, buffer_f32)
					var _y = -buffer_read(input_buffer, buffer_f32)
					var _z = -buffer_read(input_buffer, buffer_f32)
					
					buffer_write(output_buffer, buffer_f32, _x)
					buffer_write(output_buffer, buffer_f32, _y)
					buffer_write(output_buffer, buffer_f32, _z)
					
					var _nx = buffer_read(input_buffer, buffer_f32)
					var _ny = -buffer_read(input_buffer, buffer_f32)
					var _nz = -buffer_read(input_buffer, buffer_f32)
					
					buffer_write(output_buffer, buffer_f32, _nx)
					buffer_write(output_buffer, buffer_f32, _ny)
					buffer_write(output_buffer, buffer_f32, _nz)
					
					if has_uvs {
						var _u = buffer_read(input_buffer, buffer_f32)
						var _v = 1 - buffer_read(input_buffer, buffer_f32)
					
						buffer_write(output_buffer, buffer_f32, _u)
						buffer_write(output_buffer, buffer_f32, _v)
					} else {
						repeat 2 {
							buffer_write(output_buffer, buffer_f32, 0)
						}
					}
					
					if has_secondary_uvs {
						repeat 2 {
							buffer_read(input_buffer, buffer_f32)
						}
					}
					
					if has_colors {
						var _r = buffer_read(input_buffer, buffer_u8)
						var _g = buffer_read(input_buffer, buffer_u8)
						var _b = buffer_read(input_buffer, buffer_u8)
						var _a = buffer_read(input_buffer, buffer_u8)
						
						buffer_write(output_buffer, buffer_u8, _r)
						buffer_write(output_buffer, buffer_u8, _g)
						buffer_write(output_buffer, buffer_u8, _b)
						buffer_write(output_buffer, buffer_u8, _a)
					} else {
						repeat 4 {
							buffer_write(output_buffer, buffer_u8, 255)
						}
					}
					
					if has_tangents {
						repeat 4 {
							buffer_read(input_buffer, buffer_f32)
						}
					}
					
					if has_bones {
						repeat 8 {
							buffer_read(input_buffer, buffer_f32)
						}
					}
					
					if has_ids {
						buffer_read(input_buffer, buffer_f32)
					}
					
					repeat 8 {
						buffer_write(output_buffer, buffer_u8, 255)
					}
				}
				
				var final_output = output_name + "_" + string(material_index) + ".mdl"
				
				show_debug_message(final_output)
				buffer_save(output_buffer, final_output)
				buffer_delete(output_buffer)
			}
			
			buffer_delete(input_buffer)
		break
		
		default:
			game_end()
			
			exit
		break
	}
}