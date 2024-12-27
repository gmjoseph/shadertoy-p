float inPolar(vec2 uv) {
    // Convert [0, 1] to [-2, -2]
    uv *= 2.;
    uv -= vec2(640.0/360.0, 1.);

    float time = iTime * 0.1;
    // time = 1.;
    uv *= vec2(cos(time), sin(time));
    
    // Cartesian to polar
    float theta = atan(uv.y, uv.x);
    // shorten the length
    float r = length(uv) * 3.;
    // Polar function.
    float fr = cos(8. * theta);

   
    // Large value means more colour falloff at edges.
    float spread = 0.5;
    float ret;
    ret = 1. - smoothstep(fr - spread, fr, r);
    
    // Cool halo like efect due to not clamping.
    ret = 2. - abs(r - fr);
    // ret = 1. - abs(r - fr);
    
    // If we want it to be on the line exactly
    // ret = 1.0 - smoothstep(0.075, 0.1, abs(fr - r));
    return ret;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1) but keep the aspect ratio
    // of y.
    vec2 uv = fragCoord/iResolution.yy;
    
    // Background colour
    vec3 colour = vec3(1., uv);
       
    // Line colour
    // everything is discarded by step automatically if the distance from the parabolic equation
    // y = x^2 is too far beyond the step value of 0.01. If we want a thicker line we can increase
    // the delta of what's included. In other words, we plot the line with a distance function.
    float d = inPolar(uv);
    vec3 shape = d * vec3(uv, 1.);
    
    // Remove any colour contributions for areas that the line would pass through.
    colour = (1.0 - d) * colour;
    
    // Add the colour contributions of the line to fill in those that were removed in the previous line.
    colour += shape;

    fragColor = vec4(colour, 1.0);
}