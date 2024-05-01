#include <metal_stdlib>
using namespace metal;
#include "include/metaltoy.metal" // mandatory

#include "lib/camera.metal"
#include "lib/procedural_textures.metal"
#include "lib/osc/glsl3_proxy.metal"
#include "lib/interceptors/plane.metal"
#include "lib/interceptors/sphere.metal"
#include "lib/sky_dome.metal"
#include "lib/common.metal"

// @texture "../shaders/./assets/images/wood3.jpg"
// @texture './assets/images/wood2.jpg'
#define sampleTexture(texture, st) (texture.sample(sampler(mag_filter::linear, min_filter::linear, s_address::repeat, t_address::repeat), st))


#define MT_NUM_BUFFERS 4

#define GAM float3(o_gam_r,o_gam_g,o_gam_b)
#define AIM (o_aim + float2(-0.,0))
#define AIM_SC o_aim_sc
#define PAN o_pan
#define PAN_SC o_pan_sc * 2.
#define DISTANCE o_distance
#define SCALE (o_scale * 100. + 20.)
// #define EXPOSURE (0.1 + pow(o_exp,3.5) * 50.)
#define EXPOSURE (1. + o_exp * 100.)
#define POS1 float3(o_multixy_1,o_mrot1).xzy
#define POS2 float3(o_multixy_2,o_mrot2).xzy
#define POS3 float3(o_multixy_3,o_mrot3).xzy
#define MFAD1 o_mfad1
#define LFAD1 (o_lfad1*0.5+0.5)
#define MFAD2 (o_mfad2)
#define ROT1 o_rot1
#define TOG1 (o_tog1 == 1.0)
#define TOG3 (o_tog3 == 1.0)
#define TOG2 (o_tog2 == 1.0)
#define FAD1 o_fad1
#define FAD2 o_fad2
#define FAD3 o_fad3
#define FAD4 o_fad4
#define FAD5 o_fad5
#define FAD6 o_fad6
#define LFAD2 (o_lfad2*0.5+0.5)
#define LFAD3 (o_lfad3*0.5+0.5)
#define MIX1 o_mix1
#define MIX2 o_mix2
#define MIX3 o_mix3
#define MIX4 o_mix4
// #define ROT2 o_rot2
// #define HUMIDITY o_rot2
#define TOG4 (o_tog4 == 1.0)
#define TOG5 (o_tog5 == 1.0)
#define LONG o_long

#define MAX_DIST 1e6
#define BACKDROP 100
#define FLOOR 1
#define SPHERE 2

struct Light {
    float4 pos; // .w = type : 0-point,1-directional
    float3 color;
    float3 intensity;
};

struct Scene {
    float4 plane;
    float4 sphere;
    thread Light *lights;
};

struct RayData {
    float3 ro;
    float3 rd;
    float md;
    float3 pos;
    float3 nor;
    int matid;
    int flags;
    Scene scene;
};

struct Context {
    constant SysUniforms& sys_u;
    constant Glsl3Uniforms& _u;
    array<texture2d<float>, 4> textures;
    thread RayData& rdat;

    // Constructor to initialize references
    Context(constant SysUniforms& sysUniforms, constant Glsl3Uniforms& glslUniforms,
        array<texture2d<float>, 4> textures, thread RayData& rayData)
    : sys_u(sysUniforms), _u(glslUniforms), textures(textures), rdat(rayData) {
        // Initialize textures or other members if needed
    }

};

constant int MAX_LIGHTS = 1;

void initLights(thread Light *lights, constant Glsl3Uniforms &_u ) {
    lights[0].pos = float4(0,10 + 1000*o_fad1,0,0);
    lights[0].color = o_col3;
    lights[0].intensity = 2*o_long;
}

Scene initScene(thread Scene &scene, constant Glsl3Uniforms &_u) {
    scene.plane = float4(0,1,0,0-100*o_fad2);
    scene.sphere = float4(0,0+300*o_fad3,0,70);
    initLights(scene.lights, _u);
    return scene;
}

float getCheckerboardColor(float x, float y, float size) {
    // Determine which square of the checkerboard the point falls into
    int ix = int(round((x+(size/2)) / size));
    int iy = int(round((y+(size/2)) / size));

    // Calculate the checkerboard pattern
    if ((ix + iy) % 2 == 0) {
        return 1;
    } else {
        return 0;
    }
}

RayData newRayData(float3 ro, float3 rd) {
    RayData rdat = RayData();
    rdat.md = MAX_DIST;
    rdat.ro = ro;
    rdat.rd = rd;
    rdat.pos = float3(0);
    rdat.nor = float3(0);
    rdat.matid = 0;
    rdat.flags = 0;
    return rdat;
}

float3 calcPointLight( thread Light pointLight, thread RayData &rdat, constant Glsl3Uniforms &_u )
{
    // Calculate light properties
    float3 toLight = pointLight.pos.xyz - rdat.pos;
    float distance = length(toLight);
    float attenuation = 1/(distance*distance);
    float3 lightDir = normalize(toLight);

    // Calculate diffuse lighting
    float diff = max(dot(rdat.nor, lightDir), 0.0);
    float3 diffuse = diff * pointLight.color * pointLight.intensity * attenuation;

    // Output final color
    return diffuse*100000;
}

float3 calcLight( thread RayData &rdat, constant Glsl3Uniforms &_u )
{
    Scene scene = rdat.scene;
    Light pointLight = scene.lights[0];
    float3 light = float3(0);
    light += calcPointLight(pointLight, rdat, _u);
    return light;
}

// float intersectRay( float3 ro, float3 rd, float px, float td, int mask, out float3 pos, out float3 nor, out int matid  ) {
float intersectRay( float3 ro, float3 rd, float px, thread Context& _c )
{
    thread RayData & rdat = _c.rdat;
    rdat.matid = BACKDROP;
    float d;
    Scene scene = rdat.scene;
    float4 plane = scene.plane;
    float4 sphere = scene.sphere;

    d = planeIntersect(ro, rd, plane);
    if( d > 0. && d < rdat.md ) {
        float3 pos = ro + rd * d;
        float cb = getCheckerboardColor(pos.x, pos.z, 40);
        if( cb == 1 || true ) {
            float s = sign(-dot(rd, plane.xyz));
            rdat.pos = ro + rd * d; rdat.nor = plane.xyz*s; rdat.matid = FLOOR; rdat.md = d;
        }
    }

    d = sphereIntersection( ro, rd, sphere );
    if( d > 0. && d < rdat.md ) {
        rdat.md = d; rdat.pos = ro + rd * d; rdat.nor = (rdat.pos-sphere.xyz)/sphere.w; rdat.matid = SPHERE;
    }

//   matDF = (md+td) * px / dot( rd, nor);
    return rdat.md;
}

float3 getRayColor( float3 ro, float3 rd, float px, thread Context& _c ) {
    intersectRay( ro, rd, px, _c );
    thread RayData &rdat = _c.rdat;
    constant Glsl3Uniforms &_u = _c._u;
    constant SysUniforms &sys_u = _c.sys_u;

    float3 color;
    if( rdat.flags > 0 ) return float3(1,0,1);
    if( rdat.matid == BACKDROP ) {
        float stars = 0.15;
        float clouds = 0.2;
        float daylight = 0.2;
        float res = vmin(o_resolution);
        float2 cloudOffset = float2(sys_u.time*1000);
        return skyDome(rd, cloudOffset, stars, clouds, daylight, res);
    }
    if( rdat.matid == FLOOR ) {
        // float c = chex(rdat.pos.xz/50);
        // color = o_col2 * (c/2+0.5);
        color = sampleTexture(_c.textures[0], rdat.pos.xz/100).rgb;
    }
    if( rdat.matid == SPHERE ) {
        color = o_col1;
    }
    return color * calcLight( rdat, _u );
}

#ifndef LOOK_AT
#define LOOK_AT float3(0,0,0)
#endif

#ifndef CAM_ZOOM
#define CAM_ZOOM (0.1+ROT1*3.9)
#endif

float3 getPixelColor( float2 fragCoord, constant SysUniforms& sys_u, constant Glsl3Uniforms& _u, array<texture2d<float>, 4> textures ) {
    float scale = SCALE, le = CAM_ZOOM;
    float2 u_resolution = sys_u.resolution;
    float minD = min(u_resolution.x, u_resolution.y);
    float2 ndc = 2.*(fragCoord-u_resolution*0.5) / u_resolution.x;
    ndc *= float2(1,-1);  // invert y-coord like OpenGL
    // float2 st = fragCoord/u_resolution;
    float xa = AIM.x * AIM_SC * k2PI + sys_u.time*0.02;
    float ya = AIM.y * AIM_SC * k2PI + 0.15*(sin(sys_u.time*0.1)+1);
    float px = 1.0/(minD*le);

    float3x3 cameraMatrix = getCameraMatrix(xa, ya);
    float3 lookAt = LOOK_AT;
    float3 ro = getCameraPosition(cameraMatrix,lookAt,scale,DISTANCE,PAN,PAN_SC);
#ifdef CAMERA_LIGHT
    lightPos[0] = ro;
    lightColor[0] = float3(1)*MIX3;
#endif
    float3 rd = getRayDirection(cameraMatrix,ndc,le);

    Scene scene;
    Light lights[MAX_LIGHTS];
    scene.lights = lights;
    initScene(scene, _u);
    RayData rdat = newRayData(ro, rd);
    rdat.scene = scene;

    Context _c = Context(sys_u, _u, textures, rdat);
    float3 color = getRayColor( ro, rd, px, _c );



    return color;
}

// ACES Filmic tone-mapping approximated - Krzysztof Narkowicz
float3 ACESFilmicApprox(float3 x) { float a = 2.51, b = 0.03, c = 2.43, d = 0.59, e = 0.14;
    return clamp((x*(a*x+b))/(x*(c*x+d)+e),0.,1.); }

float3 toneMap( float3 color ) {
  // map from HDR to Linear
  color = ACESFilmicApprox(color); // ACES Filmic HDR Tone mapping
  // gamma - map from Linear to sRGB
  color = pow( color, float3(0.4545) );

  return color;
}

constant int numTextures = 4; // Number of textures

// Define the structure for the argument buffer
struct Textures {
    array<texture2d<float>, numTextures> textures; // Array of 4 textures
};

fragment float4 fragmentShader0(float4 frag_coord [[position]],
                                constant SysUniforms& sys_u [[buffer(0)]],
                                constant Glsl3Uniforms& _u [[buffer(1)]],
                                array<texture2d<float>, 4> buffers [[texture(0)]],
                                texture2d<float> lastBuffer [[texture(4)]],
                                array<texture2d<float>, 4> textures [[texture(5)]]
                               )
{
    float2 offset = float2(0,0);
    float3 color = getPixelColor(frag_coord.xy+offset, sys_u, _u, textures);
    return float4(color, 1);
}

fragment float4 fragmentShader1(float4 frag_coord [[position]],
                                constant SysUniforms& sys_u [[buffer(0)]],
                                constant Glsl3Uniforms& _u [[buffer(1)]],
                                array<texture2d<float>, 4> buffers [[texture(0)]],
                                texture2d<float> lastBuffer [[texture(4)]],
                                array<texture2d<float>, 4> textures [[texture(5)]]
                               )
{
    float2 offset = float2(0.5,0);
    float3 color = getPixelColor(frag_coord.xy+offset, sys_u, _u, textures);
    return float4(color, 1);
}

// needed to convert from .rgba16Unorm to .bgra8Unorm
fragment float4 fragmentShader2(float4 frag_coord [[position]],
                                constant SysUniforms& sys_u [[buffer(0)]],
                                constant Glsl3Uniforms& _u [[buffer(1)]],
                                array<texture2d<float>, 4> buffers [[texture(0)]],
                                texture2d<float> lastBuffer [[texture(4)]],
                                array<texture2d<float>, 4> textures [[texture(5)]]
                               )
{
    float2 offset = float2(0.5,0.5);
    float3 color = getPixelColor(frag_coord.xy+offset, sys_u, _u, textures);
    return float4(color, 1);
}

// needed to convert from .rgba16Unorm to .bgra8Unorm
fragment float4 fragmentShader3(float4 frag_coord [[position]],
                                constant SysUniforms& sys_u [[buffer(0)]],
                                constant Glsl3Uniforms& _u [[buffer(1)]],
                                array<texture2d<float>, 4> buffers [[texture(0)]],
                                texture2d<float> lastBuffer [[texture(4)]],
                                array<texture2d<float>, 4> textures [[texture(5)]]
                               )
{
    float2 offset = float2(0,0.5);
    float3 color = getPixelColor(frag_coord.xy+offset, sys_u, _u, textures);
    return float4(color, 1);
}

float3 funcTest( float2 fragCoord, constant SysUniforms& sys_u, constant Glsl3Uniforms& _u, array<texture2d<float>, 4> textures ) {
  float3 color = textures[1].sample(sampler(mag_filter::linear, min_filter::linear), fragCoord.xy/sys_u.resolution).rgb;
  return color*color;
}

struct Test {

};

fragment float4 fragmentShader4(float4 frag_coord [[position]],
                                constant SysUniforms& sys_u [[buffer(0)]],
                                constant Glsl3Uniforms& _u [[buffer(1)]],
                                array<texture2d<float>, 4> buffers [[texture(0)]],
                                texture2d<float> lastBuffer [[texture(4)]],
                                array<texture2d<float>, 4> textures [[texture(5)]],
                                sampler colorSampler [[ sampler(0) ]]
                               )
{
    float3 color = float3(0);
    for( int i=0; i < MT_NUM_BUFFERS; i++ ) {
        color += buffers[i].sample(sampler(mag_filter::linear, min_filter::linear), frag_coord.xy/sys_u.resolution).rgb;
    }
    color = color / MT_NUM_BUFFERS;
    color = toneMap(color*o_exp*10);
    // if( frag_coord.x < sys_u.resolution.x / 2) {
    // //   color = textures[0].sample(sampler(mag_filter::linear, min_filter::linear, s_address::repeat, t_address::repeat), frag_coord.xy/sys_u.resolution*2).rgb;
    //   color = sampleTexture(textures[0], frag_coord.xy/sys_u.resolution*2).rgb;
    // } else {
    //   // color = textures[1].sample(sampler(mag_filter::linear, min_filter::linear), frag_coord.xy/sys_u.resolution).rgb;
    //   color = funcTest( frag_coord.xy, sys_u, _u, textures);
    // }
    return float4(color.rgb, 1);
}
