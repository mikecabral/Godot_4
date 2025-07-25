shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform vec3 luminance: source_color = vec3(0.3086, 0.6094, 0.0820);
uniform vec3 base_color: source_color = vec3(0.2, 1.0, 0.4);
uniform float brightness: hint_range(0.0, 5.0, 0.1) = 2.0;
uniform float noise_level: hint_range(0.0, 1.0, 0.01) = 0.2;
uniform float vignette_level: hint_range(0.0, 1.0, 0.01) = 0.5;
uniform float edge_x: hint_range(0.0, 1.0, 0.01) = 0.15;
uniform float edge_y: hint_range(0.0, 6.0, 0.01) = 0.15;
uniform float flickering_level: hint_range(0.0, 1.0, 0.01) = 0.1;

float hash11(float x) {
	return fract(cos(mod(dot(vec2(x, x), vec2(13.9898, 8.141)), 3.14)) * 43768.5433);
}

void fragment() {
	float time = TIME;

	vec2 uv = SCREEN_UV - 0.5;
	vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
	uv.x *= resolution.x / resolution.y;

	vec3 color = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;

	float grain = hash11(uv.x) + uv.y;
	color += hash11(grain * time) * noise_level;

	vec2 edge = uv * uv * uv * vec2(edge_x, edge_y);
	color *= smoothstep(length(edge), 1.0, vignette_level);

	vec3 flicker = vec3(0.0, hash11(time) * flickering_level, 0.0);
	vec3 vision_color = base_color + flicker;

	color = dot(color, luminance) * vision_color;

	COLOR = vec4(color * brightness, 1.0);
}
