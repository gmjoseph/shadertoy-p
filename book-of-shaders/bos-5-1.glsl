void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    
    // Background colour
    vec3 colour = vec3(smoothstep(0.1, 0.9, uv.x));
       
    // Line colour
    // everything is discarded by step automatically if the distance from the linear equation
    // y = x is too far beyond the step value of 0.02. If we want a thicker line we can increase
    // the delta of what's included. In other words, we plot the line with a distance function.
    float d = 1.0 - step(0.02, abs(uv.y - uv.x));
    vec3 line = d * vec3(0.0, 1.0, 0.0);
    
    // Remove any colour contributions for areas that the line would pass through.
    colour = (1.0 - d) * colour;
    
    // Add the colour contributions of the line to fill in those that were removed in the previous line.
    colour += line;
    fragColor = vec4(colour, 1.0);
}