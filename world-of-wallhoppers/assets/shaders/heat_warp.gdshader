shader_type canvas_item;

uniform float intensity = 1.0;
uniform float speed = 1.0;
uniform float amplitude = 1.0;

varying vec4 mod_color;

void vertex() {
	mod_color = COLOR;
}

void fragment() {
	COLOR = texture(TEXTURE, vec2(UV.x + sin(TIME * speed + UV.y * 500.0 * intensity) / 100.0 * amplitude, UV.y));
	COLOR *= mod_color;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
