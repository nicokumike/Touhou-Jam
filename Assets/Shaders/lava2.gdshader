shader_type canvas_item;

uniform sampler2D noise1 ;
uniform sampler2D noise2 ;
uniform vec2 scroll1 = vec2(0.05, 0.05);
uniform vec2 scroll2 = vec2(-0.05, -0.05);
uniform float distortion_stregth : hint_range(-1,1) = 0.2;
uniform sampler2D tone_color ;//better use gradient
uniform vec4 top_color : source_color;
uniform float light_start: hint_range(0.0, 1.0) = 0.275;
uniform float light_end: hint_range(0.0, 1.0) = 0.4;

void fragment() {
	float depth = texture(noise1, UV + scroll1 * TIME).r
		* texture(noise2, UV + scroll2 * TIME).r;
	vec4 water_col = texture(tone_color, UV + distortion_stregth * vec2(depth));
	vec4 top_light = smoothstep(light_start, light_end, depth) * top_color;
	COLOR = water_col + top_light;
	COLOR.a = 1.0;
	}