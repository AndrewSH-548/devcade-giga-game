shader_type canvas_item;


uniform bool use_alt = false;
uniform sampler2D source_colors: filter_nearest;
uniform sampler2D colors: filter_nearest;

const vec3 ERROR_COLOR = vec3(1.0, 0.0, 1.0);
const int SAMPLE_LOD = 0;

bool is_color(vec3 color, vec3 other_color, float tolerance) {
	return (
		abs(color.r - other_color.r) < tolerance &&
		abs(color.g - other_color.g) < tolerance &&
		abs(color.b - other_color.b) < tolerance
	);
}

vec3 get_swapped_color(vec3 color, float tolerance) {

	ivec2 source_colors_size = textureSize(source_colors, SAMPLE_LOD);
	ivec2 colors_size = textureSize(colors, SAMPLE_LOD);

	for (int xs = 0; xs < source_colors_size.x; xs++)
	for (int ys = 0; ys < source_colors_size.y; ys++) {

		vec3 current_source = texture(source_colors,
			vec2(float(xs), float(ys)) / vec2(source_colors_size)).rgb;

		if (is_color(current_source, color, tolerance)) {
			return texture(colors,
				vec2(float(xs), float(ys)) / vec2(source_colors_size)).rgb;
		}
	}
	return ERROR_COLOR;
}

void fragment() {
	vec3 color = COLOR.rgb;

	ivec2 source_colors_size = textureSize(source_colors, SAMPLE_LOD);
	ivec2 colors_size = textureSize(colors, SAMPLE_LOD);

	if (!use_alt) {
		color = color;
	} else if (source_colors_size != colors_size) {
		color = ERROR_COLOR;
	} else {
		color = get_swapped_color(color, 0.02);
		if (color == ERROR_COLOR) {
			color = get_swapped_color(COLOR.rgb, 0.2);
		}
	}

	COLOR.rgb = color;
}