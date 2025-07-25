shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

uniform float a: hint_range(1.0, 100.0, 0.01) = 21.0;
uniform float b: hint_range(1.0, 100.0, 0.01) = 1.0;
uniform float c: hint_range(1.0, 100.0, 0.01) = 70.0;
uniform float d: hint_range(1.0, 100.0, 0.01) = 50.0;
uniform float speed: hint_range(0.1, 4.0, 0.1) = 0.2;
uniform float threshold: hint_range(0.0, 1.0, 0.01) = 0.5;

void fragment() {
	vec2 uv = -SCREEN_UV; // Get screen-space UV
	float rain_intensity = 1.0 - fract((a * uv.x + b * uv.y) * fract(c * uv.x) + TIME * speed) * d;

	vec4 screen_color = texture(SCREEN_TEXTURE, uv);
	if (rain_intensity > threshold) {
		screen_color.rgb += vec3(rain_intensity);
	}

	COLOR = screen_color;
}
