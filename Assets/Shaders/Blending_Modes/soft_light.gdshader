shader_type canvas_item;
//uniform float speed = .05;
uniform sampler2D SCREEN_TEXTURE:hint_screen_texture;
uniform float intensity : hint_range(0,1) = 1.0;
uniform sampler2D dissolve_texture : source_color;
uniform float dissolve_value : hint_range(0.0,1.0);

vec4 soft_light(vec4 base, vec4 blend){
	vec4 limit = step(0.5, blend);
	return mix(2.0 * base * blend + base * base * (1.0 - 2.0 * blend), sqrt(base) * (2.0 * blend - 1.0) + (2.0 * base) * (1.0 - blend), limit);
}
void fragment()
{
 vec4 bg_color = texture( SCREEN_TEXTURE, SCREEN_UV );
COLOR.rgb = mix( COLOR, soft_light(bg_color,COLOR), intensity ).rgb;
vec4 main_texture = texture(TEXTURE, UV);
    vec4 noise_texture = texture(dissolve_texture, UV);
    main_texture.a *= floor(dissolve_value + min(1, noise_texture.x));
    COLOR.a *= main_texture.a;
}
