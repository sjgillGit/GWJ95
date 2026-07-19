shader_type spatial;
varying vec3 pos;
//varying vec4 pos;
render_mode cull_disabled;

uniform sampler3D noise_tex;

varying vec3 world_pos;
uniform float height;
uniform float dissolve_height : hint_range(0.0, 1.0, 0.01);
uniform float glow_thickness : hint_range(0.0, 0.1, 0.01);
uniform float noise_scale : hint_range(0.0, 1.0, 0.01);
uniform vec4 base_color : source_color;
uniform vec4 edge_color : source_color;
uniform vec4 edge_color2 : source_color;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0)).xyz;
	world_pos.y = (world_pos.y + height)/height-1.0;

}


void fragment() {
	ALBEDO = base_color.rgb;
	// Dissolving edge
	float noise = texture(noise_tex, world_pos+TIME/-30.0).r;
	noise = noise * noise_scale - 0.5 * noise_scale;
	noise += world_pos.y;
	ALPHA_SCISSOR_THRESHOLD = 0.5;
	float cutoff = step(noise, dissolve_height);
	ALPHA = cutoff;
	
	// Emission
	noise = texture(noise_tex, world_pos+TIME/-20.0).r;
	noise = noise * noise_scale - 0.5 * noise_scale;
	noise += world_pos.y;
	vec3 emit = (1.0-step(noise, dissolve_height-glow_thickness*0.5)) * edge_color2.rgb; // Inner color
	emit += (1.0-step(noise, dissolve_height-glow_thickness)) * edge_color.rgb; // Outer color
	EMISSION = emit;



}
