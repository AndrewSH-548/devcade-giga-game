shader_type canvas_item;

uniform vec4 modulate: source_color = vec4(1.0);
uniform vec2 speed = vec2(1.0);

void fragment() {
	COLOR = texture(TEXTURE, UV + speed * TIME) * modulate;
}
