shader_type sky;

uniform vec4 color0: source_color;
uniform vec4 color1: source_color;
uniform vec4 color2: source_color;
uniform vec4 color3: source_color;

uniform float skyvalue : hint_range(0.0, 4.0, 0.1);

// CODE USAGE
uniform float rotation_speed = 0.3;
uniform float size = 100.0;
uniform float prob = 0.9;

// NOISES
uniform float cell_amount = 1.0;
uniform vec2 period = vec2(1.0);
uniform int amount = 32;
uniform float seed;

// ----------------------------------------------------------------------------- METHODS

vec2 modulo(vec2 divident, vec2 divisor){
	vec2 positiveDivident = mod(divident, divisor) + divisor;
	return mod(positiveDivident, divisor);
}

vec2 random(vec2 value){
	value = vec2( dot(value, vec2(127.1,311.7) ),
				  dot(value, vec2(269.5,183.3) ) );
	return -1.0 + 2.0 * fract(sin(value + vec2(seed)) * 43758.5453123);
}

float seamless_noise(vec2 uv, vec2 _period) {
	uv = uv * float(cell_amount);
	vec2 cellsMinimum = floor(uv);
	vec2 cellsMaximum = ceil(uv);
	vec2 uv_fract = fract(uv);
	
	cellsMinimum = modulo(cellsMinimum, _period);
	cellsMaximum = modulo(cellsMaximum, _period);
	
	vec2 blur = smoothstep(0.0, 1.0, uv_fract);
	
	vec2 lowerLeftDirection = random(vec2(cellsMinimum.x, cellsMinimum.y));
	vec2 lowerRightDirection = random(vec2(cellsMaximum.x, cellsMinimum.y));
	vec2 upperLeftDirection = random(vec2(cellsMinimum.x, cellsMaximum.y));
	vec2 upperRightDirection = random(vec2(cellsMaximum.x, cellsMaximum.y));
	
	vec2 fraction = fract(uv);
	
	return mix( mix( dot( lowerLeftDirection, fraction - vec2(0, 0) ),
                     dot( lowerRightDirection, fraction - vec2(1, 0) ), blur.x),
                mix( dot( upperLeftDirection, fraction - vec2(0, 1) ),
                     dot( upperRightDirection, fraction - vec2(1, 1) ), blur.x), blur.y) * 0.8 + 0.5;
}

float fbm(vec2 uv) {
    int octaves = 8;
    float amplitude = 0.5;
    float frequency = 5.0;
	float value = 0.0;
	
    for(int i = 0; i < octaves; i++) {
        value += amplitude * seamless_noise(frequency * uv, period);
        amplitude *= 0.6;
        frequency *= 1.5;
    }
    return value;
}


// ----------------------------------------------------------------------------- FUNCTIONS
void sky()
{
// ------------------------------- PIXELATE ------------------------------------------------
	vec2 skyUV = -EYEDIR.xz * (EYEDIR.y * 0.5) ;
	vec2 grid = floor(skyUV * float(amount)) / float(amount);
		
	vec2 Offset;
	Offset.x = 0.5f * (grid.x - 64.0) - TIME * rotation_speed;
	Offset.y = 0.5f * (grid.y - 64.0) + TIME * rotation_speed;
		
	// ------------------------------- FBM -----------------------------------------------------
	vec2 layer1;
	layer1.x = fbm(grid * fbm(grid * 1.26));
	layer1.y = fbm(grid * fbm(grid * 1.2));
		
	float f = (fbm(grid + layer1 - Offset));
	vec4 fmb_noise = vec4(vec3(f*f*f+1.5*f*f), 1.0);
		
	fmb_noise = clamp(fmb_noise, vec4(0.0), vec4(1.0));
		
	// ------------------------------- COLOR ---------------------------------------------------
	float sun = distance(EYEDIR.xyz, LIGHT0_DIRECTION);
	float sunDisc = 1.0 - clamp(sun / 0.25, 0.0, 1.0);
	sunDisc = roundEven(sunDisc);
	
	// day color gradient
	vec3 gradientDay = mix(color0.rgb, color1.rgb, clamp(EYEDIR.y, 0.0, 1.0));
	vec3 gradientNight = mix(color0.rgb / 16.0, color1.rgb / 16.0, clamp(EYEDIR.y, 0.0, 1.0));
	vec3 skyGradients = mix(gradientNight, gradientDay, clamp(LIGHT0_DIRECTION.y, 0.0, 1.0));
	
	vec3 gradientCloudsDay = mix(color2.rgb, color3.rgb, clamp(EYEDIR.y, 0.0, 1.0));
	vec3 gradientCloudsNight = mix(color2.rgb/ 8.0, color3.rgb/ 8.0, clamp(EYEDIR.y, 0.0, 1.0));
	vec3 skyCloudGradients = mix(gradientCloudsNight, gradientCloudsDay, clamp(LIGHT0_DIRECTION.y, 0.0, 1.0));
	
	
	COLOR = fmb_noise.rgb;
		
	float pixel_value = (fmb_noise.r + fmb_noise.g + fmb_noise.b) / 3.0;
	if (pixel_value < 0.6) COLOR=skyGradients.rgb;
	if (pixel_value >= 0.6 && pixel_value < 0.7) COLOR=skyGradients.rgb;
	if (pixel_value >= 0.7 && pixel_value < 0.9) COLOR=skyCloudGradients.rgb;
	if (pixel_value >= 0.9 && pixel_value <= 1.0) COLOR=skyCloudGradients.rgb;
	
	COLOR += sunDisc;
	
	if (AT_CUBEMAP_PASS){
		COLOR = mix(skyGradients.rgb, vec3(1.0), skyvalue/2.0);
	}
}