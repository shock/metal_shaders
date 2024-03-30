//
//  TestShaders.metal
//  MetalGemini
//
//  Created by Bill Doughty on 3/28/24.
//

#include <metal_stdlib>
#include "shadertoy.metal"
#include "lib/noise/simplex2D.metal"
#include "include.metal"

using namespace metal;

#define V2R(p,a) (cos(a)*p+sin(a)*float2(p.y,-p.x))

float4 ripple(float2 pos, float2 size, float time) {
    float angle = -time*2;
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
    float4 color = float4(v, v2, v3, 1.);
    return color;
}


fragment float4 fragmentShader0(float4 frag_coord [[position]],
                               constant float2& u_resolution [[buffer(0)]],
                               constant uint& u_frame [[buffer(1)]],
                               constant float& u_time [[buffer(2)]],
                               constant uint& u_pass [[buffer(3)]],
                               texture2d<float> buffer0 [[texture(0)]],
                               texture2d<float> buffer1 [[texture(1)]],
                               texture2d<float> buffer2 [[texture(2)]],
                               texture2d<float> buffer3 [[texture(3)]]
                               )
{
  if( u_frame > 0 ) {
    discard_fragment();
    return float4(0);
  }
  float2 pos = frag_coord.xy;
  pos = floor(pos);
  float noise = fract(snoise(pos.xy)*pos.x*pos.y);
  return(float4(float3(noise),1));
}

fragment float4 fragmentShader1(float4 frag_coord [[position]],
                               constant float2& u_resolution [[buffer(0)]],
                               constant uint& u_frame [[buffer(1)]],
                               constant float& u_time [[buffer(2)]],
                               constant uint& u_pass [[buffer(3)]],
                               texture2d<float> buffer0 [[texture(0)]],
                               texture2d<float> buffer1 [[texture(1)]],
                               texture2d<float> buffer2 [[texture(2)]],
                               texture2d<float> buffer3 [[texture(3)]]
                               )
{
    float4 pixelColor = buffer0.sample(sampler(mag_filter::linear, min_filter::linear), frag_coord.xy/u_resolution*0.3);
    return pixelColor;
}


fragment float4 fragmentShader2(float4 frag_coord [[position]],
                               constant float2& u_resolution [[buffer(0)]],
                               constant uint& u_frame [[buffer(1)]],
                               constant float& u_time [[buffer(2)]],
                               constant uint& u_pass [[buffer(3)]],
                               texture2d<float> buffer0 [[texture(0)]],
                               texture2d<float> buffer1 [[texture(1)]],
                               texture2d<float> buffer2 [[texture(2)]],
                               texture2d<float> buffer3 [[texture(3)]]
                               )
{
// float4 shader_day91(float4 frag_coord [[position]],
//                              float2 u_resolution,
//                              float time,
//                              texture2d<float, access::sample> texture) {

    constexpr sampler s(address::repeat, filter::linear);

    float2 uv = float2(frag_coord.x / u_resolution.x, frag_coord.y / u_resolution.y) - 0.5;
    uv /= float2(u_resolution.y / u_resolution.x, 1.0);

    float globalTime = u_time * 0.1;

    float distanceFromCenter = length(uv);
    float radius = 0.4;
    float alpha = 1.0;
    float alphaFalloffSpeed = 0.08;

    if (distanceFromCenter > radius) {
        alpha = max(0.0, 1.0 - (distanceFromCenter - radius) / alphaFalloffSpeed);
    }

    if (alpha == 0.0) {
        // discard_fragment();
    }

    float2 uvZoomed = uv * 4.0;

    float fractalColor = Turbulence(uvZoomed, globalTime, s, buffer1);
    // fractalColor *= Ring(uvZoomed)
    float3 col = ripple(frag_coord.xy, u_resolution, u_time).rgb * (fractalColor);
    // col = normalize(col);// / fractalColor;
    col = pow(SS(col),0.4);
    // col *= alpha;
    // return color;
    return float4(col, 1.0);
}


// fragment float4 fragmentShader3(float4 frag_coord [[position]],
//                                constant float2& u_resolution [[buffer(0)]],
//                                constant uint& u_frame [[buffer(1)]],
//                                constant float& u_time [[buffer(2)]],
//                                constant uint& u_pass [[buffer(3)]],
//                                texture2d<float> buffer0 [[texture(0)]],
//                                texture2d<float> buffer1 [[texture(1)]],
//                                texture2d<float> buffer2 [[texture(2)]],
//                                texture2d<float> buffer3 [[texture(3)]]
//                                )
// {
//     float4 pixelColor = buffer2.sample(sampler(mag_filter::linear, min_filter::linear), frag_coord.xy/u_resolution);
//     return SS(pixelColor);
// }

// fragment float4 fragmentShader2(float4 frag_coord [[position]],
//                                constant float2& u_resolution [[buffer(0)]],
//                                constant uint& u_frame [[buffer(1)]],
//                                constant float& u_time [[buffer(2)]],
//                                constant uint& u_pass [[buffer(3)]],
//                                texture2d<float> buffer0 [[texture(0)]],
//                                texture2d<float> buffer1 [[texture(1)]],
//                                texture2d<float> buffer2 [[texture(2)]],
//                                texture2d<float> buffer3 [[texture(3)]]
//                                )
// {
//     float4 pixelColor = buffer1.sample(sampler(mag_filter::linear, min_filter::linear), frag_coord.xy/u_resolution/2);
//     return pixelColor;
// }
