// https://github.com/hughsk/glsl-hsv2rgb/blob/master/index.glsl
vec3 hsv2rgb(vec3 c) {
  vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
  vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
  return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

#define PI 3.1415

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Do everything in screenspace, recentring the resolution where 0, 0 is the centre.
    
    // Coordiante in [-1, 1] range.
    vec2 uv = (fragCoord / iResolution.xy) * 2. - 1.;
    // Resolution in [-res/2 , res/2].
    vec2 resolution = iResolution.xy * 2. - iResolution.xy * 0.5;
    // Coordinate back into [-res/2, res/2] space.
    vec2 coord = uv * resolution;

    float radius = iResolution.y * 0.9;
    vec2 centre = vec2(0.);
    float d = distance(coord, centre);
    
    // Rotates the hue.
    float spin = iTime * 0.1;

    // Give degree in radians around the circle, we only use the first QI to avoid negative values from atan.
    // Using a non-zero mod value splits it up into angular chunks of colour. Otherwise, the colour is fully
    // interpolated.
    // float modValue = 0.1;
    float modValue = 0.;
    float angle = atan(coord.y, coord.x);
    if (modValue > 0.) {
        angle = angle - mod(angle, modValue);  
    }
    float huePercent = (angle / PI) / 2.;
    float hue = huePercent + spin;
    // Uncomment for effect...
    // hue *= iTime;
    // Need to normalize it since we expect [0, 1] as the domain to hsv.
    float saturation = d / radius;
    float value = 1.;
    vec3 hsv = vec3(hue, saturation, value);
    vec3 colour = hsv2rgb(hsv);

    // Antialias multiplier of 4.0 around the edge, used to multiply the colour later.
    float m = 1.0 - smoothstep(radius - 4.0, radius, d);
    colour *= m;
    
    fragColor = vec4(colour, 1.0);
}