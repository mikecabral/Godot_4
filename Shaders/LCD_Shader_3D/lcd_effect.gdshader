shader_type canvas_item;

uniform float stripe: hint_range(0.0, 1.0, 0.01) = 0.5;
uniform float scan: hint_range(0.0, 1.0, 0.01) = 0.5;
uniform float brightness: hint_range(0.0, 2.0, 0.01) = 0.5;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec4 lcd = vec4(stripe, stripe, stripe, stripe); // alpha matches stripe
	int rgb_stripe = int(mod(FRAGCOORD.x, 3.0));
	if (rgb_stripe == 1) {
		lcd.r = 1.0;
	} else if (rgb_stripe == 2) {
		lcd.g = 1.0;
	} else {
		lcd.b = 1.0;
	}
	if (int(mod(FRAGCOORD.y, 3.0)) == 0) {
		lcd.rgb = vec3(scan);
		lcd.a = scan; // add alpha effect here too
	}
	COLOR = color * lcd * brightness;
}
