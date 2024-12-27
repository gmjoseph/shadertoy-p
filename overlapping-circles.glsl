// 1. define circles and loop over them per pixel
// 2. circles should overlap
// 3. radius can expand and contract (for the entire circle, deterministically) as a function of sin/cos
// 4. produces some kind of moire pattern.

float plotCircle(vec2 uv, float radius, float xOffset) {   
    float lineWidth = 0.005;
    float time = iTime * 0.2;
    radius += xOffset * fract(abs(cos(time)));
    // radius *= fract(abs(cos(time)));
    
    // Moves circles left - right, or up - down inside their circles.
    xOffset *= cos(time);
    
    // TODO
    // 1.7 / 2.0 = half way along the aspect ratio of 640x360.
    // This works but could get weird in certain screen aspect ratios.
    vec2 centre = vec2(1.7/2.0 + xOffset, 0.5);
    
    // Distance to circle
    float d = distance(centre, uv);

    // Gives us the unfilled circle.
    float toCircumference = abs(d - radius);
    
    // 0.002 gives the 'spread' helping with antialiasing.
    return 1.0 - smoothstep(lineWidth - 0.002, lineWidth, toCircumference);
}

float plotCircles(vec2 uv) {
    // Try plotting multiple circles at the uv coordinate, each circle gets a slightly shifted
    // centre and reduced radius.
    float limit = 0.4;
    // Decrease 'divs' to get more nested cicles.
    float divs = 0.2;
    int count = 30;
    
    float baseRadius = 0.48;
    
    
    for (float offset = 0.; offset < limit; offset += divs) {
        for (int i = 1; i <= count; i++) {
            float radius = baseRadius * float(i) / float(count);
            float d = plotCircle(uv, radius, offset);

            if (d > 0.) {
                return d;
            }
        }
    }
    return 0.;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.yy;
    vec2 coord = fragCoord/iResolution.xy;
    float d = plotCircles(uv);
    
    // Coord values are flipped xy ->  yx to avoid too much blending
    // vec3 fgColour = vec3(coord.yx, fgColourAdded) * d;
    // vec3 bgColour = vec3(bgColourAdded, coord.xy) * (1.0 - d);
    
    vec3 fgColour = vec3(0.8, 1., 0.8) * d;
    fgColour = vec3(coord.yx, 1.) * d;
    vec3 bgColour = vec3(coord.xy, 1.) * (1.0 - d);
    bgColour = vec3(0.);
    vec3 colour = bgColour + fgColour;
    
    fragColor = vec4(colour, 1.0);
}