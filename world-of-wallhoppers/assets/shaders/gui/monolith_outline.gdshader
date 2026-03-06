shader_type spatial;
render_mode cull_back, depth_draw_opaque, depth_test_default, unshaded, blend_premul_alpha;
stencil_mode read, compare_not_equal, 1;

uniform vec3 color: source_color;

void fragment() {
	ALBEDO = color;
}