#define PI 3.1415

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Only account for width to make circles (results in a non-even pattern on
    // the y-axis, but it beats dealing with ovals, oh well).
    vec2 resolution = iResolution.xx;
    vec2 uv = fragCoord/resolution;
       
    // Thresholds each square 
    float modValue = 0.025;
    float mx = mod(uv.x, modValue);
    float my = mod(uv.y, modValue);

    // Bounds of the rectangle.
    vec2 tl = uv - vec2(mx, my);
    vec2 br = tl + vec2(modValue);
    
    // Centre of the current rectangle. We'll fix this to be circular later.
    vec2 centre = (br + tl) * 0.5;
    // If we take 0.5 of the modValue we'll get perfect circles, but this causes
    // some overlap between the radiuses which makes it look more interested.
    // modValue * 0.5;
    float maximumRadius = modValue * 0.7;
    float minimumRadius = maximumRadius * 0.1;
   
    // Mouse-based.
    float toCoordinate = distance(iMouse.xy / resolution, centre);
    
    // Time-based.
    // float time = iTime * 0.5;
    // vec2 circleCoordinate = vec2(0.5) + vec2(cos(PI * time), sin(PI * time)) * 0.25;
    // toCoordinate = distance(circleCoordinate, centre);

    // The closer we are to the radius, the smaller each circle's radius is.
    float radius = toCoordinate * maximumRadius;
    radius = clamp(radius, minimumRadius, maximumRadius);
     
    // Make a circular pattern, anything not sufficiently close to the circle isn't coloured.
    // Smoothstep for antialiasing.
    float toCentre = smoothstep(radius * 0.75, radius, distance(uv, centre));

    // Uncomment to inverse, where colours outside the circle are discarded, and data
    // inside is preserved.
    // toCentre = 1.0 - smoothstep(radius * 0.75, radius, distance(uv, centre));
    fragColor = vec4(uv, 1., 1.) * toCentre;
}