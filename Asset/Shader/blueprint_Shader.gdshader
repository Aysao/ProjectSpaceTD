shader_type spatial;
render_mode blend_mix, unshaded, cull_back;

uniform vec4 color : source_color = vec4(0.2, 0.8, 1.0, 0.5);
uniform float line_density = 20.0;
uniform float line_speed = 1.5;
uniform float glow_strength = 1.0;

varying vec3 world_pos;

void vertex() {
	// Calcul explicite de la position monde
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	// lignes horizontales animées
    float line = sin((world_pos.y * line_density) + TIME * line_speed);
    line = smoothstep(0.3, 1.0, line);

    ALBEDO = color.rgb;
    ALPHA = color.a * line;

    EMISSION = ALBEDO * glow_strength * line;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
