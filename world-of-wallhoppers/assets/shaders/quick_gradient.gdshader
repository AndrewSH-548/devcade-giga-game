shader_type canvas_item;

uniform vec4 modulate: source_color = vec4(1.0);
uniform bool stepped = false;
uniform int step_count = 3;

float snap(float number, float interval) {
	return interval * (ceil(number / interval));
}

void fragment() {
	COLOR.a *= 1.0 - UV.x;
	COLOR *= modulate;
	if (stepped) {
		COLOR.a = snap(COLOR.a, 1.0 / float(step_count));
	}
}