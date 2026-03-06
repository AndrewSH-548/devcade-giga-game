shader_type canvas_item;

uniform float time : hint_range(0.0, 100.0);
uniform float speed = 1.0;
uniform float frequency = 4.0;
uniform float perspective_strength = 1.5;
uniform vec2 direction1 = vec2(1.0, 0.3);
uniform vec2 direction2 = vec2(-1.0, 0.3);
uniform vec2 direction3 = vec2(-1.0, 0.3);

void fragment() {
    vec2 uv = UV;

    float perspective = pow(1.0 - uv.y, perspective_strength);
    vec2 warped_uv = vec2(uv.x, perspective * 3.0);

    float wave1 = sin(dot(warped_uv, direction1 * frequency * 0.7) * 6.283 + TIME * speed);
    float wave2 = sin(dot(warped_uv, direction2 * frequency * 0.3) * 6.283 + TIME * speed * 0.8);
	float wave3 = sin(dot(warped_uv, direction3 * frequency * 1.4) * 6.283 + TIME * speed * 1.3);

    float pattern = wave1 * wave2 * wave3;

    pattern *= (1.0 - uv.y);

    vec3 color = vec3(0.5 + 0.5 * pattern);

	COLOR.rg = vec2(0.2);
    COLOR.ba = vec4(color, color.r).ba;
}
