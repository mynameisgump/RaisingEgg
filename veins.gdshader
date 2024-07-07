shader_type spatial;

const float TAO = 6.2831853;

uniform float scale = 1.0; // Controls the size of the pattern
uniform float time_scale = 1.0; // Controls the speed of the animation
uniform float warp_amount = 0.5; // Controls the amount of domain warping

// Hash function for pseudo-random numbers
vec2 hash2(vec2 p) {
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
    return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

// Gradient noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(dot(hash2(i + vec2(0.0, 0.0)), f - vec2(0.0, 0.0)),
                   dot(hash2(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0)), u.x),
               mix(dot(hash2(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0)),
                   dot(hash2(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0)), u.x), u.y);
}

vec2 R(vec2 u, float a) { 
    return mat2(vec2(cos(a), sin(a)),vec2(-sin(a), cos(a))) * u; 
}

float N(vec2 uv, float t, float p) {
    vec2 a = vec2(0.0);
    vec2 res = vec2(0.0);
    float s = 10.0;
    for (int j = 0; j < 30; j++) {
        uv = R(uv, 1.0);
        a = R(a, 1.0);
        vec2 L = uv * s + float(j) + a - t;
        a += cos(L);
        res += (0.5 + 0.5 * sin(L)) / s;
        s *= (1.2 - 0.07 * p);
    }
    return res.x + res.y;
}

void fragment() {
    // Apply domain warping
    vec2 warped_uv = UV * scale + warp_amount * vec2(
        noise(UV * scale + TIME * 0.1),
        noise(UV * scale + TIME * 0.1 + vec2(1.74, 5.23))
    );
    
    // Use fractional part for tiling
    vec2 tiled_uv = fract(warped_uv);
    
    float T = mod(TIME * time_scale * TAO, TAO);
    float H = clamp(0.5 * sin(T) * sin(T / 2.0) * exp(-T / 4.0) + 0.5, 0.0, 1.0);
    float n = N(tiled_uv, H * 5.0, 0.1) * 1.15;
    vec3 C = mix(
        mix(vec3(0.0), vec3(1.0, 0.0, 0.2), smoothstep(1.0, 1.0, n)),
        mix(vec3(1.0, 0.0, 0.2), vec3(1.0, 0.635, 0.0), smoothstep(0.5, 1.0, n)),
        smoothstep(0.0, 1.0, n)
    );
    
    ALBEDO = C;
    EMISSION = C * 0.5;
}