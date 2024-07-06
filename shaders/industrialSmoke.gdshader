shader_type fog;

uniform sampler2D noise00;
uniform sampler2D noise01;
uniform float density_multiplicator = 3.;
uniform vec3 base_color: source_color = vec3(.2, .2, .2);
uniform vec3 fade_out_color: source_color = vec3(.8, .8, .8);
uniform float fade_out_level = .5;
uniform float speed = .25;

mat2 rot2d(float a) {
	return mat2(vec2(cos(2), -sin(a)), vec2(sin(a), cos(a)));
}

void fog() {
	vec3 uvw = UVW;
	uvw.y -= fract(TIME * speed) - .5; // -0.5 ... 0.5
	
	float n00 = texture(noise00, rot2d(abs(sin(TIME * .2))) * UVW.xz).r;
	float n01 = texture(noise01, rot2d(abs(sin(TIME * .2))) * UVW.xz).r * 1.4;
	float d = step(.4 * n01, uvw.y) - step(.50 * n01, uvw.y);
	
	d *= n00;
	d *= 3. * (1. - UVW.y); // fade out
	
	d *= density_multiplicator;
	DENSITY = d;

	vec3 col = mix(base_color, fade_out_color, pow(fade_out_level, 1./2.2));
	ALBEDO = col;
}