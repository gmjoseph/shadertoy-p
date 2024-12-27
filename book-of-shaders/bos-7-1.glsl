// NOTE and WARNING!

// This only draws an ellipse due to stretching, and not because we're actually
// making an ellipse. we have to account for this being [0, 0] => [1, 1] but that 1 for the width
// is something larger than the height.

float onEllipse(vec2 uv) {
    vec2 centre = vec2(0.5, 0.5);
    float radius = 0.41;
    float d = distance(uv, centre);
    // kind of antialised.
    return 1.0 - smoothstep(0.003, 0.005, abs(d - radius));
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
    float d = onEllipse(uv);
    vec3 line = d * vec3(0.0, 1.0, 0.0);
    
    // Remove any colour contributions for areas that the line would pass through.
    colour = (1.0 - d) * colour;
    
    // Add the colour contributions of the line to fill in those that were removed in the previous line.
    colour += line;
    fragColor = vec4(colour, 1.0);
}

// 
// float inEllipse(vec2 uv) {
//     vec2 centre = vec2(0.5, 0.5);
//     float radius = 0.41;
//     float d = distance(uv, centre);
//     // kind of antialised.
//     if (d < radius) {
//         return 1.0;
//     }
//     return 0.0;
//     // return 1.0 - smoothstep(0.003, 0.005, abs(d - radius));
// }
// 
// void mainImage( out vec4 fragColor, in vec2 fragCoord )
// {
//     // Normalized pixel coordinates (from 0 to 1)
//     vec2 uv = fragCoord/iResolution.xy;
//     
//     // Background colour
//     vec3 colour = vec3(smoothstep(0.1, 0.9, uv.x));
//        
//     // Line colour
//     // everything is discarded by step automatically if the distance from the parabolic equation
//     // y = x^2 is too far beyond the step value of 0.01. If we want a thicker line we can increase
//     // the delta of what's included. In other words, we plot the line with a distance function.
//     float d = inEllipse(uv);
//     vec3 line = d * vec3(0.0, 1.0, 0.0);
//     
//     // Remove any colour contributions for areas that the line would pass through.
//     colour = (1.0 - d) * colour;
//     
//     // Add the colour contributions of the line to fill in those that were removed in the previous line.
//     colour += line;
//     fragColor = vec4(colour, 1.0);
// }