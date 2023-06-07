shader_type spatial;
render_mode cull_disabled, depth_draw_opaque;

uniform vec4 color: source_color;
uniform vec3 scale = vec3(1,1,1);
uniform float wind_strength : hint_range(0.1, 1.0, 0.02);
uniform float wind_speed : hint_range(0.5, 2.0, 0.1);

void vertex(){
NORMAL = vec3(0.0, 1.0, 0.0);
	VERTEX.x += sin(NODE_POSITION_WORLD.x + TIME * wind_speed + UV.y) * ( 1.0 - UV.y) * wind_strength;
	VERTEX.z += cos(NODE_POSITION_WORLD.z + TIME * wind_speed + UV.y) * ( 1.0 - UV.y) * wind_strength;
	VERTEX = VERTEX * vec3(scale.x, scale.y, scale.z);
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(vec4(normalize(cross(vec3(0.0, 1.0, 0.0), INV_VIEW_MATRIX[2].xyz)), 0.0), vec4(0.0, 1.0, 0.0, 0.0), vec4(normalize(cross(INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0), MODEL_MATRIX[3]);
}

void fragment(){
	ALBEDO = color.rgb;
}
