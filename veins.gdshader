shader_type spatial;

const float TAO = 6.2831853;

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
    // Use UV coordinates instead of screen coordinates
    vec2 U = UV;
    
    float T = mod(TIME * TAO, TAO);
    float H = clamp(0.5 * sin(T) * sin(T / 2.0) * exp(-T / 4.0) + 0.5, 0.0, 1.0);
    float n = N(U, H * 5.0, 0.1) * 1.15;
    vec3 C = mix(
        mix(vec3(0.0), vec3(1.0, 0.0, 0.2), smoothstep(1.0, 1.0, n)),
        mix(vec3(1.0, 0.0, 0.2), vec3(1.0, 0.635, 0.0), smoothstep(0.5, 1.0, n)),
        smoothstep(0.0, 1.0, n)
    );
    
    ALBEDO = C;
    EMISSION = C * 0.5; // Add some emission for a glowing effect
}