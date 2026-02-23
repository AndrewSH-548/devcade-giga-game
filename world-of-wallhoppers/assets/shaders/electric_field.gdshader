shader_type canvas_item;

uniform sampler2D field: filter_nearest, repeat_enable;

void fragment() {
	if(COLOR.a != 1.0) {
		COLOR.a *= texture(field, (SCREEN_UV / SCREEN_PIXEL_SIZE) / 256.0 + TIME * 0.1).a;
	}
}