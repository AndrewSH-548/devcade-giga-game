shader_type canvas_item;

uniform sampler2D noise: repeat_enable;
uniform float noise_scale = 1.0;
uniform vec3[3] colors: source_color;
uniform float[3] color_thresholds;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

const vec3 BRIGHT = 		vec3(1.0, 1.0, 1.0); // WHITE
const vec3 BRIGHT_SHADE = 	vec3(0.0, 1.0, 0.0); // GREEN
const vec3 MID = 			vec3(1.0, 0.0, 0.0); // RED
const vec3 DARK_HIGHLIGHT = vec3(0.0, 0.0, 1.0); // BLUE
const vec3 DARK = 			vec3(1.0, 0.0, 1.0); // MAGENTA

varying vec2 world_pos;
void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	world_pos.y *= 1.0;
}

void fragment() {
	COLOR = texture(screen_texture, SCREEN_UV);
	float sample = texture(noise, world_pos * noise_scale / 1024.0).r;
	vec3 base = COLOR.rgb;
	
	if(sample > color_thresholds[2]) {
		COLOR.rgb = colors[2];
	} else
	if(sample > color_thresholds[1]) {
		COLOR.rgb = colors[1];
	} else {
		COLOR.rgb = colors[0];
	}
	
	if(base == BRIGHT) {
		// Nothing
	} else
	if (base == BRIGHT_SHADE) {
		COLOR.rgb = mix(COLOR.rgb, vec3(0.0, 0.0, 1.0), 0.2);
	} else
	if (base == MID) {
		COLOR.rgb = mix(COLOR.rgb, vec3(0.0, 0.0, 1.0), 0.35);
	} else
	if (base == DARK_HIGHLIGHT) {
		COLOR.rgb = mix(COLOR.rgb, vec3(0.0, 0.0, 0.7), 0.6);
	} else
	if (base == DARK) {
		COLOR.rgb = mix(COLOR.rgb, vec3(0.0, 0.0, 0.4), 0.7);
	} else {
		COLOR.rgb = base;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
