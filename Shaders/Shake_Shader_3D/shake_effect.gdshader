shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

uniform float amp: hint_range(0.0, 20.0, 0.1) = 2.0;
uniform float shift: hint_range(0.0, 1.0, 0.01) = 0.5;
uniform float freq: hint_range(0.0, 2.0, 0.01) = 1.0;

float hash11(float n) {
	return fract(sin(n) * 43758.5453123);
}

void fragment() {
	vec2 uv = SCREEN_UV;
	float offset = max(sin(TIME * freq) + shift, 0.0) * amp * 0.01;
	float quake = offset * (hash11(TIME) - 0.5);
	uv.y += quake;
	COLOR = texture(SCREEN_TEXTURE, uv);
}
