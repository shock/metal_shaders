#include <metal_stdlib>
using namespace metal;

struct MyShaderData { // @uniform
    float o_long;
    float2 o_pan;
    float2 o_multixy;
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

fragment float4 fragmentShader0(float4 frag_coord [[position]],
                               constant float2& u_resolution [[buffer(0)]],
                               constant uint& u_frame [[buffer(1)]],
                               constant float& u_time [[buffer(2)]],
                               constant uint& u_pass [[buffer(3)]],
                               constant MyShaderData& uniforms [[buffer(4)]],
                               texture2d<float> buffer0 [[texture(0)]],
                               texture2d<float> buffer1 [[texture(1)]],
                               texture2d<float> buffer2 [[texture(2)]],
                               texture2d<float> buffer3 [[texture(3)]]
                               )
{
  // float frameTime = float(u_frame)/60.0;
  // if( frag_coord.x < u_resolution.x / 4) {
  //   return float4(fract(frameTime));
  // }
  // if( frag_coord.x < u_resolution.x / 2) {
  //   return float4(fract(u_time));
  // }
  // float4 color = ripple(frag_coord.xy, u_resolution, frameTime);
  // return pow(color,2);
  // int col = u_frame % uint(u_resolution.x);
  // int row = u_frame / uint(u_resolution.x);
  // if( int(frag_coord.x) == col ) {
  //   return float4(1);
  // }
  float4 pixelColor = buffer0.sample(sampler(mag_filter::linear, min_filter::linear), frag_coord.xy/u_resolution);
  // if(float(u_frame)/100000 != pixelColor.x) {
  //   // return float4(1,0,1,1);
  // }
  float maxr = max(u_resolution.x, u_resolution.y)/1.5;
  // float maxr = u_resolution.y;
  float2 rand_coord;
  float angle = float(u_frame)/10000*2*3.14159;
  float rand = random1Df(u_time);
  // rand=sqrt(rand);
  // float rand = sin(u_time)/2+0.5;
  // float rand2 = random1Df(u_time*frag_coord.y);
  // return float4(rand);
  rand_coord.x = floor(cos(angle)*maxr*rand);
  rand_coord.y = floor(sin(angle)*maxr*rand);
  // rand_coord.x = rand;
  // rand_coord.y = rand2;
  // return float4(rand,rand2,1,1);
  // rand_coord.xy *= u_resolution;
  rand_coord += u_resolution.xy/2;
  if( abs(rand_coord.x - frag_coord.x) < 1 && abs(rand_coord.y - frag_coord.y) < 1 ){
    return pixelColor + .01;
  }
  return float4(uniforms.o_multixy.x, uniforms.o_multixy.y, uniforms.o_pan.x, uniforms.o_long)*uniforms.o_long;
  return pixelColor;
}

// fragment float4 fragmentShader1(float4 frag_coord [[position]],
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
//   // float frameTime = float(u_frame)/60.0;
//   // if( frag_coord.x < u_resolution.x / 4) {
//   //   return float4(fract(frameTime));
//   // }
//   // if( frag_coord.x < u_resolution.x / 2) {
//   //   return float4(fract(u_time));
//   // }
//   // float4 color = ripple(frag_coord.xy, u_resolution, frameTime);
//   // return pow(color,2);
//   // int col = u_frame % uint(u_resolution.x);
//   // int row = u_frame / uint(u_resolution.x);
//   // if( int(frag_coord.x) == col ) {
//   //   return float4(1);
//   // }
//   float4 pixelColor = buffer1.sample(sampler(mag_filter::linear, min_filter::linear), frag_coord.xy/u_resolution);
//   // if(float(u_frame)/100000 != pixelColor.x) {
//   //   // return float4(1,0,1,1);
//   // }
//   return pixelColor + 0.01;
// }
