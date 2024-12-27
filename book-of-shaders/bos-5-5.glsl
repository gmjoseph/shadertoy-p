float plotPolynomial(vec2 uv) {
    // We need really small coefficients because the pixel range is only [0, 1].
    // 3x^3 + 2x^2 + 0.05x + 0.01
    float fx = 3. * pow(uv.x, 3.) + 2. * pow(uv.x, 2.) + uv.x * 0.05 + 0.01;
    // fx = pow(uv.x, 3.);
    
    float bias = 0.005;
    float d = 1. - smoothstep(bias, bias * 2., abs(uv.y - fx));
    // How close is the y uv coordinate to the actual output of the f(x) polynomial's y?
    // If it's close enough we colour it (i.e. it's on the line).
    return d;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;
    // [0, 1] to [-1, 1] if we're plotting polynomials.
    vec2 coord = uv * 2. - 1.;

    vec3 colour = vec3(uv, 1.) * plotPolynomial(coord);
    fragColor = vec4(colour, 1.);
}