shader_type canvas_item;

uniform vec3 color: source_color = vec3(1.0);
uniform vec3 fill_color: source_color = vec3(0.5);
uniform vec3 unselected_fill: source_color = vec3(0.2);
uniform bool active = false;
uniform sampler2D source: hint_screen_texture, filter_nearest;
uniform int pixel_scale = 2;

const vec2[4] directions = { vec2(0.0, 1.0), vec2(0.0, -1.0), vec2(1.0, 0.0), vec2(-1.0, 0.0)};

void fragment() {
	vec2 uv = SCREEN_UV;
	
	if(active) {
		uv.x += cos(TIME * 2.0 + UV.y * UV.x) * 0.005 * TEXTURE_PIXEL_SIZE.x;
		uv.y += sin(TIME * 2.0 + UV.x * UV.y) * 0.005 * TEXTURE_PIXEL_SIZE.y;
	}
	
	COLOR = texture(source, uv);
	if(active) {
		
		if(COLOR.rgb != vec3(0.0)) {
			COLOR.rgb = color;
		} else {
			COLOR.rgb = fill_color;
		}
		if(COLOR.a != 1.0) {
			for(int i = 0; i < 4; i++) {
			vec2 direction = directions[i];
				if(texture(source, uv + (direction * SCREEN_PIXEL_SIZE * float(pixel_scale))).a != 0.0) {
					COLOR = vec4(color, 1.0);
					break;
				}
			}
		}
	} else {
		COLOR.rgb = unselected_fill;
	}
}