shader_type spatial;

uniform sampler2D texture_albedo;
uniform vec3 vein_color : source_color = vec3(0.0, 1.0, 0.5);
uniform vec3 base_color : source_color = vec3(0.1);
uniform float vein_width : hint_range(0.01, 0.5) = 0.1;
uniform float vein_scale : hint_range(1.0, 50.0) = 10.0;
uniform float glow_intensity : hint_range(0.0, 2.0) = 1.0;
uniform float smoothness : hint_range(0.1, 2.0) = 0.5;

uniform bool enable_movement = false;
uniform float movement_speed : hint_range(0.1, 5.0) = 1.0;

varying vec3 world_position;

// Improved hash function
vec3 hash3(vec3 p) {
    p = vec3(dot(p, vec3(127.1, 311.7, 74.7)),
             dot(p, vec3(269.5, 183.3, 246.1)),
             dot(p, vec3(113.5, 271.9, 124.6)));
    return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

// Improved noise function (Gradient Noise)
float noise(vec3 p) {
    vec3 i = floor(p);
    vec3 f = fract(p);
    vec3 u = f * f * (3.0 - 2.0 * f);
    
    return mix(mix(mix(dot(hash3(i + vec3(0.0, 0.0, 0.0)), f - vec3(0.0, 0.0, 0.0)),
                       dot(hash3(i + vec3(1.0, 0.0, 0.0)), f - vec3(1.0, 0.0, 0.0)), u.x),
                   mix(dot(hash3(i + vec3(0.0, 1.0, 0.0)), f - vec3(0.0, 1.0, 0.0)),
                       dot(hash3(i + vec3(1.0, 1.0, 0.0)), f - vec3(1.0, 1.0, 0.0)), u.x), u.y),
               mix(mix(dot(hash3(i + vec3(0.0, 0.0, 1.0)), f - vec3(0.0, 0.0, 1.0)),
                       dot(hash3(i + vec3(1.0, 0.0, 1.0)), f - vec3(1.0, 0.0, 1.0)), u.x),
                   mix(dot(hash3(i + vec3(0.0, 1.0, 1.0)), f - vec3(0.0, 1.0, 1.0)),
                       dot(hash3(i + vec3(1.0, 1.0, 1.0)), f - vec3(1.0, 1.0, 1.0)), u.x), u.y), u.z);
}

// Domain warping function
vec3 warp(vec3 p) {
    vec3 q = vec3(
        noise(p + vec3(0.0, 1.7, 1.3)),
        noise(p + vec3(2.1, 9.4, 0.8)),
        noise(p + vec3(1.3, 2.8, 3.2))
    );
    return p + 0.25 * q;
}

// Enhanced FBM with domain warping
float fbm(vec3 p) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    for (int i = 0; i < 5; i++) {
        vec3 warped_p = warp(p * frequency);
        value += amplitude * abs(noise(warped_p));
        amplitude *= 0.5;
        frequency *= 2.0;
    }
    return value;
}

void vertex() {
    world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
    vec3 scaled_pos = world_position * vein_scale;
	if (enable_movement) {
        scaled_pos += vec3(TIME * movement_speed, TIME * movement_speed * 0.7, TIME * movement_speed * 0.3);
    }
    
    float noise_val = fbm(scaled_pos);
	
	
    // Create vein pattern
    float vein = 1.0 - smoothstep(vein_width, vein_width + smoothness, noise_val);
    vein = pow(vein, 1.0 / smoothness); // Adjust contrast
    vec4 albedo_tex = texture(texture_albedo,UV);
    // Combine base color with vein color
    ALBEDO = mix(albedo_tex.rgb, vein_color, vein);
    
    // Add emission for the glow effect
    EMISSION = vein_color * vein * glow_intensity;
}