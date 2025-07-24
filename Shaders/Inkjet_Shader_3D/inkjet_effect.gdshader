shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform float density: hint_range(1.0, 500.0, 0.1) = 100.0;
uniform vec4 intensity = vec4(0.8, 0.9, 0.8, 0.6);

const vec4 angles = vec4(0.261, 1.309, 0.0, 0.785);
const mat4 vectors = mat4(
	vec4(1.0, 0.0, 0.0, 0.0),
	vec4(0.0, 1.0, 0.0, 0.0),
	vec4(0.0, 0.0, 1.0, 0.0),
	vec4(1.0, 1.0, 1.0, 0.0)
);

vec4 rgb_to_cmyk(vec3 color) {
	float k = 1.0 - max(color.r, max(color.g, color.b));
	return vec4(
		(1.0 - color.r - k) / max(1.0 - k, 0.0001),
		(1.0 - color.g - k) / max(1.0 - k, 0.0001),
		(1.0 - color.b - k) / max(1.0 - k, 0.0001),
		k
	);
}

vec2 grid(vec2 uv, float angle, vec2 resolution) {
	float aspect_ratio = resolution.x / resolution.y;
	return vec2(
		mod(((uv.x * aspect_ratio) * cos(angle) - uv.y * sin(angle)) * density, 1.0),
		mod(((uv.x * aspect_ratio) * sin(angle) + uv.y * cos(angle)) * density, 1.0)
	);
}

void fragment() {
	vec2 uv = SCREEN_UV;
	vec2 resolution = 1.0 / TEXTURE_PIXEL_SIZE;
	vec3 rgb = texture(SCREEN_TEXTURE, uv).rgb;
	vec4 cmyk = rgb_to_cmyk(rgb);
	vec3 result = vec3(1.0);
	for (int i = 0; i < 4; i++) {
		vec2 grid = grid(uv, angles[i], resolution);
		float value = cmyk[i] * intensity[i] / length(grid - 0.5);
		vec3 component = vectors[i].xyz * clamp(pow(value, 5.0), 0.0, 1.0);
		result -= component;
	}
	COLOR = vec4(result, 1.0);
}
