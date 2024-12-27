void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float time = iTime * 0.1;
    vec2 uv = fragCoord/iResolution.xx;
    
    float modValue = 0.05;

    // Count of boxes horizontally, 20 when modValue is 0.05 since 1/0.05 = 20
    int countX = int(1.0 / modValue);
    // Which box are we at on the x-axis. Basically works by splitting up the x values into discrete
    // chunks of 0.05 and then taking that out of the total count, e.g. 20 * 0.05 = 1, 20 * 0.1 = 2,
    // and so on.
    int boxIndexX = int( float(countX) * (uv.x - mod(uv.x, modValue)) );
    
    int countY = int(1.0 / modValue);
    int boxIndexY = int( float(countY) * (uv.y - mod(uv.y, modValue)) );
    
    // Wave-pattern
    bool flipped = boxIndexX % 2 == 0 ;
    
    // Brick-like pattern
    // flipped = boxIndexX % 2 == 0 && boxIndexY % 3 == 0;
 
    // Only flip one of these or else it goes back to where it started.
    float x = flipped ? 1.0 - uv.x : uv.x;
    float y = uv.y;

    float mx = mod(x, modValue);
    float my = mod(y, modValue);
    // - 0.1 Ensures that the last row isn't white. Otherwise we end up with 0s on the last row
    // becomes all white
    uv = vec2(mx, my);
    uv.y *= abs(sin(time));
    uv.x *= abs(cos(time));
    
    float lineWidth = 0.002;
    float d = 1.0 - step(lineWidth, abs(uv.x - uv.y));
    // float d = step(distance(start, uv), 0.2);
    vec3 colour = vec3(1., 1., 1.) * d;
    
    fragColor = vec4(colour, 1.0);
}