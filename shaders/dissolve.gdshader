shader_type spatial;

uniform sampler2D texture_albedo;
uniform sampler2D texture_normal;

uniform vec4 emission_color : source_color = vec4(1);
uniform float emission_amount;

uniform sampler2D dissolve_texture;
uniform float burn_size : hint_range(0,2);
uniform float dissolve_amount : hint_range(0,1);
varying vec2 tex_position;

void vertex() {
  tex_position = VERTEX.xz / 2.0 + 0.5;
}

void fragment() {
	vec4 albedo_tex = texture(texture_albedo,UV);
	ALBEDO = albedo_tex.rgb;
	
	float sample = texture(dissolve_texture, UV).r;
	float emission_value = 1.0 - smoothstep(dissolve_amount, dissolve_amount + burn_size, sample);
	EMISSION = vec3(emission_value * emission_amount * emission_color.rgb);
	ALPHA = smoothstep(dissolve_amount - burn_size, dissolve_amount, sample);
	NORMAL_MAP = texture(texture_normal, tex_position).xyz;
	ROUGHNESS = 1.0;
}