#include <metal_stdlib>
using namespace metal;
#include "include/metaltoy.metal" // mandatory

struct MyShaderData { // @uniform
    float o_long;
    float2 o_pan;
    float3 o_col1;
    float o_col1r;
    float o_col1g;
    float o_col1b;
    float2 o_multixy;
    float3 o_f3;
    float4 f_f3;
    float2 u_resolution;
};

#include "./lib/random.metal"
#define V2R(p,a) (cos(a)*p+sin(a)*float2(p.y,-p.x))

float4 ripple(float2 pos, float2 size, float time) {
    float angle = time;
    float2 rpos1 = pos - size/2;
    rpos1 = V2R(rpos1, -angle);
    rpos1 += size/2;
    float2 rpos2 = pos - size/2;
    rpos2 = V2R(rpos2, angle);
    rpos2 += size/2;
    float2 c = size/2;
    float r_size = 2;
    float rate = 0.1;
    float2 c2 = c + 50;
    float2 c3 = c + float2(-70,10);
    float d = length(pos-c)/(10*r_size);
    float v = smoothstep(0.,1.,cos(d-time*rate*4.));
    v = v / 2 + 0.5;
    float d2 = length(rpos1-c2)/(20*r_size);
    float v2 = smoothstep(0.,1.,   cos(d2-time*rate*5.));
    v2 = v2 / 2 + 0.5;
    float d3 = length(rpos2-c3)/(30*r_size);
    float v3 = smoothstep(0.,1.,   cos(d3-time*rate*6.));
    v3 = v3 / 2 + 0.5;
    return float4(v, v2, v3, 1.);
}

// #define o_col1 (float3(__u.o_col1r,__u.o_col1g,__u.o_col1b))
#define o_col1 (__u.o_col1)

fragment float4 fragmentShader0(float4 frag_coord [[position]],
                                constant SysUniforms& sys_u [[buffer(0)]],
                                // constant Glsl3Uniforms& _u [[buffer(1)]],
                                texture2d<float> buffer0 [[texture(0)]],
                                texture2d<float> buffer1 [[texture(1)]],
                                texture2d<float> buffer2 [[texture(2)]],
                                texture2d<float> buffer3 [[texture(3)]]
                               )
{
    if( frag_coord.x < (sys_u.resolution.x / 2) ) {
        return float4(float3(fract(sys_u.time)),1);
    }
    return float4(float3(fract(float(sys_u.frame)/60)),1);
}
