shader_type canvas_item;

uniform sampler2D noise;

void fragment()
{
	vec2 uv = UV;
	ivec2 pixel_coords = ivec2(UV / TEXTURE_PIXEL_SIZE);
	int number = int(float(pixel_coords.y) * 0.25);
	
	if (number % 3 == 0) {
		uv.x += sin(UV.y / TEXTURE_PIXEL_SIZE.y + TIME * 4.0) * TEXTURE_PIXEL_SIZE.y * float(number % 2);
	}
	
	COLOR.rg = uv;
	COLOR.a = 1.0;
	COLOR.b = 0.0;
	COLOR = texture(TEXTURE, uv) - float(number % 3) * 0.2;
}