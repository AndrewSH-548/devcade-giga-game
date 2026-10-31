shader_type canvas_item;

uniform bool active;

void fragment()
{
	if (active){
	
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
	
	COLOR.rgb *= 0.7;
	COLOR.rgb += vec3(0.35);
	}
}