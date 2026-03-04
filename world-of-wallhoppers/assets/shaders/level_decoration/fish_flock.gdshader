shader_type particles;
render_mode disable_velocity;

float rand(float x) {
    return fract(sin(x) * 43758.5453123);
}

float fast_sin(float x) {
    x = mod(x + 3.14159, 6.28318) - 3.14159;
    return x * (1.27323954 - 0.405284735 * abs(x));
}

void start() {
    TRANSFORM[3].xy = vec2(0.0);
	CUSTOM.x = rand(float(INDEX) * 0.2) * 60.0 + 2.0;
	CUSTOM.y = rand(float(INDEX) * 0.2 + 1.0) * 10.0;
	COLOR.r = rand(float(INDEX)) * 0.5 + 0.3;
	COLOR.b = rand(float(INDEX) + 1.0) * 0.5  + 0.3;
	COLOR.g = rand(float(INDEX) + 1.0) * 0.2;
}

void process() {
	TRANSFORM[3].x += 100.0 * DELTA;
	TRANSFORM[3].y = fast_sin(TRANSFORM[3].x / 100.0 + CUSTOM.y) * CUSTOM.x;
}