// The amount of flip boolean values in each array is directly related to the count,
// which is itself related to the modValue since count = 1.0 / modValue.
// Make this smaller for more lines, larger for fewer.
float modValue = 0.08;
// 0.04 is also a cool value but it messes with the nested circles so we may need a smarter
// way to compute those nested circles 'divs' and 'limit' (in plotCircles)
// relative to the mod value.

// Whether to move circles in circles up-down/left-right or rotate them
// in some direction
bool circularMotion = true;

// Deterministic random function
// https://stackoverflow.com/a/4275343
float rand(vec2 co){
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

vec2 flipAndAxisOffset(vec2 boxIndices, float offset) {
    // TODO
    // If we want both to rotate we need offsets for both axes.

    float random = rand(boxIndices);
    
    if (circularMotion) {    
        vec2 motion;
        if (random < 0.25) {
            motion = vec2(offset, offset);
        } else if (random < 0.5) {
            motion = vec2(offset, -offset);
        } else if (random < 0.75) {
            motion = vec2(-offset, offset);
        } else {
            motion = vec2(-offset, -offset);
        }
        // We rely on offset length for radius in plotCircle so we should scale it down
        // TODO
        // Find a more precise way to come up with this multiple.
        motion *= 0.75;
        return motion;
    }
 
    if (random < 0.25) {
        // Offset on y
        return vec2(0., offset);
    } else if (random < 0.5) {
        // Offset on y and flip
        return vec2(0., -offset);
    } else if (random < 0.75) {
        // Offset on x
        return vec2(offset, 0.);
    }
    
    // Offset on x and flip
    return vec2(-offset, 0.);
}

float plotCircle(vec2 uv, vec2 offset) {   
    float lineWidth = modValue * 0.03;
    // Halfway across the square/box gives the outermost circle's radius.
    float centreOffset = modValue * 0.5;
    // Only the x or the y offset are set at a time, so taking the length of
    // the offset vector gives us one single offset value.
    float radiusOffset = length(offset);
    
    float radius = centreOffset - (radiusOffset * 2.) - lineWidth;
    
    // Moves circles left - right, or up - down inside their circles.
    offset.x *= cos(iTime);
    offset.y *= sin(iTime);
    
    
    float x = uv.x - mod(uv.x, modValue) + centreOffset + offset.x;
    float y = uv.y - mod(uv.y, modValue) + centreOffset + offset.y;
    vec2 centre = vec2(x, y);
    
    // Try and rotate all the circles by moving the centre around.
    //centre = centre + centre * (0.25 * vec2(cos(iTime), sin(iTime)));
    
  
    // Distance to circle
    float d = distance(centre, uv);
    // Gives us the unfilled circle.
    float toCircumference = abs(d - radius);
    
    // 0.0015 gives the 'spread' helping with antialiasing.
    return 1.0 - smoothstep(lineWidth - 0.0015, lineWidth, toCircumference);
}

float plotCircles(vec2 uv, vec2 boxIndices) {
    // Try plotting multiple circles at the uv coordinate, each circle gets a slightly shifted
    // centre and reduced radius.
    float limit = 0.015;
    // Decrease 'divs' to get more nested cicles.
    float divs = 0.0025;
    
    // Also a nice combination.
    // float limit = 0.025;
    // float divs = 0.0015;
    for (float offset = 0.; offset < limit; offset += divs) {
        // Randomly flip each box deterministically based on it's index in the grid.
        // Although this random function gets called per circle offset, it should deterministically
        // give back the same flip and offset values despite looping because the boxIndices are
        // constant and it's randomized based on those.
        vec2 axisOffset = flipAndAxisOffset(boxIndices, offset);
        float d = plotCircle(uv, axisOffset);
        if (d > 0.) {
            return d;
        }
    }
    return 0.;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xx;
    vec2 coord = fragCoord/iResolution.xy;
    
    // Count of boxes horizontally, 20 when modValue is 0.05 since 1/0.05 = 20
    float countX = 1.0 / modValue;
    // Which box are we at on the x-axis. Basically works by splitting up the x values into discrete
    // chunks of 0.05 and then taking that out of the total count, e.g. 20 * 0.05 = 1, 20 * 0.1 = 2,
    // and so on.
    int boxIndexX = int(countX * (uv.x - mod(uv.x, modValue)));
    
    float countY = 1.0 / modValue;
    int boxIndexY = int(countY * (uv.y - mod(uv.y, modValue)));

    vec2 boxIndices = vec2(boxIndexX, boxIndexY);

    float mx = mod(uv.x, modValue);
    float my = mod(uv.y, modValue);
    uv = vec2(mx, my);  

    float d = plotCircles(uv, boxIndices);
    
    // Coord values are flipped xy ->  yx to avoid too much blending
    // vec3 fgColour = vec3(coord.yx, fgColourAdded) * d;
    // vec3 bgColour = vec3(bgColourAdded, coord.xy) * (1.0 - d);
    
    vec3 fgColour = vec3(0.8, 1., 0.8) * d;
    vec3 bgColour = vec3(coord.xy, 1.) * (1.0 - d);
    vec3 colour = bgColour + fgColour;
    
    fragColor = vec4(colour, 1.0);
}