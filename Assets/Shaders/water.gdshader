shader_type canvas_item;


// Global
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_nearest;

//global uniform vec2 WORLD_SUN_POSITION;

// Fluid
uniform vec4  front_colour: source_color;
uniform vec4  middle_colour: source_color;
uniform vec4  back_colour: source_color;
uniform float layer_distort: hint_range(0.0, 1.0) = 0.5;
uniform uint  sin_scale = 1;

uniform float highlights_threshold:    hint_range(0.0, 1.0) = 0.85;
uniform float reflection_strength:     hint_range(0.0, 1.0) = 0.25;
uniform float refraction_strength:     hint_range(0.0, 1.0) = 0.0;
uniform float sun_refraction_scale:    hint_range(0.0, 1.0) = 0.195;
uniform float sun_refraction_mag_min:  hint_range(0.0, 1.0) = 0.8;     // Afternoon
uniform float sun_refraction_mag_max:  hint_range(0.0, 1.0) = 0.9;     // Sunrise/Sunset
uniform float refraction_colour_split: hint_range(0.0, 1.0) = 0.03;

uniform sampler2D waves;
uniform sampler2D highlights_0: hint_default_black;
uniform sampler2D highlights_1: hint_default_black;   // This texture should be a copy of the above, with a slightly smaller resolution.

// Backdrop
uniform float height = 0.36;
uniform float saturation: hint_range(0.0, 2.0) = 1.0;


// Called for every pixel the material is visible on.
void fragment() {
	
	// If we're above a certain height, then discard.
	// Also determine the in-fluid UV.
	float total_height = height;   // Used to be another parameter here...
	if (1.0 - UV.y > total_height)
		discard;
	vec2 fluid_uv             = vec2(UV.x, (UV.y - (1.0 - total_height)) / (1.0 - (1.0 - total_height)));
	vec2 undistorted_fluid_uv = fluid_uv;
	
	// Distort the fluid UV.
	float wave  = texture(waves, undistorted_fluid_uv).r;  // +-
	fluid_uv.x += wave * layer_distort;
	
	// Get the fluid's colour, which is basically two sine waves over a background colour, distorted with a noise texture.
	vec4  colour     = middle_colour;   // TODO: Original multiplier was 10x, modified it to 2 PI for trig reasons.
	float front_wave = (sin( TIME * 0.25 + fluid_uv.x * (PI * 2.0) * float(sin_scale) + 0.0) + 1.0) * 0.5;
	float back_wave  = (sin(-TIME * 0.25 + fluid_uv.x * (PI * 2.0) * float(sin_scale) + 0.5) + 1.0) * 0.5;
	float mag        = 1.0 / 3.0;
	
	bool back_colour_used = false;
	if (fluid_uv.y - mag > front_wave * mag)
		colour = front_colour;
	if (fluid_uv.y < back_wave * mag) {
		colour           = back_colour;
		back_colour_used = true;
	}
	
	// Add highlights to the edges of distant waves.
	float highlights_0_n = (texture(highlights_0, fract(undistorted_fluid_uv + vec2(0.0, 0.0) + TIME * vec2(-0.01, -0.01))).r + 1.0) * 0.5;
	float highlights_1_n = (texture(highlights_1, fract(undistorted_fluid_uv + vec2(0.5, 0.0) + TIME * vec2( 0.01,  0.01))).r + 1.0) * 0.5;
	if ((highlights_0_n + highlights_1_n) * 0.5 > highlights_threshold)
		colour = vec4(1.0);
	
	// Add screen reflections with refractions.
	float refraction_0     = texture(waves, fract(undistorted_fluid_uv + TIME * vec2(-0.01, 0.0))).r;
	float refraction_1     = texture(waves, fract(undistorted_fluid_uv + TIME * vec2( 0.01, 0.0))).r;
	float refraction       = (refraction_0 + refraction_1) * 0.5;
	vec2 reflect_uv        = vec2(SCREEN_UV.x, mix(1.0 - total_height, 0.0, undistorted_fluid_uv.y));
	     reflect_uv.x     += refraction * refraction_strength;
	     reflect_uv.x     -= refraction_strength * 0.5;
	vec4 screen            = texture(SCREEN_TEXTURE, reflect_uv);
	colour = mix(colour, screen, reflection_strength);
	
	// Add the sun's refraction across the surface of the fluid.
	//float proximity_to_sun = distance(WORLD_SUN_POSITION.x, SCREEN_UV.x);
	float refraction_sun   = (refraction + 1.0) * 0.5 * sun_refraction_scale;
	//if (refraction_sun > proximity_to_sun) {
		//float strength = (refraction_sun - proximity_to_sun) / (1.0 - proximity_to_sun);
		//float magnitude;
		
		//if (1.0 - WORLD_SUN_POSITION.y < total_height) {   // Sun below horizon.
		//	float how_far_under = (WORLD_SUN_POSITION.y - (1.0 - total_height)) / total_height;
		//	magnitude = mix(sun_refraction_mag_max, 0.0, smoothstep(0.0, 1.0, how_far_under));
		//} else {   // Sun above horizon.
		//	float how_far_above = ((1.0 - total_height) - WORLD_SUN_POSITION.y);
		//	magnitude = mix(sun_refraction_mag_max, sun_refraction_mag_min, smoothstep(0.0, 1.0, how_far_above));
		//}
		
		//if (strength > (1.0 - magnitude)) {
		//	float refractivity = (strength - (1.0 - magnitude)) / (1.0 - (1.0 - magnitude));
		//	vec4  lower_colour = front_colour;
			
		//	if (back_colour_used)
		//		lower_colour = mix(middle_colour, screen, reflection_strength);
			
		//	colour = mix(lower_colour, vec4(1.0), step(refraction_colour_split, refractivity));
		//}
//	}
	
	// SATURATION
	// positive = more saturation
	// negative = less saturation
	// 0.0 = unchanged
	// -1.0 = grayscale
	// < -1.0 = color inversion
	float saturation_scale = mix(-1.0, 0.0, saturation);
	float average = (colour.x + colour.y + colour.z) / 3.0;
	float xd = average - colour.r;
	float yd = average - colour.g;
	float zd = average - colour.b;
	colour.r += xd * -saturation_scale;
	colour.g += yd * -saturation_scale;
	colour.b += zd * -saturation_scale;
	
	COLOR = colour;
}