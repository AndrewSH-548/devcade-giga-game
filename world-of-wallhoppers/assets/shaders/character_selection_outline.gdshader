shader_type canvas_item;

uniform vec3[2] colors: source_color;
uniform sampler2D noise: repeat_enable;

void fragment() {
	vec2 offset = vec2(TIME / 7.0, 0);
	float value = texture(noise, UV + offset).r;
	if(value > 0.5) {
		COLOR.rgb = colors[0];
	} else {
		COLOR.rgb = colors[1];
	}
}