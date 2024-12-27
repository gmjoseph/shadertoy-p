float onCurve(vec2 uv) {

    // if we subtract uv x from y we get a 1:1 relationship so it's a line.
    // if we want it to curve like an s-curve, we can interpolate the y values
    // and then subtract x from them to get curvature.
    float y = smoothstep(0.1, 0.9, uv.x);
    return 1.0 - step(0.01, abs(y - uv.y));
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
    float d = onCurve(uv);
    vec3 line = d * vec3(0.0, 1.0, 0.0);
    
    // Remove any colour contributions for areas that the line would pass through.
    colour = (1.0 - d) * colour;
    
    // Add the colour contributions of the line to fill in those that were removed in the previous line.
    colour += line;
    fragColor = vec4(colour, 1.0);
}