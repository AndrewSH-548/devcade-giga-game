shader_type canvas_item;

uniform vec4 modulate: source_color = vec4(1.0);
uniform vec2 speed = vec2(1.0);
uniform vec2 offset;

void fragment() {
	vec2 uv = UV + offset * TEXTURE_PIXEL_SIZE;
	COLOR = texture(TEXTURE, uv + speed * TIME) * modulate;
}
