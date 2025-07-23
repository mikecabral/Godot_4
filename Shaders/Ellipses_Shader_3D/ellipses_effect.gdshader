shader_type canvas_item;

uniform vec2 ellipse_size = vec2(1.0, 0.5);
uniform float thickness: hint_range(0.1, 1.0, 0.01) = 0.5;
uniform float zoom: hint_range(0.1, 10.0, 0.01) = 2.75;
uniform float steps: hint_range(0.1, 200.0, 0.1) = 100.0;
uniform float speed: hint_range(0.0, 10.0, 0.01) = 1.0;
uniform float x_coeff: hint_range(0.0, 1.0, 0.01) = 0.6;
uniform float y_coeff: hint_range(0.0, 1.0, 0.01) = 0.8;


float ellipse(vec2 uv, vec2 center, vec2 size) {
	float formula = pow(uv.x - center.x, 2.0) / pow(size.x, 2.0) +
					pow(uv.y - center.y, 2.0) / pow(size.y, 2.0);
	return smoothstep(thickness, 0.0, abs(1.0 - formula));
	
}

void fragment() {
	vec2 uv = UV - 0.5;
	uv *= zoom;
	float time = TIME * speed;
	float ellipses = 0.0;
	float red = sin(time) * 0.5 + 0.5;
	float green = cos(time * 0.9) * 0.5 + 0.5;
	float blue = sin(time * 0.8) * 0.5 + 0.5;
	vec3 color = vec3(red, green, blue);
	for (float i = 0.0; i < steps * PI; i++) {
		float x = cos(time + i * x_coeff * 0.1);
		float y = sin(time + i * y_coeff * 0.1);
		vec2 center = vec2(x, y);
		ellipses += ellipse(uv, center, ellipse_size * 0.1);
	}
	COLOR = vec4(ellipses * color, 1.0);
}
