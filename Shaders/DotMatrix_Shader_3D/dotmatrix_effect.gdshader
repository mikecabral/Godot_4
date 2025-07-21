shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform vec3 luminance : source_color = vec3(0.3086, 0.6094, 0.0820);
uniform float brightness : hint_range(0.1, 20.0, 0.01) = 2.0;
uniform float contrast : hint_range(1.0, 4.0, 0.01) = 2.0;
uniform float scale : hint_range(0.0, 2.0, 0.01) = 1.0;
uniform float angle : hint_range(0.0, 6.28, 0.01) = 3.0;

mat2 rotate(float a) {
	float sa = sin(a);
	float ca = cos(a);
	return mat2(vec2(ca, sa), vec2(-sa, ca));
}

float dot_matrix(vec2 uv) {
	vec2 rot_uv = rotate(angle) * uv * scale;
	return sin(rot_uv.x) * sin(rot_uv.y);
}

void fragment() {
	vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 uv = SCREEN_UV;

	vec3 color = texture(SCREEN_TEXTURE, uv).rgb;
	float grey = dot(color, luminance) * contrast;
	color = vec3(grey + dot_matrix(uv * resolution) - 1.0);
	COLOR = vec4(color * brightness, 1.0);
}
