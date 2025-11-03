shader_type canvas_item;

uniform vec3 color: source_color = vec3(1.0);
uniform bool active = false;
uniform vec3 fill_color: source_color = vec3(0.5);
uniform vec3 unselected_fill: source_color = vec3(0.2);
uniform sampler2D source: hint_screen_texture, filter_nearest;
uniform int pixel_scale = 2;

const vec2[4] directions = { vec2(0.0, 1.0), vec2(0.0, -1.0), vec2(1.0, 0.0), vec2(-1.0, 0.0)};

void fragment() {
	COLOR = texture(source, SCREEN_UV);
	if(active) {
		if(COLOR.rgb != vec3(0.0)) {
			COLOR.rgb = color;
		} else {
			COLOR.rgb = fill_color;
		}
		if(COLOR.a != 1.0) {
			for(int i = 0; i < 4; i++) {
			vec2 direction = directions[i];
				if(texture(source, SCREEN_UV + (direction * SCREEN_PIXEL_SIZE * float(pixel_scale))).a != 0.0) {
					COLOR = vec4(color, 1.0);
					break;
				}
			}
		}
	} else {
		COLOR.rgb = unselected_fill;
	}
}