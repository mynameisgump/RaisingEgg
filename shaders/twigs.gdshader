shader_type spatial;

uniform sampler2D texture_albedo;
uniform vec2 tile_size = vec2(1.0, 1.0);
uniform float random_seed = 1.0;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

vec2 rotate_90(vec2 uv, int rotations) {
    for (int i = 0; i < rotations; i++) {
        uv = vec2(-uv.y, uv.x);
    }
    return uv;
}

void fragment() {
    // Transform the UV coordinates into a 2D grid based on tile size
    vec2 tile_uv = UV / tile_size;

    // Calculate tile position and local UV within the tile
    vec2 tile_pos = floor(tile_uv);
    vec2 local_uv = fract(tile_uv);

    // Generate a random rotation (0, 1, 2, 3) for each tile
    float rnd = random(tile_pos + random_seed);
    int rotations = int(mod(floor(rnd * 4.0), 4.0));

    // Rotate the UV coordinates within the tile
    local_uv = rotate_90(local_uv - 0.5, rotations) + 0.5;

    // Sample the texture
    vec4 color = texture(texture_albedo, local_uv);

    // Set the final color
    ALBEDO = color.rgb;
}
