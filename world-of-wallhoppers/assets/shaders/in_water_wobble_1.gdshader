shader_type canvas_item;

uniform vec2 speed = vec2(1.0);
uniform vec2 scale = vec2(1.0);
uniform vec2 amplitude = vec2(1.0);

void fragment() {
	vec2 uv = UV;

	uv.x = uv.x + sin(TIME * 4.0 + uv.y * 30.0) * TEXTURE_PIXEL_SIZE.x * 1.0;

	COLOR = texture(TEXTURE, uv);
}