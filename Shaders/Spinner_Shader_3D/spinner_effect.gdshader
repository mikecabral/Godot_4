shader_type canvas_item;

#define SE(size, value) smoothstep(size, size + 0.001, value)

uniform vec2 resolution = vec2(1920.0, 1080.0);
uniform float speed: hint_range(0.0, 1.0, 0.01) = 0.5;
uniform float outer: hint_range(0.0, 1.0, 0.01) = 0.6;
uniform float inner: hint_range(0.0, 1.0, 0.01) = 0.8;
uniform vec4 color: source_color = vec4(1.0);
uniform float stripe_count: hint_range(6.0, 100.0, 1.0) = 60.0;
uniform float stripe_size: hint_range(0.0, 1.0, 0.01) = 0.9;
uniform float stripe_edge: hint_range(0.0, 1.0, 0.01) = 0.1;
uniform bool solid = true;
uniform float angle_hue_shift: hint_range(0.0, 1.0, 0.01) = 1.0;
uniform bool rainbow = false;

vec3 hsv2rgb(vec3 c) {
	vec4 K = vec4(1.0, 2.0/3.0, 1.0/3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
	vec2 uv = UV - 0.5;
	uv.x *= resolution.x / resolution.y;

	float time = TIME * speed;
	float dist = length(uv);
	float circle = SE(outer, 1.0 - dist) - SE(inner, 1.0 - dist);
	float angle = atan(uv.y, uv.x);

	// Compute animated angle modulation
	float modulation = fract(angle / TAU - time);

	// Choose base color based on rainbow toggle
	vec4 base_color = rainbow
		? vec4(hsv2rgb(vec3(fract(angle / TAU * angle_hue_shift), 1.0, 1.0)), 1.0)
		: color;

	vec4 result = base_color * circle * modulation;

	if (!solid) {
		result *= smoothstep(stripe_size, stripe_size + stripe_edge, abs(cos((angle / TAU) * PI * stripe_count)));
	}

	COLOR = result;
}