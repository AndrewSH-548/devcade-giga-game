shader_type canvas_item;

uniform int direction = -1;

void fragment() {
	COLOR = texture(TEXTURE, UV + vec2(0.0, sin(TIME + UV.x * 2.0)) / 4.0 + TIME * vec2(float(direction) * -1.0, 0.0));
}