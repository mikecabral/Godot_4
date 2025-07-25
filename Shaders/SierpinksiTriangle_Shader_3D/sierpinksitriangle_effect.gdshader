shader_type canvas_item;

uniform int levels: hint_range(1, 10, 1) = 1;

float fractal(vec2 p) {
	if (p.x < 1.0 && p.y < 1.0 && p.x + p.y > 1.0 || p.x < 0.0) {
		return 0.0;
	}
	for (int i = 0; i < levels; i++) {
		p *= 2.0;
		if (p.x < 1.0 && p.y < 1.0 && p.x + p.y > 1.0) {
			return 0.0;
		}
		p.x -= float(p.x > 1.0);
		p.y -= float(p.y > 1.0);
	}
	return 1.0;
}

void fragment() {
	vec2 uv = UV;
	uv.y = 1.0 - uv.y;
	uv.x -= uv.y / 2.0;
	COLOR = vec4(fractal(uv));
}

