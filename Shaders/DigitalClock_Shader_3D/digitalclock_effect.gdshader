shader_type canvas_item;

uniform vec2 resolution = vec2(1920.0, 1080.0);
uniform vec3 color: source_color = vec3(0.1, 0.1, 1.0);
uniform int hour: hint_range(0, 23, 1) = 0;
uniform int minute: hint_range(0, 59, 1) = 0;
uniform int second: hint_range(0, 59, 1) = 0;
uniform float zoom: hint_range(1.0, 10.0, 0.1) = 3.0;
uniform bool blink_colon = true;

float line(vec2 uv, float dir) {
	return smoothstep(0.1, 0.09, dir) *
		smoothstep(0.5, 0.49, abs(uv.x + uv.y)) *
		smoothstep(0.5, 0.49, abs(uv.x - uv.y));
}

float v_line(vec2 uv) {
	return line(uv, abs(uv.x));
}

float h_line(vec2 uv) {
	return line(uv, abs(uv.y));
}

float digit(vec2 uv, int n) {
	float result = 0.0;
	uv *= 3.0;
	if (n != 1 && n != 4) {
		result += h_line(uv - vec2(0.0, -1.0)); // 0
	}

	if (n != 1 && n != 2 && n != 3 && n != 7) {
		result += v_line(uv - vec2(-0.5)); // 1
	}

	if (n != 5 && n != 6) {
		result += v_line(uv - vec2(0.5, -0.5)); // 2
	}

	if (n != 0 && n != 1 && n != 7) {
		result += h_line(uv); // 3
	}
	if (n == 0 || n == 2 || n == 6 || n == 8) {
		result += v_line(uv - vec2(-0.5, 0.5)); // 4
	}
	if (n != 2) {
		result += v_line(uv - vec2(0.5)); // 5
	}
	if (n != 1 && n != 4 && n != 7) {
		result += h_line(uv - vec2(0.0, 1.0)); // 6
	}
	return result;
}

float square(vec2 uv) {
	return smoothstep(0.05, 0.04, abs(uv.x)) *
		smoothstep(0.05, 0.04, abs(uv.y));
}

float colon(vec2 uv) {
	return square(uv - vec2(0.0, 0.13)) +
		square(uv - vec2(0.0, -0.13));
}

float clock(vec2 uv) {
	float result = 0.0;
	result += digit(uv - vec2(-1.55, 0.0), hour / 10);
	result += digit(uv - vec2(-1.0, 0.0), hour % 10);
//	result += colon(uv - vec2(-0.65, 0.0));

	result += digit(uv - vec2(-0.3, 0.0), minute / 10);
	result += digit(uv - vec2(0.25, 0.0), minute % 10);
//	result += colon(uv - vec2(0.6, 0.0));

	result += digit(uv - vec2(0.95, 0.0), second / 10);
	result += digit(uv - vec2(1.4, 0.0), second % 10);
	
	if (blink_colon) {
		result += colon(uv - vec2(-0.65, 0.0));
		result += colon(uv - vec2(0.6, 0.0));
	}



	return result;
}


void fragment() {
	vec2 uv = UV - 0.5;
	uv.x *= resolution.x / resolution.y;
	uv *= zoom;
	float result = clock(uv);
	COLOR = vec4(result * color, 1.0);
}
