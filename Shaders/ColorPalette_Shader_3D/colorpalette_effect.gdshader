shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

// ONLY ONE SET OF UNIFORMS for palette colors (default)
uniform vec3 color_a: source_color = vec3(0.5);
uniform vec3 color_b: source_color = vec3(0.5);
uniform vec3 color_c: source_color = vec3(1.0, 1.0, 0.5);
uniform vec3 color_d: source_color = vec3(0.8, 0.9, 0.3);

// Palette size toggles
uniform bool use_palette_8 = false;
uniform bool use_palette_16 = false;
uniform bool use_palette_32 = false;
uniform bool use_palette_64 = false;
uniform bool use_palette_128 = false;
uniform bool use_palette_256 = false;
uniform bool use_palette_512 = false;
uniform bool use_palette_1024 = false;

// Palette selection toggles
uniform bool use_doom = false;
uniform bool use_quake = false;
uniform bool use_counter_strike = false;
uniform bool use_r6siege = false;
uniform bool use_overwatch = false;
uniform bool use_fortnite = false;
uniform bool use_pubg = false;
uniform bool use_arma3 = false;
uniform bool use_the_forest = false;

uniform float palette_size: hint_range(4.0, 1024.0, 1.0) = 32.0;
uniform float palette_step: hint_range(0.1, 10.0, 0.01) = 0.5;
uniform float brightness: hint_range(0.0, 2.0, 0.01) = 1.0;
uniform float alpha_threshold: hint_range(0.0, 1.0) = 0.5;


// Palette colors as consts, unique names:
const vec3 doom_a = vec3(0.15, 0.05, 0.02);
const vec3 doom_b = vec3(0.6, 0.1, 0.0);
const vec3 doom_c = vec3(1.0, 0.5, 0.2);
const vec3 doom_d = vec3(0.3, 0.2, 0.1);

const vec3 quake_a = vec3(0.1, 0.1, 0.05);
const vec3 quake_b = vec3(0.3, 0.2, 0.1);
const vec3 quake_c = vec3(0.7, 0.5, 0.3);
const vec3 quake_d = vec3(0.2, 0.15, 0.1);

const vec3 cs_a = vec3(0.1, 0.15, 0.1);
const vec3 cs_b = vec3(0.4, 0.4, 0.3);
const vec3 cs_c = vec3(0.7, 0.7, 0.6);
const vec3 cs_d = vec3(0.3, 0.3, 0.25);

const vec3 r6_a = vec3(0.05, 0.1, 0.15);
const vec3 r6_b = vec3(0.3, 0.6, 0.8);
const vec3 r6_c = vec3(0.7, 0.8, 0.9);
const vec3 r6_d = vec3(0.2, 0.25, 0.3);

const vec3 ow_a = vec3(0.9, 0.6, 0.3);
const vec3 ow_b = vec3(0.1, 0.3, 0.6);
const vec3 ow_c = vec3(1.0, 0.1, 0.1);
const vec3 ow_d = vec3(0.8, 0.7, 0.5);

const vec3 fn_a = vec3(0.8, 0.3, 0.9);
const vec3 fn_b = vec3(0.1, 0.7, 0.4);
const vec3 fn_c = vec3(1.0, 0.9, 0.2);
const vec3 fn_d = vec3(0.4, 0.2, 0.7);

const vec3 pubg_a = vec3(0.3, 0.3, 0.2);
const vec3 pubg_b = vec3(0.5, 0.45, 0.35);
const vec3 pubg_c = vec3(0.7, 0.7, 0.6);
const vec3 pubg_d = vec3(0.4, 0.35, 0.3);

const vec3 arma_a = vec3(0.15, 0.25, 0.1);
const vec3 arma_b = vec3(0.4, 0.5, 0.3);
const vec3 arma_c = vec3(0.6, 0.65, 0.5);
const vec3 arma_d = vec3(0.3, 0.35, 0.25);

const vec3 forest_a = vec3(0.1, 0.3, 0.1);
const vec3 forest_b = vec3(0.4, 0.5, 0.3);
const vec3 forest_c = vec3(0.6, 0.6, 0.4);
const vec3 forest_d = vec3(0.3, 0.25, 0.2);

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
	return a + b * cos(TAU * (c * t + d));
}

float get_active_palette_size() {
	if (use_palette_1024) return 1024.0;
	if (use_palette_512) return 512.0;
	if (use_palette_256) return 256.0;
	if (use_palette_128) return 128.0;
	if (use_palette_64) return 64.0;
	if (use_palette_32) return 32.0;
	if (use_palette_16) return 16.0;
	if (use_palette_8) return 8.0;
	return palette_size;
}

void fragment() {
	// use the uniforms by default:
	vec3 a = color_a;
	vec3 b = color_b;
	vec3 c = color_c;
	vec3 d = color_d;

	// Override based on toggles
	if (use_doom) {
		a = doom_a; b = doom_b; c = doom_c; d = doom_d;
	} else if (use_quake) {
		a = quake_a; b = quake_b; c = quake_c; d = quake_d;
	} else if (use_counter_strike) {
		a = cs_a; b = cs_b; c = cs_c; d = cs_d;
	} else if (use_r6siege) {
		a = r6_a; b = r6_b; c = r6_c; d = r6_d;
	} else if (use_overwatch) {
		a = ow_a; b = ow_b; c = ow_c; d = ow_d;
	} else if (use_fortnite) {
		a = fn_a; b = fn_b; c = fn_c; d = fn_d;
	} else if (use_pubg) {
		a = pubg_a; b = pubg_b; c = pubg_c; d = pubg_d;
	} else if (use_arma3) {
		a = arma_a; b = arma_b; c = arma_c; d = arma_d;
	} else if (use_the_forest) {
		a = forest_a; b = forest_b; c = forest_c; d = forest_d;
	}

	vec3 pixel = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	vec3 color = vec3(0.0);
	float min_dist = 1e3;

	float actual_size = get_active_palette_size();

	for (float i = 0.0; i < actual_size; i++) {
		vec3 p = palette(i * palette_step * 0.1, a, b, c, d);
		float dist = distance(p, pixel);
		if (dist < min_dist) {
			color = p;
		}
		min_dist = min(dist, min_dist);
	}

	color *= brightness;

	COLOR = vec4(color, alpha_threshold);

}
