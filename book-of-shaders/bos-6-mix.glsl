void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    
    vec3 a = vec3(1.0, 0.0, 0.0);
    vec3 b = vec3(0.0, 1.0, 0.0);
    vec3 c = vec3(0.0, 0.0, 1.0);
      
    // from [-1, 1] to [0, 1]
    float percent = (sin(iTime * 0.1) + 1.0) / 2.0;
    float adjustedPercent = 0.0;
    // however we have three colours, so we need to chunk it into 3 and then swap or something?
    
    vec3 colour = vec3(0.0);
    
    // TODO
    // theres gotta be a better way to interpolate between these values (easing function?)
    
    if (percent <= 1.0 / 2.0) {
        adjustedPercent = percent * 2.0;
        colour = mix(a, b, adjustedPercent);
    } else  {
        adjustedPercent = (percent - 1.0 / 2.0) * 2.0;
        colour = mix(b, c, adjustedPercent);
    }
    
    // Output to screen
    fragColor = vec4(colour, 1.0);
}