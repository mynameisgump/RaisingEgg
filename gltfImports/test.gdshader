shader_type spatial;

// Declare uniform variables for the SSS map, vein texture, and displacement scale
uniform sampler2D sss_map;
uniform sampler2D vein_texture;
uniform sampler2D vein_normal_map;
uniform sampler2D base_texture;
// uniform float displacement_scale = 0.1;

void fragment() {
    // Get the base color and SSS map color
    vec4 base_color = texture(base_texture, UV);
    vec4 sss_color = texture(sss_map, UV);

    // Sample the vein texture and scale it
    vec4 vein_color = texture(vein_texture, UV);
    vec4 vein_normal = texture(vein_texture, UV);
	
	NORMAL = vein_normal;

    // Mix the vein texture with the SSS map (subtracting vein texture)
    vec4 final_sss = sss_color - vein_color;

    // Apply displacement based on the vein texture
    // VERTEX += vertex_norm * vein_displacement;

    // Set the final color and SSS
    ALBEDO = base_color.rgb;
    SSS_STRENGTH = final_sss.r;
}