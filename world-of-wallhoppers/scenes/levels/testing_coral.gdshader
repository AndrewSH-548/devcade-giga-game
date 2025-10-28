shader_type canvas_item;

uniform sampler2D noise: repeat_enable;
uniform float noise_scale = 1.0;
uniform vec3[3] colors: source_color;

void vertex() {

}

void fragment() {
	float sample = texture(noise, UV * noise_scale).r * 3.0;
	vec4 old_color = COLOR;
	if(COLOR.r == COLOR.b && COLOR.g == 0.0 && COLOR.r > 0.5) {
		if(sample < 1.2) {
			COLOR.rgb = colors[0];
		} else if (sample < 1.6) {
			COLOR.rgb = colors[1];
		} else if (sample < 3.0) {
			COLOR.rgb = colors[2];
		}
		
		if(old_color.r < 0.7) {
			COLOR.rgb = mix(COLOR.rgb, vec3(0.0, 0.0, 0.5), 0.2);
		}
		
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
