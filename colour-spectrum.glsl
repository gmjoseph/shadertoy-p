// https://github.com/hughsk/glsl-hsv2rgb/blob/master/index.glsl
vec3 hsv2rgb(vec3 c) {
  vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
  vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
  return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Hue along the x-axis
    // Saturation along the y-axis
    // Value is determined by iTime
    vec2 uv = fragCoord/iResolution.xy;
       
    // Gives us the interpolated pattern, we now need to add a threshold so it doesn't
    // interpolate.
    // To do that, we want to clamp on the x and y coordinates. Basically if they're 0 -> 0.1
    // clamp to 0, if it's 0.1 -> 0.2, clamp to 0.1, etc. Basically it's a step function on the
    // x and y axes.
    // This works by finding the modulo where uv % 0.05 == 0, and if it doesn't, we get to subtract
    // that amount from the uv coordinate, basically stepping it back.
    // Smaller values mean more divisions.
    float modValue = 0.05; // * abs(sin(iTime));
    float mx = mod(uv.x, modValue);
    float my = mod(uv.y, modValue); // - 0.1;
    // - 0.1 Ensures that the last row isn't white. Otherwise we end up with 0s on the last row
    // becomes all white
    uv -= vec2(mx, my);
    // Scrolls the entire thing left.
    uv.x += iTime * 0.1;
    
    // Fades the entire saturation in and out.
    // uv.y -= sin(iTime * 0.25);
    
    // float value = abs(sin(iTime));
    float value = 1.;
    

    vec3 colour = hsv2rgb(vec3(uv, value));
    // float chunk = step(0.01, mod(uv.x, 0.05));
    
    fragColor = vec4(colour, 1.0);
}