draw_enable_drawevent(false)

var open_directory = working_directory

while true {
	var input = get_open_filename_ext("SMF 1.0 Model File|*.smf|BBMOD Model File|*.bbmod", "", open_directory, "Open a model file to convert");
	
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
	
	var output = get_save_filename_ext("Project Nightmare Model File|*.mdl|Project Nightmare Collision File|*.col", input_name, filename_dir(input), "Save output")
	
	if output == "" {
		game_end()
		
		break
	}
	
	switch filename_ext(input) {
		case ".smf":
			var input_buffer = buffer_load(input)
			var output_buffer = buffer_create(1, buffer_grow, 1)
			var size = buffer_get_size(input_buffer) * 0.025
			
			if filename_ext(output) == ".col" {
				repeat size {
					repeat 3 {
						buffer_write(output_buffer, buffer_f32, buffer_read(input_buffer, buffer_f32))
						// TODO: Bake normals into collision mesh for faster loading
					}
					
					repeat 5 {
						buffer_read(input_buffer, buffer_f32)
					}
					
					repeat 8 {
						buffer_read(input_buffer, buffer_u8)
					}
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