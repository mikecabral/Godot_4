shader_type canvas_item;

uniform vec2 resolution = vec2(1920.0, 1080.0);
uniform vec3 line_color: source_color = vec3(0.0, 1.0, 0.0);
uniform float direction: hint_range(-1.0, 1.0, 0.01) = 0.5;
uniform float brightness: hint_range(0.0, 30.0, 0.01) = 15.0;
uniform float speed: hint_range(0.0, 10.0, 0.01) = 1.0;
uniform float octaves: hint_range(0.0, 200.0, 0.1) = 100.0;
uniform float shift: hint_range(0.0, 10.0, 0.01) = 1.0;
uniform float stretch: hint_range(1.0, 100.0, 0.1) = 10.0;
uniform float alpha_threshold: hint_range(0.0, 1.0, 0.01) = 0.0;

mat2 rotate(float a) {
	float sa = sin(a);
	float ca = cos(a);
	return mat2(vec2(ca, sa), vec2(-sa, ca));
}

vec3 fbm(vec3 ray) {
	vec3 result = vec3(0.0);
	float time = TIME * speed;
	for (float i = 0.0; i < octaves; i++){
		vec3 p = result;
		p.z += time + i * shift * 0.01;
		p.z /= stretch;
		p.xy *= rotate(p.z);
		result += length(sin(p.yx + time) + cos(p.xz + time)) * ray;
	}
	return result;
}

void fragment() {
	vec2 uv = UV - 0.5;
	uv.x *= resolution.x / resolution.y;
	vec3 ray = vec3(uv, direction);
	vec3 result = fbm(ray);
	vec3 color = vec3(brightness / length(result)) * line_color;
	float avg = (color.r + color.g + color.b) / 3.0;

	COLOR = vec4(color, avg <= alpha_threshold ? 0.0 : 1.0);
}
