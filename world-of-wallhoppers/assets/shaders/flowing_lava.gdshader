shader_type canvas_item;

uniform vec2 direction = vec2(-1.0, 1.0);

void fragment() {
	COLOR = texture(TEXTURE, UV + vec2(0.0, sin(TIME + UV.x * 2.0)) / 4.0 + TIME * direction * -1.0);
}