#include <metal_stdlib>
using namespace metal;
#include "lib/camera.metal"
#include "lib/osc/glsl3_proxy.metal"
#include "lib/interceptors/plane.metal"
#include "lib/interceptors/sphere.metal"

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

constant int MAX_LIGHTS = 1;

void initLights(thread Light *lights, constant Glsl3Uniforms &_u ) {
    lights[0].pos = float4(0,0,10 + 1000*o_fad1,0);
    lights[0].color = o_col3;
    lights[0].intensity = 10*o_long;
}

struct RayData {
    float3 ro;
    float3 rd;
    float md;
    float3 pos;
    float3 nor;
    int matid;
    int flags;
};

struct Context {
    Glsl3Uniforms _u;
    thread Light *lights;
    RayData rdat;
};

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

constant float4 plane = float4(0,0,1,-10);
constant float4 sphere = float4(0,3,0,70);

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

float3 calcLight( thread Light *lights, thread RayData &rdat,constant Glsl3Uniforms &_u )
{
    Light pointLight = lights[0];
    // Calculate light properties
    float3 toLight = pointLight.pos.xyz - rdat.pos;
    float distance = length(toLight);
    float attenuation = 1;
    float3 lightDir = normalize(toLight);

    // Calculate diffuse lighting
    float diff = max(dot(rdat.nor, lightDir), 0.0);
    float3 diffuse = diff * pointLight.color * pointLight.intensity * attenuation;

    // Output final color
    return diffuse;
}

// float intersectRay( float3 ro, float3 rd, float px, float td, int mask, out float3 pos, out float3 nor, out int matid  ) {
float intersectRay( float3 ro, float3 rd, float px, thread RayData &rdat  ) {
    rdat.matid = BACKDROP;
    float d;

    d = planeIntersect(ro, rd, plane);
    if( d > 0. && d < rdat.md ) {
        float3 pos = ro + rd * d;
        float cb = getCheckerboardColor(pos.x, pos.y, 25);
        if( cb == 1 ) {
            rdat.pos = ro + rd * d; rdat.nor = plane.xyz; rdat.matid = FLOOR; rdat.md = d;
        }
    }

    d = sphereIntersection( ro, rd, sphere );
    if( d > 0. && d < rdat.md ) {
        rdat.md = d; rdat.pos = ro + rd * d; rdat.nor = (rdat.pos-sphere.xyz)/sphere.w; rdat.matid = SPHERE;
    }

//   matDF = (md+td) * px / dot( rd, nor);
    return rdat.md;
}

float3 getRayColor( float3 ro, float3 rd, float px, constant Glsl3Uniforms &_u ) {
    Light lights[MAX_LIGHTS];
    initLights(lights, _u);
    float3 color = rd;

    RayData rdat = newRayData(ro, rd);
    intersectRay( ro, rd, px, rdat );
    if( rdat.flags > 0 ) return float3(1,0,1);
    if( rdat.matid == BACKDROP ) {
        return o_col4;
    }
    if( rdat.matid == FLOOR ) {
        color = o_col2;
    }
    if( rdat.matid == SPHERE ) {
        color = o_col1;
    }
    return color * calcLight( lights, rdat, _u );
}

#ifndef LOOK_AT
#define LOOK_AT float3(0,0,0)
#endif

#ifndef CAM_ZOOM
#define CAM_ZOOM (0.1+ROT1*3.9)
#endif

float3 getPixelColor( float2 fragCoord, float2 u_resolution, constant Glsl3Uniforms &_u ) {
    float scale = SCALE, le = CAM_ZOOM;
    float minD = min(u_resolution.x, u_resolution.y);
    float2 ndc = 2.*(fragCoord-u_resolution*0.5) / u_resolution.x;
    // float2 st = fragCoord/u_resolution;
    float ya = AIM.x * AIM_SC * k2PI;
    float xa = AIM.y * AIM_SC * k2PI;
    float px = 1.0/(minD*le);

    float3x3 cameraMatrix = getCameraMatrix(ya, xa);
    float3 lookAt = LOOK_AT;
    float3 ro = getCameraPosition(cameraMatrix,lookAt,scale,DISTANCE,PAN,PAN_SC);
#ifdef CAMERA_LIGHT
    lightPos[0] = ro;
    lightColor[0] = float3(1)*MIX3;
#endif
    float3 rd = getRayDirection(cameraMatrix,ndc,le);

    float3 color = getRayColor( ro, rd, px, _u );

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


fragment float4 fragmentShader0(float4 frag_coord [[position]],
                               constant float2& u_resolution [[buffer(0)]],
                               constant uint& u_frame [[buffer(1)]],
                               constant float& u_time [[buffer(2)]],
                               constant uint& u_pass [[buffer(3)]],
                               constant Glsl3Uniforms& _u [[buffer(4)]],
                               texture2d<float> buffer0 [[texture(0)]],
                               texture2d<float> buffer1 [[texture(1)]],
                               texture2d<float> buffer2 [[texture(2)]],
                               texture2d<float> buffer3 [[texture(3)]]
                               )
{
    float3 color = getPixelColor(frag_coord.xy, u_resolution, _u);
    color = toneMap(color);
    return float4(color, 1);
}
