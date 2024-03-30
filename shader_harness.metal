//
//  TestShaders.metal
//  MetalGemini
//
//  Created by Bill Doughty on 3/28/24.
//

#include <metal_stdlib>
#include "shadertoy.metal"
#include "lib/noise/simplex2D.metal"

using namespace metal;
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
  if( u_frame < 0 ) {
    discard_fragment();
    return buffer0.sample(sampler(mag_filter::linear, min_filter::linear), frag_coord.xy/u_resolution);
  }
  float noise = fract(snoise(frag_coord.xy)*frag_coord.x*frag_coord.y);
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
  // return(float4(0));
  float2 halfres = u_resolution / 2;
  if(frag_coord.x < halfres.x && frag_coord.y < halfres.y)
    return shader_day91(frag_coord, u_resolution/2, u_time, buffer0);
  return(float4(0));
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
    float4 pixelColor = buffer1.sample(sampler(mag_filter::linear, min_filter::linear), frag_coord.xy/u_resolution/2);
    return pixelColor;
}
