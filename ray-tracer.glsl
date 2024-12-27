/*
 * types
 *
 */

struct Ray {
    // position & direction.
    vec3 s;
    vec3 v;
};

struct Light {
    vec3 position;
    vec3 colour;
};

struct Material {
    // colour, specular colour & shininess power.
    // set specular colour to vec3(0.0) to avoid
    // specular highlighting.
    vec3 colour;
    vec3 specular_colour;
    float specular_shininess;
    int type;
};

struct Sphere {
    int handle;
    // radius
    float r;
    vec3 position;
    Material material;
};

struct Cylinder {
    int handle;
    // radius
    float r;
    // height
    float h;
    vec3 position;
    Material material;
};

struct Intersection {
    // honestly, no other clue on how to make this
    // generic without pointers. the idea here is
    // that each piece of geometry will have a
    // unique integer handle. we keep track of
    // different intersections based on the handle
    // we get from the shape. this is error prone
    // because we may accidentally assign the same
    // handle to two pieces of geometry.
    int handle;
    // how far away was the intersected item from
    // where the ray began.
    float distance;
    Material material;
    Ray ray;
    vec3 point_of_intersection;
    vec3 normal_at_intersection;
};

/*
 * constants
 *
 */
#define M_PI 3.1415926535897932384626433832795

/*
 * scene & rendering setup
 *
 */
#define SUPERSAMPLE 1
#define REFLECTION_PASS 0
#define BACKGROUND_COLOUR vec3(0.0)
#define CAMERA_POSITION vec3(0.0, 0.5, 0.0)

/* 
 * enums
 *
 */
#define MATERIAL_NONE 0
#define MATERIAL_BLINN_PHONG 2
#define MATERIAL_REFLECTIVE 1

/*
 * 'null' types since glsl doesn't use pointers
 *
 */
#define NULL_HANDLE 0
#define NULL_RAY Ray(vec3(0.0), vec3(0.0))
#define NULL_LIGHT Light(vec3(0.0), vec3(0.0))
#define NULL_MATERIAL Material(vec3(0.0), vec3(0.0), 0.0, MATERIAL_NONE)
#define NULL_INTERSECTION Intersection(NULL_HANDLE, 0.0, NULL_MATERIAL, NULL_RAY, vec3(0.0), vec3(0.0))


/*
 * lighting
 *
 */
Light LIGHTS[] = Light[](
    Light(vec3(5.0, 5.0, 5.0), vec3(0.7, 0.7, 0.7)),        
    Light(vec3(-5.0, -5.0, -2.0), vec3(0.15, 0.15, 0.15))
);
const vec3 AMBIENT_LIGHT = vec3(0.03);

/*
 * geometry - spheres
 * all spheres have a handle between (1000, 2000)
 * all cylinders have a handle between (4000, 5000)
 *
 */
Sphere SPHERES[] = Sphere[](
    // top row
    Sphere(1001, 0.2, vec3(-1.6, 0.6, -4.0),
        Material(
            vec3(1.0, 0.0, 0.0),
            vec3(1.0),
            1024.0,
            MATERIAL_REFLECTIVE
        )
    ),
    Sphere(1002, 0.2, vec3(-1.2, 0.6, -4.0),
        Material(
            vec3(0.0, 0.0, 1.0),
            vec3(1.0),
            1024.0,
            MATERIAL_REFLECTIVE
        )
    ),
    Sphere(1003, 0.2, vec3(-0.8, 0.6, -4.0),
        Material(
            vec3(1.0, 0.0, 0.0),
            vec3(1.0),
            1024.0,
            MATERIAL_REFLECTIVE
        )
    ),
    Sphere(1004, 0.2, vec3(-0.4, 0.6, -4.0),
        Material(
            vec3(0.0, 0.0, 1.0),
            vec3(1.0),
            1024.0,
            MATERIAL_REFLECTIVE
        )
    ),
    Sphere(1005, 0.2, vec3(0.0, 0.6, -4.0),
        Material(
            vec3(1.0, 0.0, 0.0),
            vec3(1.0),
            1024.0,
            MATERIAL_REFLECTIVE
        )
    ),
    Sphere(1006, 0.2, vec3(0.4, 0.6, -4.0),
        Material(
            vec3(0.0, 0.0, 1.0),
            vec3(1.0),
            1024.0,
            MATERIAL_REFLECTIVE
        )
    ),
    Sphere(1007, 0.2, vec3(0.8, 0.6, -4.0),
        Material(
            vec3(1.0, 0.0, 0.0),
            vec3(1.0),
            1024.0,
            MATERIAL_REFLECTIVE
        )
    ),
    Sphere(1008, 0.2, vec3(1.2, 0.6, -4.0),
        Material(
            vec3(0.0, 0.0, 1.0),
            vec3(1.0),
            1024.0,
            MATERIAL_REFLECTIVE
        )
    ),
    Sphere(1009, 0.2, vec3(1.6, 0.6, -4.0),
        Material(
            vec3(1.0, 0.0, 0.0),
            vec3(1.0),
            1024.0,
            MATERIAL_REFLECTIVE
        )
    ),
    Sphere(1010, 0.4, vec3(-1.6, 0.0, -11.0),
        Material(
            vec3(1.0, 0.0, 0.0),
            vec3(1.0),
            1024.0,
            MATERIAL_REFLECTIVE
        )
    ),
    Sphere(1011, 0.4, vec3(1.6, 0.0, -11.0),
        Material(
            vec3(0.0, 0.0, 1.0),
            vec3(1.0),
            1024.0,
            MATERIAL_REFLECTIVE
        )
    ),
    Sphere(1012, 1.0, vec3(0.0, 0.0, -10.0), 
        Material(
            vec3(0.0, 1.0, 1.0),
            vec3(1.0, 1.0, 1.0),
            1024.0,
            MATERIAL_REFLECTIVE
        )
    ),
    Sphere(1013, 0.4, vec3(-0.8, -1.0, -8.5),
        Material(
            vec3(1.0, 0.0, 0.0),
            vec3(1.0),
            1024.0,
            MATERIAL_REFLECTIVE
        )
    ),
    Sphere(1014, 0.4, vec3(0, -0.5, -8.0),
        Material(
            vec3(0.0, 1.0, 0.0),
            vec3(1.0),
            1024.0,
            MATERIAL_REFLECTIVE
        )
    ),
    Sphere(1015, 0.4, vec3(0.8, -1.0, -8.5),
        Material(
            vec3(0.0, 0.0, 1.0),
            vec3(1.0),
            1024.0,
            MATERIAL_REFLECTIVE
        )
    )
);

Cylinder CYLINDERS[] = Cylinder[](
    Cylinder(4001, 0.1, 0.5, vec3(0.0, -0.125, -4.0),
        Material(
            vec3(1.0, 0.0, 0.0),
            vec3(1.0),
            1024.0,
            MATERIAL_REFLECTIVE
        )
    ),
    Cylinder(4002, 0.05, 0.4, vec3(-1.3, -0.125, -4.0),
        Material(
            vec3(0.0, 0.0, 1.0),
            vec3(1.0),
            1024.0,
            MATERIAL_REFLECTIVE
        )
    ),
    Cylinder(4003, 0.05, 0.4, vec3(1.3, -0.125, -4.0),
        Material(
            vec3(0.0, 0.0, 1.0),
            vec3(1.0),
            1024.0,
            MATERIAL_REFLECTIVE
        )
    )
);

/*
 * function declarations
 *
 */
vec3 blinn_phong_for_intersection(Intersection intersection);
vec3 reflection_for_intersection(Intersection intersection);
Ray ray_for_normalized_pixel(vec2 vertex);
Intersection sphere_intersection_for_ray(Ray ray, Intersection current_intersection);
Intersection cylinder_intersection_for_ray(Ray ray, Intersection current_intersection);
Intersection intersection_for_ray(Ray ray);
bool is_new_intersection(Intersection current, Intersection next);


Ray 
ray_for_normalized_pixel(vec2 vertex) {
    // vertex coming in as normalized pixel value, so we'll
    // expect 0->1.0 on x & y even though x's resolution is
    // 640 and y is 360 (from shadertoy).

    // 640/360 = 1.777...
    float aspect_ratio = iResolution.x / iResolution.y;

    // 0.6109
    float fov_angle = 35.0 * M_PI / 180.0;

    // 0.3153
    float e = tan(fov_angle / 2.0);

    // we need to shift everything because our 3d
    // scene is centred around the origin 0, 0, 0 but our 
    // rays are being shot out from a scaled 0->1 on x & y.
    // also the coordinate system is 0->1 on both axes,
    // but it's easier to work with -1->1 on x and 1->-1
    // which is more like a cartesian grid.
    float x = (2.0 * vertex.x) - 1.0;
    float y = (1.0 - vertex.y * 2.0) * -1.0;

    // scale normalized x and y by the aspect ratio.
    // in pixel terms, our x will now go to 358 (at 640) and
    // our y will go to 113 (at 360). or whatever that means
    // for normalized values.
    x = x * e * aspect_ratio;
    y = y * e;

    // we use -1 as z as the depth direction of the ray.
    return Ray(CAMERA_POSITION, normalize(vec3(x, y, -1.0)));
}

float
quadratic_discriminant(float a, float b, float c) {
    return (b * b) - (4.0 * a * c);
}

/*
 * gauranteed to return a value, since we should
 * only ever call this function if quadratic_discriminant
 * is >= 0.0.
 *
 */
float
quadratic_solution(float a, float b, float c) {
    float d = quadratic_discriminant(a, b, c);
    if (0.0 == d) {
        return -b / a * 2.0;
    } else {
        float t0 = (-b + sqrt(d)) / 2.0 * a;
        float t1 = (-b - sqrt(d)) / 2.0 * a;
        if (abs(t0) < abs(t1)) {
            return t0;
        } else {
            return t1;
        }
    }
}

/*
 * does a new Intersection differ from a previous one, and
 * is it non null.
 *
 */
bool
is_new_intersection(Intersection intersection,
                    Intersection next_intersection) {
    bool intersection_found = NULL_INTERSECTION != next_intersection;
    // don't want to think that a sphere has hit itself
    // and is therefore occluding.
    bool intersections_differ = intersection.handle != next_intersection.handle;
    return intersection_found && intersections_differ;
}

/*
 * is a point of intersection that's pointing towards a light
 * blocked by any spheres (and in future, other shapes)?
 *
 */
bool
intersection_is_occluded(Light light, Intersection intersection) {
    vec3 point = intersection.point_of_intersection;
    vec3 light_direction = normalize(light.position - point);

    Intersection next_intersection = 
        intersection_for_ray(Ray(point, light_direction));
   
    return is_new_intersection(intersection, next_intersection);
}

vec3
reflection_for_intersection(Intersection intersection) {

    // set it up so this is our first bounce.
    Intersection current_intersection = intersection;

#if REFLECTION_PASS
    // kind of works for just showing reflection colours.
    vec3 base_colour = vec3(0.0);
#else
    vec3 base_colour = blinn_phong_for_intersection(intersection);
#endif

    int max_reflections = 10;
    float colour_dampening = 1.0;
    float dampening_modifier = colour_dampening / float(max_reflections);

    for (int i = 0; i < max_reflections; i++) {
        // debug red.
        vec3 colour = vec3(1.0, 0.0, 0.0);
        vec3 point = current_intersection.point_of_intersection;
        vec3 normal = current_intersection.normal_at_intersection;
        vec3 incidence = current_intersection.ray.v;

        // the reflect function doesn't do what you'd think it would do.
        // we need this:
        // dot(incidence, normal) * 2 * normal + incidence
        // reflect(incidence, normal)
        // is giving us incidence - 2 * dot(normal, incidence) * normal.
        vec3 reflection = dot(incidence, normal) * 2.0 * normal + incidence;
        Ray ray = Ray(point, reflection);
        Intersection next_intersection = intersection_for_ray(ray);

        // a temporary solution to handling reflections in shaded areas.
        // basically a darker colour should have a smaller magnitude, so
        // we can modify the colour_dampening further so that shaded
        // areas will have correspondingly damper reflected colour mixed in.
        // previously tried a random cutoff:
        // (e.g. length(base_colour) < 0.1 ? return base_colour)
        // but it produced hard divisions between areas that did and didn't
        // meet that criteria.
        float scaled_dampening = colour_dampening * length(base_colour);

        // handle the miss + blinn-phong (aka non reflective) hit as one unit
        // since both result in a premature end to our bounces.
        // if we get past this, we're going to an additional bounce.
        if (is_new_intersection(intersection, next_intersection) == false) {
            colour = BACKGROUND_COLOUR;
            base_colour += colour * scaled_dampening;
            break;
        } else if (next_intersection.material.type == MATERIAL_BLINN_PHONG) {
            colour = blinn_phong_for_intersection(next_intersection);
            base_colour += colour * scaled_dampening;
            break;
        }

        // if we're here, we hit something reflective.
        colour = blinn_phong_for_intersection(next_intersection);
        base_colour += colour * scaled_dampening;

        // setup next_intersection to be our current_intersection
        // loop and fire off the next ray.
        current_intersection = next_intersection;
        colour_dampening -= dampening_modifier;
    }
   
    return base_colour;
}

/*
 * Based on the wikipedia blinn-phong shading model
 * but with iteration over all lights and no modification
 * of the lighting based on light power and distance:
 * https://en.wikipedia.org/wiki/Blinn%E2%80%93Phong_shading_model
 *
 */
vec3
blinn_phong_for_intersection(Intersection intersection) {
       
    Material material = intersection.material;

    vec3 point = intersection.point_of_intersection;
    vec3 normal = intersection.normal_at_intersection;
    Ray ray = intersection.ray;

    vec3 colour = vec3(0.0);

    for (int i = 0; i < LIGHTS.length(); i++) {
        Light light = LIGHTS[i];
        
        // ensure no other sphere stands between the light
        // the point we're trying to illuminate on the sphere
        // surface. the light has no influence on the overall
        // output colour if it is occluded.
        if (intersection_is_occluded(light, intersection)) {
            // for debugging purposes, we can return a random colour
            // or the colour of the sphere that resulted in the
            // occlusion.
            continue;
        }

        vec3 light_direction = normalize(light.position - point);
        float normal_light_direction = dot(normal, light_direction);
        float lambert_intensity = clamp(normal_light_direction, 0.0, 1.0);
        float specular_intensity = 0.0;

        if (lambert_intensity > 0.0) {
            // a ray from our point on the sphere surface
            // back to the eye, aka where the ray started.
            vec3 view_direction = normalize(ray.s - point);
            vec3 half_direction = normalize(light_direction + view_direction);
            float normal_half_direction = dot(normal, half_direction);
            float specular_angle = clamp(normal_half_direction, 0.0, 1.0);
            specular_intensity = pow(specular_angle, material.specular_shininess);
        }
        // handle ambient lighting, lambert colouring,
        // and the specular highlight.
        colour += AMBIENT_LIGHT;
        colour += material.colour * lambert_intensity * light.colour;
        colour += material.specular_colour * specular_intensity * light.colour;
    }
    return colour;
}

Intersection
sphere_intersection_for_ray(Ray ray, Intersection current_intersection) {

    float nearest_distance = current_intersection.distance;
    Intersection nearest_intersection = current_intersection;

    for (int i = 0; i < SPHERES.length(); i++) {
        Sphere s = SPHERES[i];
       
        // if we don't offset by the sphere's position, then
        // it's assumed that the sphere is at the origin.
        // instead, this basically lets the sphere be at the
        // origin, and instead translates the ray's start position
        vec3 ray_offset = ray.s - s.position;

        float a = dot(ray.v, ray.v);
        float b = dot(ray_offset, ray.v) * 2.0;
        float c = dot(ray_offset, ray_offset) - s.r * s.r;

        float discriminant = quadratic_discriminant(a, b, c);
        if (discriminant < 0.0) {
            // no intersection with this sphere.
            continue;
        } else if (0.0 == discriminant || discriminant > 0.0) {
            float solution = quadratic_solution(a, b, c);
            // the point we're getting back point should no longer be shifted.
            vec3 point = ray.s + ray.v * solution;
            // we've shifted the ray's start point, so the distance
            // between the point of intersection to the beginning
            // of the ray has to take that into account.
            float m = distance(point, ray_offset);
            if (NULL_INTERSECTION == nearest_intersection || m < nearest_distance) {
                nearest_intersection.handle = s.handle;
                nearest_intersection.material = s.material;
                nearest_intersection.point_of_intersection = point;
                nearest_intersection.normal_at_intersection = normalize(point - s.position);
                nearest_intersection.ray = ray;
                nearest_intersection.distance = m;            
                nearest_distance = m;
            }
        }
    }

    return nearest_intersection;
}

Intersection
cylinder_intersection_for_ray(Ray ray, Intersection current_intersection) {
    float nearest_distance = current_intersection.distance;
    Intersection nearest_intersection = current_intersection;

    for (int i = 0; i < CYLINDERS.length(); i++) {
        Cylinder cy = CYLINDERS[i];

        vec3 ray_offset = ray.s - cy.position;
        vec3 v = ray.v;
        vec3 s = ray_offset;
        float a = v.x * v.x + v.z * v.z;
        float b = 2.0 * v.x * s.x + 2.0 * v.z * s.z;
        float c = s.x * s.x + s.z * s.z - cy.r;

        float discriminant = quadratic_discriminant(a, b, c);
        if (discriminant < 0.0) {
            // no solution on the surface, but there might be
            // a solution for the bottom or top cap.
            // TODO
            // test the caps for intersection.
            // http://woo4.me/wootracer/cylinder-intersection/
            continue;
        } else if (0.0 == discriminant || discriminant > 0.0) {
            float solution = quadratic_solution(a, b, c);
            // the point we're getting back point should no longer be shifted.
            vec3 point = ray.s + ray.v * solution;

            // the position is the centre of the cylinder. we
            // must now do a height check, otherwise we'll render
            // an infinite cylinder.
            if (point.y < cy.position.y - cy.h * 0.5 ||
                point.y > cy.position.y + cy.h * 0.5) {
                continue;
            }

            // we've shifted the ray's start point, so the distance
            // between the point of intersection to the beginning
            // of the ray has to take that into account.
            float m = distance(point, ray_offset);
            if (NULL_INTERSECTION == nearest_intersection || m < nearest_distance) {
                nearest_intersection.handle = cy.handle;
                nearest_intersection.material = cy.material;
                nearest_intersection.point_of_intersection = point;
                // TODO
                // this will not work for the caps. we know the caps
                // point up, and that the surface doesn't point up
                // at all.
                vec3 n = vec3(point.x - cy.position.x, 0.0, point.z - cy.position.z);
                nearest_intersection.normal_at_intersection = normalize(n);
                nearest_intersection.ray = ray;
                nearest_intersection.distance = m;
                nearest_distance = m;
            }
        }
    }
    return nearest_intersection;
}

Intersection
intersection_for_ray(Ray ray) {
    Intersection nearest_intersection = NULL_INTERSECTION;
    // TODO
    // test various geometry groupings in their own functions
    // so that the math concerns can be handled discretely.
    // for now only handle spheres.
    nearest_intersection = sphere_intersection_for_ray(ray, nearest_intersection);
    // TODO
    // Skip spheres for now
    // nearest_intersection = cylinder_intersection_for_ray(ray, nearest_intersection);
    return nearest_intersection;
}

vec3
trace_ray_at_pixel(vec2 xy) {
    Ray ray = ray_for_normalized_pixel(xy);

    Intersection intersection = intersection_for_ray(ray);

    if (NULL_INTERSECTION == intersection) {
        return BACKGROUND_COLOUR;
    }

    // TODO
    // This doesn't seem to work and always goes to NONE.
    // switch (intersection.material.type) {
       // case MATERIAL_NONE:
         //   return intersection.material.colour;
        //case MATERIAL_BLINN_PHONG:
          //  return blinn_phong_for_intersection(intersection);
        //case MATERIAL_REFLECTIVE:
          return reflection_for_intersection(intersection);
    //}
}

void 
mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // normalized pixel coordinates (from 0 to 1)
    vec2 xy = fragCoord/iResolution.xy;
    vec3 colour = trace_ray_at_pixel(xy);

#if SUPERSAMPLE
    // take 8 samples around the pixel of interest
    float offsetNext = 1.00125;
    float offsetPrev = 1.0/offsetNext;
  
    mat3 x_offsets = mat3(vec3(offsetPrev), vec3(1.0), vec3(offsetNext));
    mat3 y_offsets = transpose(x_offsets);

    for (int y = 0; y < 3; y++) {
        for (int x = 0; x < 3; x++) {
            vec2 supersample = vec2(xy.x * x_offsets[y][x], xy.y * y_offsets[y][x]);
            colour += trace_ray_at_pixel(supersample);
        }
    }
    // average the supersamples uniformly
    colour = colour / 9.0;
#endif

    fragColor = vec4(colour, 1.0);
}
