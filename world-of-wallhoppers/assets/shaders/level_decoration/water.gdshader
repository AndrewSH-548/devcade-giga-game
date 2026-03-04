shader_type canvas_item;

uniform vec4 base_color: source_color;
uniform float scale = 1.0;
uniform float movement = 1.0;
uniform float perspective_strength = 1.5;

uniform sampler2D[16] caustics: repeat_enable, filter_nearest;

float snap(float value, float interval) {
	return round(value / interval) * interval;
}

void fragment() {
    vec2 uv = UV;

    float perspective = pow(1.0 - uv.y, perspective_strength);
    vec2 warped_uv = vec2(uv.x, perspective * 3.0);

	COLOR = texture(caustics[int(mod(TIME * 15.0, 16.0))], warped_uv * scale + TIME * 0.1 * movement) * 2.0;
	COLOR.a = snap(COLOR.r - 0.1, 0.25);
	COLOR.a *= 1.0 - uv.y;
	COLOR *= base_color;
}
