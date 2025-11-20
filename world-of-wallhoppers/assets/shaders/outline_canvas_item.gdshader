shader_type canvas_item;

uniform bool active = false;
uniform vec3 outline_color: source_color;
uniform float outline_size = 1.0;
uniform bool use_diagonals = false;

const vec2[4] directions = { vec2(0.0, 1.0), vec2(0.0, -1.0), vec2(1.0, 0.0), vec2(-1.0, 0.0)};
const vec2[4] directions_diagonal = { vec2(1.0, 1.0), vec2(-1.0, -1.0), vec2(1.0, -1.0), vec2(-1.0, 1.0)};

void fragment() {
	vec2 uv = UV;
	if(active) {
		if(COLOR.a != 1.0) {
			for(int i = 0; i < 4; i++) {
				vec2 direction = directions[i];
				if(texture(TEXTURE, uv + (direction * outline_size)).a != 0.0) {
					COLOR.rgb = outline_color;
					COLOR.a = 1.0;
					break;
				}
			}
			if(COLOR.a != 1.0 && use_diagonals) {
				for(int i = 0; i < 4; i++) {
				vec2 direction = directions_diagonal[i];
				if(texture(TEXTURE, uv + (direction * outline_size)).a != 0.0) {
					COLOR.rgb = outline_color;
					COLOR.a = 1.0;
					break;
				}
			}
		}
	}
	}

}
