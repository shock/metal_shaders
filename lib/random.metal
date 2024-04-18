#ifndef GLSL_RANDOM
#define GLSL_RANDOM

float random1Df( float n ) {
    return fract(sin(n*12.9898)* 43758.5453123);
}

float random2Df (float2 uv) {
    return fract(sin(dot(uv,
                         float2(12.9898,78.233)))*
        43758.5453123);
}

float random3Df (float3 uvw) {
  float t = random1Df(uvw.x);
  t = random1Df(t+uvw.y);
  return random1Df(t+uvw.z);
}

float2 random2Dv2( float2 st ) {
  return fract(sin(st) * 43758.5453123);
}

float3 random2Dv3( float2 st ) {
  float3 r;
  r.xy = fract(sin(st) * 43758.5453123);
  r.z = random1Df(r.x+r.y);
  return r;
}

float3 random3Dv3( float3 uvw ) {
  float3 r;
  r.r = random1Df(uvw.x + uvw.y + uvw.z);
  r.g = random1Df(uvw.x + uvw.y + uvw.z + 1.2);
  r.b = random1Df(uvw.x + uvw.y + uvw.z + 3.891);
  return r;
}

#endif
