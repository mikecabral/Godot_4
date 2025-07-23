shader_type canvas_item;

#define S(edge, value) smoothstep(1.0 - edge, 1.0, value)
#define SE(size, value) smoothstep(size, size + 0.001, value)

uniform vec2 resolution = vec2(1920.0, 1080.0);
uniform float hour: hint_range(0.0, 23.0, 1.0) = 0;
uniform float minute: hint_range(0.0, 59.0, 1.0) = 0;
uniform float second: hint_range(0.0, 59.0, 1.0) = 0;
uniform vec4 clock_color: source_color = vec4(1.0);
uniform float hour_cut: hint_range(0.0, 1.0, 0.01) = 0.9;
uniform float minute_cut: hint_range(0.0, 1.0, 0.01) = 0.83;
uniform float second_cut: hint_range(0.0, 1.0, 0.01) = 0.8;

uniform bool show_border = true;
uniform bool show_center = true;
uniform bool show_hour_ticks = true;
uniform bool show_minute_ticks = true;
uniform bool show_hour_hand = true;
uniform bool show_minute_hand = true;
uniform bool show_second_hand = true;

uniform bool invert_colors = false;
uniform bool rainbow_mode = false;
uniform float angle_offset = 0.0; // [0..1], shifts the hue angle around the clock



float cut_lines(vec2 uv, float thickness, float count, float edge1, float edge2) {
	float phi = atan(uv.x, uv.y) / TAU;
	float lines = S(thickness, abs(cos(phi * PI * count)));
	float cuts = SE(edge1, length(uv)) * SE(edge2, 1.0 - length(uv));
	return lines * cuts;
}

float cut_sector(vec2 uv, float angle, float time) {
	float phi = atan(uv.x, uv.y) / TAU;
	return S(angle, sin(fract(phi + time) * PI));
}

float cut_length(vec2 uv, float size) {
	return SE(size, 1.0 - length(uv));
}

void fragment() {
	vec2 uv = UV - 0.5;
	uv.x *= resolution.x / resolution.y;
	float time = hour * 3600.0 + minute * 60.0 + second;
	vec4 color = vec4(0.0, 0.0, 0.0, 0.0);

	vec4 final_color = clock_color;

	// Optional rainbow mode
	if (rainbow_mode) {
	    // Calculate normalized angle [0..1] around center (uv)
	    float angle = atan(uv.y, uv.x) / (2.0 * PI) + 0.5; 
	    // Apply the offset from uniform, wrap around with fract()
	    float hue = fract(angle + angle_offset);

	    // Convert hue to RGB (simple HSV to RGB conversion)
	    float c = 1.0;
	    float x = 1.0 - abs(mod(hue * 6.0, 2.0) - 1.0);
	    vec3 rgb;

	    if (hue < 1.0/6.0) rgb = vec3(c, x, 0.0);
	    else if (hue < 2.0/6.0) rgb = vec3(x, c, 0.0);
	    else if (hue < 3.0/6.0) rgb = vec3(0.0, c, x);
	    else if (hue < 4.0/6.0) rgb = vec3(0.0, x, c);
	    else if (hue < 5.0/6.0) rgb = vec3(x, 0.0, c);
	    else rgb = vec3(c, 0.0, x);

	    final_color.rgb = rgb;
	}


	// Invert color
	if (invert_colors) {
		final_color.rgb = 1.0 - final_color.rgb;
	}

	// Clock elements with toggles
	if (show_border) {
		float border = SE(0.77, 1.0 - length(uv)) - SE(0.78, 1.0 - length(uv));
		color += border * final_color;
	}

	if (show_center) {
		float center = SE(0.99, 1.0 - length(uv));
		color += center * final_color;
	}

	if (show_hour_ticks) {
		color += cut_lines(uv, 0.01, 12.0, 0.17, 0.79) * final_color;
	}

	if (show_minute_ticks) {
		color += cut_lines(uv, 0.01, 60.0, 0.19, 0.79) * final_color;
	}

	if (show_hour_hand) {
		float hour_hand = cut_sector(uv, 0.0007, time / (3600.0 * 12.0)) * cut_length(uv, hour_cut);
		color += hour_hand * final_color;
	}

	if (show_minute_hand) {
		float minute_hand = cut_sector(uv, 0.0003, time / 3600.0) * cut_length(uv, minute_cut);
		color += minute_hand * final_color;
	}

	if (show_second_hand) {
		float second_hand = cut_sector(uv, 0.0007, time / 60.0) * cut_length(uv, second_cut);
		color += second_hand * final_color;
	}

	COLOR = color;
}

