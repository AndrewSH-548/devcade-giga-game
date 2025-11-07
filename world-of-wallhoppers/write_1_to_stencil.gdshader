shader_type spatial;
stencil_mode write, 1;
void vertex() {
    vec3 scale = vec3(
        length(MODEL_MATRIX[0].xyz),
        length(MODEL_MATRIX[1].xyz),
        length(MODEL_MATRIX[2].xyz)
    );
    mat3 scaled_basis = mat3(
        normalize(MAIN_CAM_INV_VIEW_MATRIX[0].xyz) * scale.x,
        normalize(MAIN_CAM_INV_VIEW_MATRIX[1].xyz) * scale.y,
        normalize(MAIN_CAM_INV_VIEW_MATRIX[2].xyz) * scale.z
    );
    MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
        vec4(scaled_basis[0], 0.0),
        vec4(scaled_basis[1], 0.0),
        vec4(scaled_basis[2], 0.0),
        MODEL_MATRIX[3]
    );
    MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}

void fragment() {
	vec2 uv = UV;
	vec4 sample = texture(albedo_texture, uv);
	ALBEDO = sample.rgb * color;
	ALPHA = sample.a;
	
	if(sample.a != 1.0) {
		for(int i = 0; i < 4; i++) {
		vec2 direction = directions[i];
		if(texture(albedo_texture, uv + (direction * outline_size)).a != 0.0) {
			ALBEDO = outline_color;
			ALPHA = 1.0;
			break;
		}
	}
	}
}
