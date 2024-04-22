#ifndef MT_SKYDOME
#define MT_SKYDOME

#include "./interceptors/plane.metal"
#include "./luminance.metal"
#include "./noise/simplex2D.metal"

float3 hash33(float3 p) {
    p = fract(p * float3(443.8975,397.2973, 491.1871));
    p += dot(p.zxy, p.yxz+19.27);
    return fract(float3(p.x * p.y, p.z*p.x, p.y*p.z));
}

// https://www.shadertoy.com/view/tdSXzD
float3 stars(float3 p, float2 resolution)
{
    p.xz = pR(p.xz, khPI/2.);
    float3 c = float3(0.);
    float res = resolution.x*1.3;

	for (float i=0.;i<6.;i++)
    {
        float3 q = fract(p*(.15*res))-0.5;
        float3 id = floor(p*(.15*res));
        float2 rn = hash33(id).xy;
        float c2 = 1.-smoothstep(0.,.6,length(q));
        c2 *= step(rn.x,.0005+i*i*0.001);
        c += c2*(mix(float3(1.0,0.49,0.1),float3(0.75,0.9,1.),rn.y)*0.1+0.9);
        p *= 1.3;
    }
    return c*c*.8;
}

float fbm( float2 x, int octaves )
{
    float a = 0.0;
    float b = 0.5;
  	float f = 1.0;
    for( int i=0; i<octaves; i++ )
    {
        float n = snoise(f*x);
        a += b*n;           // accumulate values
        b *= 0.5;             // amplitude decrease
        f *= 2.;             // frequency increase
    }

	  return a;
}

constant float3 cloudColor = float3(1.0,0.665,0.581);
// float3 cloudColor = o_color;
float3 skyTexture( float3 uvw, float3 cloudColor ) {
  float2 uv = uvw.xz+7.;
  uv *= 0.0005;
  // float f = fbm3(uvw*0.002,6)*0.5+0.5;
  float f = fbm(uv,6)*0.5+0.5;
  return mix(float3(0.1,0.2,0.8),cloudColor,f*f);
}

float3 skyDome(float3 rd, float star_level, float clouds, float daylight, float2 resolution) {
  float bgDistance = abs(planeIntersect(float3(0),rd,float4(0,-1,0,1000)));
  float3 p = bgDistance*rd;
  float3 tex = skyTexture(p,cloudColor);
  float hor = 1-abs(rd.y);
  hor = smoothstep(0.9,1,hor);
  clouds = clouds/2 + 0.4;
  float3 sky = tex * clouds;
  // sky = mix(tex,mix(cloudColor,tex,0.2)*0.9,hor);
  float3 strs = stars(rd,resolution) * star_level;
  float ss_mix = smoothstep(0.2,0.5,luminance(sky));
  float3 strsx = mix(strs, sky, ss_mix);
  sky = mix(sky, strsx, 1-daylight);
  // sky = strsx * skyBrightness;
  // float3 oc = sun.xyz;
  // float h = -1, b = dot(rd, oc);
  // if( b > 0 ) {
  //   float3 l = oc - b * rd; // l is midpoint on secant line, if sphere center is origin
  //   h = sun.w * sun.w - dot(l, l);
  // }
  // sky = mix(sky,float3(1)*SUN_LUMINANCE,step(0.,b+h));
  return sky;
}

#endif