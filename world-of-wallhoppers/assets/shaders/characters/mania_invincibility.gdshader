shader_type canvas_item;

uniform int state;
uniform vec4 modulate: source_color = vec4(1.0);

void fragment()
{
	if (false){
	
	vec2 uv = UV;
	vec4 source = texture(TEXTURE, UV);
	uv.x += sin(uv.y / TEXTURE_PIXEL_SIZE.y / 2.0 + TIME) * TEXTURE_PIXEL_SIZE.x
	 + sin(uv.y / TEXTURE_PIXEL_SIZE.y / 8.0 + TIME * 8.0) * TEXTURE_PIXEL_SIZE.x * 0.4;
	
	COLOR = texture(TEXTURE, uv);
	
	if (COLOR.a == 0.0) {
		float pixel_x = uv.x * TEXTURE_PIXEL_SIZE.x;
		
		vec4 sample_right = texture(TEXTURE, uv + vec2(0.0, 0.0) + sin(TIME * 16.0) * 0.1 * vec2(1.0, 0.0));
		if (sample_right.r == 1.0 && sample_right.a != 0.0) {
			sample_right.a = 0.5;
			COLOR = sample_right;
		}
	}
	
	}
	else if (state == 1) {
		if (COLOR.a == 0.0) {
			vec4 addition1 = texture(TEXTURE, UV + vec2(sin(TIME * 3.0 + UV.y * 32.0) * TEXTURE_PIXEL_SIZE.x * 3.0, 0.0));
			vec4 addition2 = texture(TEXTURE, UV + vec2(sin(TIME * 8.0 + UV.y * 32.0) * TEXTURE_PIXEL_SIZE.x * 16.0, 0.0));
			COLOR += addition1;
			addition2.a *= 0.4;
			COLOR += addition2;
		}
		if (COLOR.r != 1.0) {
			COLOR.a *= 0.3;
		} else {
			COLOR.a *= 0.6;
		}
	}
	COLOR *= modulate;
}