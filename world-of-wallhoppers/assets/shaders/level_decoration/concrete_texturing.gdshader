shader_type canvas_item;

uniform vec4 modulate: source_color = vec4(1.0);
uniform sampler2D concrete_texture: repeat_enable;
uniform sampler2D tiles_texture: repeat_enable;
uniform float texture_amount = 0.5;
uniform float texture_scale = 1.0;
uniform float tiles_scale = 1.0;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

varying vec2 world_pos;
void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	world_pos.y *= 1.0;
}

void fragment() {
	COLOR = texture(screen_texture, SCREEN_UV);
	COLOR.rgb = mix(COLOR.rgb, texture(concrete_texture, world_pos / 1000.0 / texture_scale).rgb, texture_amount);
	vec4 tiles = texture(tiles_texture, world_pos / 1000.0 / tiles_scale);
	COLOR.rgb = mix(COLOR.rgb, COLOR.rgb * tiles.r, 0.2 * tiles.a);
	COLOR *= modulate;
}