shader_type canvas_item;

uniform vec2 resolution = vec2(1920, 1080);
uniform float zoom: hint_range(1.0, 20.0, 0.01) = 6.0;
uniform vec3 flame_top_color: source_color = vec3(1.0, 0.5, 0.0);
uniform vec3 flame_bottom_color: source_color = vec3(0.0, 0.3, 1.0);
uniform float flame_width: hint_range(0.01, 100.0, 0.01) = 2.0;
uniform float flame_curve: hint_range(0.0, 10.0, 0.01) = 4.0;
uniform float flame_shape: hint_range(0.1, 1.0, 0.01) = 0.3;
uniform float flame_power: hint_range(0.0, 1.0, 0.01) = 0.7;
uniform float flame_bottom: hint_range(0.0, 1.0, 0.01) = 0.26;
uniform float flame_gradient: hint_range(0.1, 10.0, 0.01) = 4.0;
uniform float flame_red_brightness: hint_range(0.0, 10.0, 0.01) = 1.0;
uniform float horizontal_speed: hint_range(0.0, 1.0, 0.01) = 0.1;
uniform float horizontal_sway: hint_range(0.0, 1.0, 0.01) = 0.1;
uniform float vertical_speed: hint_range(0.0, 1.0, 0.01) = 0.4;
uniform float flickering_speed: hint_range(0.0, 100.0, 0.1) = 60.0;

vec2 flickering(vec2 uv) {
	float fluctuation = (sin(TIME * horizontal_speed - uv.y) + cos((TIME * horizontal_speed - uv.y) * 0.01));
	uv.x += sin(TIME * horizontal_speed) * (3.0 - uv.y) * fluctuation * horizontal_sway * 0.1;
	uv.y += fract(sin(TIME * flickering_speed)) * vertical_speed * 0.1;
	return uv;
}

void fragment() {
	vec2 uv = UV - 0.5;
	uv.x *= resolution.x / resolution.y;
	uv *= zoom;
	float width = flame_width * 0.1;
	uv = flickering(uv);
	vec3 top = vec3(0.0);
	float flame = pow(abs(uv.x), flame_curve) / width;
	float shape = abs(uv.y - flame) * flame_shape;
	top = smoothstep(0.0, 1.0, flame_power - shape) * flame_top_color;
	top *= smoothstep(flame_bottom, flame_bottom - 0.1, uv.y * 0.1);
	top *= (uv.y + 6.0) / flame_gradient;
	top += top.r * flame_red_brightness;
	uv.y -= 2.0 - flame_bottom;
	vec3 bottom = vec3(0.0);
	flame = pow(abs(uv.x), flame_curve) / width * 0.5;
	shape = abs(uv.y - flame) * flame_shape / 0.5;
	bottom = smoothstep(0.0, 1.0, flame_power - shape) * flame_bottom_color;
	bottom *= smoothstep(flame_bottom, flame_bottom - 0.1, uv.y * 0.25);
	bottom *= (uv.y + 4.0) / flame_gradient;
	vec3 color = mix(top, bottom, 0.5);
	COLOR = vec4(color, 1.0);
}
