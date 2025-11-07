shader_type canvas_item;

uniform vec2 speed = vec2(1.0);

void fragment() {
	COLOR = texture(TEXTURE, UV + speed * TIME);
}
