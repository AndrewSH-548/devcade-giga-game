shader_type spatial;
render_mode unshaded, cull_disabled, depth_test_default;
stencil_mode read, compare_not_equal, 1;

uniform sampler2D albedo_texture: source_color;
uniform vec3 color: source_color = vec3(1.0);
uniform vec3 outline_color: source_color;
uniform float outline_size = 1.0;

const vec2[4] directions = { vec2(0.0, 1.0), vec2(0.0, -1.0), vec2(1.0, 0.0), vec2(-1.0, 0.0)};


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
	}
}
