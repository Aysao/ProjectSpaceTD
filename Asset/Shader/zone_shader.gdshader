shader_type spatial;

render_mode cull_back, unshaded, depth_draw_always;

uniform vec4 smoke_color = vec4(0.6, 0.0, 0.8, 0.5);
uniform float speed = 0.5;
uniform float scale = 1.5;
uniform float detail_scale = 6.0;
uniform float detail_intensity = 0.25;
uniform float alpha_min = 0.15;

varying vec2 world_uv;

// Hash / noise
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0,0.0));
    float c = hash(i + vec2(0.0,1.0));
    float d = hash(i + vec2(1.0,1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x)
         + (c - a) * u.y * (1.0 - u.x)
         + (d - b) * u.x * u.y;
}

void vertex() {
    vec3 world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    world_uv = world_pos.xz;
}

void fragment() {
    float n = noise(world_uv * scale + TIME * speed);
    float detail = noise(world_uv * detail_scale + TIME * speed * 1.5);

    float alpha = max(smoothstep(0.4, 0.6, n), alpha_min);
    vec3 final_color = smoke_color.rgb - detail * detail_intensity;

    ALBEDO = final_color;
    ALPHA = alpha * smoke_color.a;
}
