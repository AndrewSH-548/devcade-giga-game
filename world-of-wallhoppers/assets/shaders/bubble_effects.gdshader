shader_type canvas_item;

void vertex() {
	VERTEX += vec2(sin(TIME) * 0.05 * VERTEX.x, cos(TIME) * 0.05 * VERTEX.y);
}

vec3 hsv_to_rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
	COLOR.rgb *= hsv_to_rgb(vec3(TIME * 0.1, 0.2, 1.0));
}