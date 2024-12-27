// implements all the graphs in the kynd.png image linked in the description and
// in the book of shaders page. since each row is pretty much the same thing with minor changes
// to the power value, only the first one in each row is implemented.

#define PI 3.151519

#define FUNC_COUNT 5

// number of powers to iterate through.
#define POWER_COUNT 7

float abs_pow(vec2 uv, float power) {
    // need to shift the x values or else we only get everything left of the y-axis at x = 0.
    // so if x is [0, 1] it's now [-1.0, 1.0]
    float x = uv.x * 2.0 - 1.0;
    x = 1.0 - pow(abs(x), power);
    return x;
}

float cos_pow(vec2 uv, float power) {
    float x = uv.x * 2.0 - 1.0;
    x = pow(cos(PI * x / 2.0), power);
    return x;
}

float sin_abs_pow(vec2 uv, float power) {
    float x = uv.x * 2.0 - 1.0;
    x = 1.0 - pow(abs(sin(PI * x / 2.0)), power);
    return x;
}

float cos_min_pow(vec2 uv, float power) {
    float x = uv.x * 2.0 - 1.0;
    x = pow(min(cos(PI * x / 2.0), 1.0 - abs(x)), power);
    return x;
}

float max_pow(vec2 uv, float power) {
    float x = uv.x * 2.0 - 1.0;
    x = 1.0 - pow(max(0.0, abs(x) * 2.0 - 1.0), power);
    return x;
}

float get_distance(int i, vec2 uv, float power) {
    float x = 0.0;
    if (i == 0) {
        x = abs_pow(uv, power);
    }
    if (i == 1) {
        x = cos_pow(uv, power);
    }
    if (i == 2) {
        x = sin_abs_pow(uv, power);
    }
    if (i == 3) {
        x = cos_min_pow(uv, power);
    }
    if (i == 4) {
        x = max_pow(uv, power);
    }

    return 1.0 - step(0.01, abs(uv.y - x));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;
    // Background colour
    vec3 colour = vec3(smoothstep(0.1, 0.9, uv.x));
    
    
    for (int i = 0; i < FUNC_COUNT; i++) {
        for (int power = 1; power <= POWER_COUNT; power++) {        
            float p = float(power) * 0.5;
            float d = get_distance(i, uv, p);
            vec3 line = d * vec3(0.0, 1.0, 0.0);

            // Remove any colour contributions for areas that the line would pass through.
            colour = (1.0 - d) * colour;

            // Add the colour contributions of the line to fill in those that were removed in the previous line.
            colour += line;
        }
    }
    

    fragColor = vec4(colour, 1.0);
}