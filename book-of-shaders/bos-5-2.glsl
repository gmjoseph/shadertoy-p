float onParabola(vec2 uv) {
    // need to shift the parabola or else we only get everything left of the y-axis at x = 0.
    // so if x is [0, 1] it's now [-1.0, 1.0]
    float x = uv.x * 2.0 - 1.0;
    float y = uv.y;
    return 1.0 - step(0.01, abs(y - x * x));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    
    // Background colour
    vec3 colour = vec3(smoothstep(0.1, 0.9, uv.x));
       
    // Line colour
    // everything is discarded by step automatically if the distance from the parabolic equation
    // y = x^2 is too far beyond the step value of 0.01. If we want a thicker line we can increase
    // the delta of what's included. In other words, we plot the line with a distance function.
    float d = onParabola(uv);
    vec3 line = d * vec3(0.0, 1.0, 0.0);
    
    // Remove any colour contributions for areas that the line would pass through.
    colour = (1.0 - d) * colour;
    
    // Add the colour contributions of the line to fill in those that were removed in the previous line.
    colour += line;
    fragColor = vec4(colour, 1.0);
}