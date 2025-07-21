shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

uniform float threshold: hint_range(0.0, 1.2, 0.01) = 1.2;
uniform vec4 first_color: source_color = vec4(0.8, 0.4, 0.2, 1.0);
uniform vec4 second_color: source_color = vec4(0.5, 0.0, 0.0, 1.0);

void fragment() {
	vec2 uv = SCREEN_UV;
	vec4 color = texture(SCREEN_TEXTURE, uv);
	float gray = (color.r + color.g + color.b) / 3.0;

	if (gray > threshold - 0.2) {
		color = first_color;
		if (gray > threshold - 0.1) {
			color = second_color;

			if (gray > threshold) {
				color = vec4(0.0, 0.0, 0.0, 1.0);
			}
		}
	}

	COLOR = color;
}
