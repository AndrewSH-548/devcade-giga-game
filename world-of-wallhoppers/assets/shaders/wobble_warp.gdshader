shader_type canvas_item;

uniform vec2 amplitude = vec2(5.0);
uniform vec2 speed = vec2(2.0);
uniform vec2 width = vec2(2.0);

varying vec4 mod_color;

void vertex() {
	mod_color = COLOR;
}

vec2 sincos(vec2 operand) {
	return vec2(sin(operand.x), cos(operand.y));
}

void fragment() {
	vec2 offset = amplitude * 0.01 * sincos(vec2(TIME * speed * 0.1 + UV * width));
	COLOR = texture(TEXTURE, UV + offset);
	COLOR *= mod_color;
}
//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
