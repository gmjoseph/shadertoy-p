// The amount of flip boolean values in each array is directly related to the count,
// which is itself related to the modValue since count = 1.0 / modValue.
// Make this smaller for more lines, larger for fewer.
float modValue = 0.02;

// Adjust to get different random flips.
float randomThreshold = 0.5;

// Deterministic random function
// https://stackoverflow.com/a/4275343
float rand(vec2 co){
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float time = iTime * 0.1;
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
    
    // Randomly flip each box deterministically based on it's index in the grid.
    bool flipped = rand(vec2(boxIndexX, boxIndexY)) > randomThreshold;
    
    // Brick pattern
    // flipped = boxIndexX % 2 == 0 && boxIndexY % 2 == 0;
    
    // Horizontal wave pattern
    // flipped = boxIndexX % 2 == 0;
    
    // Vertical wave pattern
    // flipped = boxIndexY % 2 == 0;
    
    // Only flip one of these or else it goes back to where it started.
    float x = flipped ? 1.0 - uv.x : uv.x;
    float y = uv.y;

    float mx = mod(x, modValue);
    float my = mod(y, modValue);
    // - 0.1 Ensures that the last row isn't white. Otherwise we end up with 0s on the last row
    // becomes all white
    uv = vec2(mx, my);
    // uv.y *= abs(sin(time));
    // uv.x *= abs(cos(time));
    
    float lineWidth = modValue * 0.1;
    float d = 1.0 - step(lineWidth, abs(uv.x - uv.y));
    
    float fgColourAdded = abs(sin(time));
    float bgColourAdded = abs(cos(time));
    
       
    // Coord values are flipped xy ->  yx to avoid too much blending
    vec3 fgColour = vec3(coord.yx, fgColourAdded) * d;
    // vec3 bgColour = vec3(1., coord);
    // vec3 bgColour = vec3(0., coord) * (1.0 - d);
    vec3 bgColour = vec3(bgColourAdded, coord.xy) * (1.0 - d);
    vec3 colour = bgColour + fgColour;
    
    fragColor = vec4(colour, 1.0);
}