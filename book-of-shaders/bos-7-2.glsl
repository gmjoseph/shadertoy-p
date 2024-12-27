struct Circle {
    // centre and radius should be in screenspace
    vec2 centre;
    float radius;
};



float inCircle(vec2 uv) {
    // Do everything in screenspace and then covert back.
    // This avoids problems of stretching because if we normalize on 1,1 we
    // have a much larger width than height.

    Circle circles[] = Circle[](
        Circle(
            vec2(iResolution.x * 0.5, iResolution.y * 0.5),
            100.0
        ),
        Circle(
            vec2(iResolution.x * 0.25, iResolution.y * 0.25),
            50.0
        )
    );
    
    for (int i = 0; i < circles.length(); i++) {
        Circle circle = circles[i];

        vec2 centre = circle.centre;
        float radius = circle.radius;
        float d = distance(uv, centre);
        // Kind of antialising around the edges..
        if (d < radius) {
            return 1.0 - smoothstep(radius - 1.0, radius, d);
        }
        
        // Doing this causes the centre to be faded out. This is why we invert it when returning
        // the actual value above.
        // if (d < radius) {
        //    return smoothstep(radius - 50.0, radius, d);
        // }
    }
    
    // No circle was hit.
    return 0.0;
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
    float d = inCircle(fragCoord);
    vec3 line = d * vec3(0.0, 1.0, 0.0);
    
    // Remove any colour contributions for areas that the line would pass through.
    colour = (1.0 - d) * colour;
    
    // Add the colour contributions of the line to fill in those that were removed in the previous line.
    colour += line;
    fragColor = vec4(colour, 1.0);
}