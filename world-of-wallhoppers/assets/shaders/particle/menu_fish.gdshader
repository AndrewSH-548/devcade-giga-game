shader_type particles;

void start() {
	TRANSFORM[3].x = 0.0;
}

void process() {
	TRANSFORM[3].x -= 15.0;
}
