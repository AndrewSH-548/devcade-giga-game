shader_type spatial;
render_mode unshaded, cull_disabled, depth_test_default;

uniform sampler2D albedo_texture: source_color, filter_nearest;
uniform vec3 color: source_color = vec3(1.0);
uniform vec3 outline_color: source_color;
uniform float outline_size = 1.0;
uniform bool use_diagonals = false;
uniform bool use_billboard = false;

const vec2[4] directions = { vec2(0.0, 1.0), vec2(0.0, -1.0), vec2(1.0, 0.0), vec2(-1.0, 0.0)};
const vec2[4] directions_diagonal = { vec2(1.0, 1.0), vec2(-1.0, -1.0), vec2(1.0, -1.0), vec2(-1.0, 1.0)};

void vertex() {
	if(use_billboard) {
		MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
				MAIN_CAM_INV_VIEW_MATRIX[0],
				MAIN_CAM_INV_VIEW_MATRIX[1],
				MAIN_CAM_INV_VIEW_MATRIX[2],
				MODEL_MATRIX[3]);
		MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	}
}

void fragment() {
	vec2 uv = UV;
	vec4 sample = texture(albedo_texture, uv);
	ALBEDO = sample.rgb * color;
	ALPHA = sample.a;
	
	if(sample.a != 1.0) {
		for(int i = 0; i < 4; i++) {
			vec2 direction = directions[i];
			if(texture(albedo_texture, uv + (direction * outline_size)).a != 0.0) {
				ALBEDO = outline_color;
				ALPHA = 1.0;
				break;
			}
		}
		if(ALPHA != 1.0 && use_diagonals) {
			for(int i = 0; i < 4; i++) {
			vec2 direction = directions_diagonal[i];
			if(texture(albedo_texture, uv + (direction * outline_size)).a != 0.0) {
				ALBEDO = outline_color;
				ALPHA = 1.0;
				break;
			}
		}
		}
	}
}
