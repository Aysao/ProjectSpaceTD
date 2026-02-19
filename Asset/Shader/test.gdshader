shader_type spatial;

render_mode unshaded, cull_back ,depth_draw_always, blend_mix;
varying vec3 var_world_vector;

uniform vec3 position;
uniform float edge_distance = 1.0;
uniform vec4 wave_color : source_color = vec4(0.5,0.5,0.5,1.0);
uniform vec4 noise_color : source_color = vec4(0.2,0.2,0.2,1.0);
uniform sampler2D noise : repeat_enable;
uniform float line_width = 5.0;
uniform bool Activated = false;
uniform float minismooth = 0.0;
uniform float maxismooth = 0.1;

float soft_light(float base, float blend){
	float limit = step(0.5, blend);
	return mix(2.0 * base * blend + base * base * (1.0 - 2.0 * blend), sqrt(base) * (2.0 * blend - 1.0) + (2.0 * base) * (1.0 - blend), limit);
}

void vertex() {
	vec3 global_position = vec4(MODEL_MATRIX * vec4(VERTEX,1.0)).xyz;
	var_world_vector =  position - global_position;
	
}

void fragment() {
	vec2 center = var_world_vector.xz;
	float distance = length(center);
	
	float renoise = texture(noise,vec2(length(UV.x) - TIME * 0.1, length(UV.y) - TIME * 0.1)).r;
	
	
	float start_radius = step(edge_distance ,distance);
	
	float ring = abs(distance * line_width) * (-1.0);
	float pulse = sin(ring + (TIME * 2.0));
	ring = smoothstep(0.2, 0.8, pulse);
	float angle = atan(center.y, center.x);
	angle = (angle + PI) / (2.0 * PI);
	float circle = angle  * 0.2 + TIME * 1.0;
	
	if (distance < edge_distance && Activated){
		ALBEDO = vec3(ring) * wave_color.rgb * renoise;
		ALPHA =  ring * wave_color.a;
	}
	else{
		ALBEDO = smoothstep(minismooth , maxismooth, renoise * noise_color.rgb);
		ALPHA = sin( smoothstep(minismooth, maxismooth,renoise) - distance + 1.0 + edge_distance);
		ALPHA *= start_radius;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
