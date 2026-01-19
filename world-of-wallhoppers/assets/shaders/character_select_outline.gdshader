shader_type canvas_item;

uniform vec3 outline_color: source_color;
uniform float outline_size = 1.0;
uniform bool use_diagonals = false;
uniform bool use_billboard = false;

const vec2[4] directions = { vec2(0.0, 1.0), vec2(0.0, -1.0), vec2(1.0, 0.0), vec2(-1.0, 0.0)};
const vec2[4] directions_diagonal = { vec2(1.0, 1.0), vec2(-1.0, -1.0), vec2(1.0, -1.0), vec2(-1.0, 1.0)};

uniform vec3[2] colors: source_color;
uniform sampler2D noise: repeat_enable;
uniform float noise_scale = 1.0;
uniform bool selected = false;

void fragment() {
	vec2 uv = UV;
	vec4 sample = texture(TEXTURE, uv);

	vec2 offset = vec2(TIME / 7.0, 0);
	float value = texture(noise, UV * noise_scale + offset).r;
	vec3 out_color = outline_color;
	float out_size = outline_size;
	if(selected) {
		out_size *= 2.0;
		if(value > 0.5) {
			out_color.rgb = colors[0];
		} else {
			out_color.rgb = colors[1];
		}
	}


	if(sample.a != 1.0) {
		for(int i = 0; i < 4; i++) {
			vec2 direction = directions[i];
			if(texture(TEXTURE, uv + (direction * out_size * TEXTURE_PIXEL_SIZE)).a != 0.0) {
				COLOR.rgb = out_color;
				COLOR.a = 1.0;
				break;
			}
		}
		if(COLOR.a != 1.0 && use_diagonals) {
			for(int i = 0; i < 4; i++) {
			vec2 direction = directions_diagonal[i];
			if(texture(TEXTURE, uv + (direction * out_size * TEXTURE_PIXEL_SIZE)).a != 0.0) {
				COLOR.rgb = out_color;
				COLOR.a = 1.0;
				break;
			}
		}
		}
	}
}