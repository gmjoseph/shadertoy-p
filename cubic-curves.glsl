// 1. define circles -> different shapes and loop over the shape -> shape transformation for
// for each pixel.
// 2. shapes should overlap a bit but transform as we move along the x axis
// 3. shape scale can expand and contract (for the entire shape deterministically) as a function of sin/cos
// 4. produces some kind of overlapped pattern along a polynomial or random function.

// Deterministic random function
// https://stackoverflow.com/a/4275343
float rand(vec2 co){
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

float plotCircle(vec2 uv, float radius, vec2 offset) {   
    float lineWidth = 0.002;
    float time = iTime * 0.2;
    
    // radius = offset.x * fract(abs(cos(time)));
    // offset.x *= cos(time);
    // offset.y *= sin(time);

    vec2 centre = vec2(radius + offset.x, radius + offset.y);
    
    // Distance to circle
    float d = distance(centre, uv);

    // Gives us the unfilled circle.
    float toCircumference = abs(d - radius);
    
    // 0.002 gives the 'spread' helping with antialiasing.
    return 1.0 - smoothstep(lineWidth - 0.002, lineWidth, toCircumference);
}

float plotShape(vec2 uv, vec2 offset) {
    // If we use a parametric for this it'd no longer x dist to y and stuff, we'll look at
    // the x distance and y distance discretely and if they're both sufficiently close then
    // we can plot it.
    // Maybe this isn't any different from the centre, uv distance above?


    // TODO
    // Set it up with 4 bezier curves, we'll need to use them in parametrized x(t) and y(t)
    // format (consider eliminating the parameter if possible?) which means looping again
    // for a variety of t values, and then testing uv.xy's distance from both x and y.
    float time = iTime * 0.2;
    
    offset.x *= sin(time);
    offset.y *= cos(time);

    // Scale from [0, 1] to [-1, 1] to get both sides of the y-axis.
    vec2 coord = uv * 2. - vec2(1.) + offset;
    float x = coord.x; // + offset.x;
    float y = coord.y;

    // We need really small coefficients because the pixel range is only [0, 1].
    // x^3 + x^2
    float fx = offset.y * pow(x, 3.) + offset.x * pow(x, 2.);
    float bias = 0.0025;
    float d = 1. - smoothstep(bias, bias * 2., abs(y - fx));
    
    return d;
}

// No way to do this fast enough with enough t values without the framerate taking a beating.
float plotBezier(vec2 uv) {   
    float bias = 0.0025;

    for (float t = 0.; t <= 1.; t += 0.009) {
        float minusT = 1. - t;
        float x = 0.110 * pow(minusT, 3.) + 0.025 * 3. * pow(minusT, 2.) + .210 * 3. * minusT * pow(t, 2.) + .210 * pow(t, 3.);
        float y = 0.150 * pow(minusT, 3.) + 0.190 * 3. * pow(minusT, 2.) + .250 * 3. * minusT * pow(t, 2.) + .03 * pow(t, 3.);
        
        vec2 xy = vec2(x, y);

        float bias = 0.0025;
        float d = 1. - smoothstep(bias, bias * 2., distance(uv, xy));
        if (d > 0.) {
            return d;
        }
    }
    
    return 0.;
}

float plotShapes(vec2 uv) {
    // Try plotting multiple shapes at the uv coordinate, each circle gets a slightly shifted
    // centre and reduced radius.
    int count = 50;
    
    // TODO
    // Replace this with movement along the x-axis. Not based on uv.x but
    // along [0, 1] to decide which shape we're trying to intersect with.
    // We can determine the centre of the shape per shape.
    for (int i = 1; i < count; i++) {
        float percent = float(i) / float(count);
        vec2 offset = vec2(percent, percent);
        // avoid division by 0.
        float r = rand(offset);
        offset.x *= r;
        offset.y *= (1./r);
        float d = plotShape(uv, offset);

        if (d > 0.) {
            return d;
        }
    }
    return 0.;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.yy;
    vec2 coord = fragCoord/iResolution.xy;
    float d = plotShapes(uv);
    
    vec4 fgColour = vec4(coord.yx, 1., 1.) * d;
    vec4 bgColour = vec4(0.);
    vec4 colour = bgColour + fgColour;
    
    fragColor = colour;
}