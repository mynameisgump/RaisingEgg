shader_type spatial;

uniform sampler2D texture_albedo;
uniform vec2 uv_scale = vec2(1.0, 1.0);
uniform vec2 uv_offset = vec2(0.0, 0.0);

void fragment() {
    vec2 uv = UV * uv_scale;
    uv += uv_offset * floor(UV * uv_scale);
    ALBEDO = texture(texture_albedo, uv).rgb;
}
