#include <metal_stdlib>
using namespace metal;
#include "include/metaltoy.metal" // mandatory

// #define texture texture2D
// #define ut iTime
#define kPI 3.14159265
#define khPI 1.57079633
#define k3qPI 4.71238898
#define k2PI 6.2831853
#define kPIi 0.3183089
#define k2PIi 0.1591549
#define f(x) fract(x)
#define l(x) length(x)
#define c(x,y,z) clamp(x,y,z)
#define p(x,y) pow(x,y)
#define r(x) f(sin(x)*100000.0)
#define n(x) normalize(x)
#define v3 float3(0)
#define S(a,b,x) smoothstep(a,b,x)
#define SS(x) smoothstep(0.,1.,x)
#define SC(x,a,b) (smoothstep(0.,1.,(x-a)/(b-a))*(b-a)+a)

#define mod(a,b) (a-(int(a/b)*b))

class TestClass {

  constant SysUniforms *sys_u;

  public:

   TestClass( constant SysUniforms *sys_u ) {
    sys_u = sys_u;
  }

  float smoothMin(float x, float min) {
    float k = (1.-min);
    return SS((x - min)/k)*k+min;
  }

  float notch(float t, float a, float b, float w ) {
    return smoothstep(b, b+w, t) + 1. - smoothstep(a-w, a, t );
  }

  #define SMin(x,m) smoothMin(x,m)
  #define inf 1e20

  #define m float2(iMouse.xy/iResolution.xy)
  #define m2 (float2(iMouse.xy/iResolution)*2.-1.)
  #define md ((m - 0.5) * 2.)
  // #define time iTime

  float SCALE = 2.;
  float cameraDistance = 1.;
  float lineWidth;

  #define fill(x,f) (1. - smoothstep(0.,lineWidth*(f),(x)))
  #define stroke(x,f) (1. - smoothstep(0.,lineWidth*(f),abs(x)))
  #define glow(x,f) (1. - pow(smoothstep(0.,(f)*lineWidth,abs(x)),0.2))
  #define aglow(x,f) (1. - (smoothstep(0.,(f)*lineWidth,abs(x))))
  #define fillGlow(x,f) (1. - pow(smoothstep(0.,(f)*lineWidth,(x)),0.2))

  // Misc Functions

  float2 pR(float2 p,float a) {
    return cos(a)*p+sin(a)*float2(p.y,-p.x);
  }

  float3 pal(float t) {
    float3 a=float3(0.5,0.5,0.5),
    b=float3(0.5),
    c=float3(1),d=float3(0,0.33,0.67);
    return a+b*cos(6.2318*(c*t+d));
  }

  // 2D Functions

  float angle( float2 p, float2 c ) {
    float2 cp = p-c;
    float a = atan( cp.y / cp.x );
    a = mod(a + k2PI, k2PI);
    return a;
  }

  float2 polar2cart( float theta, float r ) {
    float c = cos(theta), s = sin(theta);
    return float2(c*r, s*r);
  }

  // distance to line segment
  float sdSegment2( float2 p, float2 a, float2 b ) {
    float2 pa = p-a, ba = b-a;
    float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
    return length( pa - ba*h );
  }

  // distance between points
  float sdPoint2( float2 p1, float2 p2 ) {
    return length( p1 - p2 );
  }

  float sdCircle( float2 p, float2 c, float r ) {
    float2 q = p;//-c.xy;
    q = q-c.xy;
    float d = length(q);
    d = d - r;
    return d;
  }

  // 3D Functions

  float sdPlane( float3 ro, float3 rd, float4 p ) {
    return -(dot(ro,p.xyz)+p.w)/dot(rd,p.xyz);
  }

  float3 intersectCoordSys(float3 o,float3 d, float3 c, float3 u, float3 v )
  {
    float3  co = o - c;
    float3  n = cross(u,v);
    float t = -dot(n,co)/dot(d,n);
    float r =  dot(u,co + d*t);
    float s =  dot(v,co + d*t);
    return float3(t,s,r);
  }

  // Procedural Textures

  float chex(float2 uv)
  {
    float2 w = fwidth(uv) + 0.01;
    float2 i = 2.0*(abs(f((uv-0.5*w)*0.5)-0.5)-abs(f((uv+0.5*w)*0.5)-0.5))/w;
    return 0.5 - 0.5*i.x*i.y;
  }

  // Shape creators

  float R = 01.25;

  float4 randomLine( int i ) {
    float aa = r(float(i)+0.31)*112.9;
    float4 l = float4(r(aa+1.),r(aa+2.1), r(aa+3.8), r(aa+6.7));
    l = l * 4. - 2.;
    l *= R;
    return l;
  }

  float3 randomCircle( int i ) {
    float aa = r(float(i)*0.001+0.233)*(12.);
    float3 c = float3(-1.+2.*r(aa+1.),-1.+2.*r(aa+2.1),r(aa+3.8)+0.2);
    c *= R;
    return c;
  }

  /*

  WWWWW  WWWWW  WWWWW  WW   W  WWWWW
  W      W      W      W W  W  W
  WWWWW  W      WWW    W  W W  WWW
      W  W      W      W   WW  W
  WWWWW  WWWWW  WWWWW  W    W  WWWWW

  */

  float2 center1 = float2(0,0);
  float2 center2d = float2(0,-2);
  float3x3 plane = float3x3(
    float3(-1,-1,-1),
    normalize(float3(1,0,0)),
    normalize(float3(0,1,0))
  );

  float3 sprouts( float2 p ) {
    float xRatio = 0.125;
    float yRatio = 1.1;
    p = 4. - p;
    p = polar2cart(p.x*k2PI*xRatio, p.y*yRatio);
    p = polar2cart(p.y*k2PI*xRatio, p.x*yRatio);
    p = polar2cart(p.x*k2PI*xRatio, p.y*yRatio);
    p = polar2cart(p.y*k2PI*xRatio, p.x*yRatio);
    float a;
    a = angle(p, center1);
    a = l(p);
    float ta = time*0.125;
    float c = 0.;
    // float2 q = polar2cart( -ta*k2PI, sin(time)+1.);
    a = fract(a * k2PIi + ta);
    a = SS(abs(a*2.-1.));
    c += a;
    float3 col = float3(c);
    return col;
  }

  float3 screen( float3 col1, float3 col2 ) {
    return 1. - (1.-col1)*(1.-col2);
  }

  float2 paraline( float2 a, float2 b, float t ) {
    return mix(a,b,t);
  }

  float slidingGlow( float2 p, float4 line, float t ) {
    float color = 0.;
    float2 lp = paraline(line.xy, line.zw, t );
    float dp;
    dp = sdPoint2(p,lp);
    float d = sdSegment2(p, line.xy, line.zw);
    color += glow(d*dp, 20.);
    return color;
  }

  // float linePoint( float2 p, float4 line, float t ) {
  //   float color = 0.;
  //   float2 lp = paraline(line.xy, line.zw, t );
  //   pR(lp, sin(time*0.7)*line.y);
  //   float dp;
  //   float2 q = lp - p;
  //   dp = dot(q,q);
  //   color += glow(dp, 20.);
  //   return color;
  // }

  float doCircle( float2 p, float3 c ) {
    float2 cp = p-c.xy;
    float d = dot(cp,cp) - c.z;
    return glow( d, 50. );
    // return glow( sdCircle(p, c.xy, c.z), 30. );
  }

  #define NUM_CIRCS 8
  #define NUM_LINES 5

  float3 doCircles( float2 p ) {
    float3 color = float3(0);
    int i = 0;
    float3 c;
    for( i=0; i < NUM_CIRCS; i++ ) {
      c = randomCircle(i);
      c.xy = pR(c.xy,time*c.y);
      c.z *= sin(time*c.z)*0.5+0.7;
      color = screen(color,doCircle( p, c ) * pal(c.z));
    }
    return color;
  }

  float3 doLines( float2 p ) {
    float3 color = float3(0);
    float t = sin(time)*0.5+0.5;
    float4 l;
    for( int i=0; i < NUM_LINES; i++ ) {
      l = randomLine(i);
      l.xy = pR(l.xy, time*l.x);
      l.zw = pR(l.zw, -time*l.z*0.1);
      color = screen(color,slidingGlow( p, l, t ) * pal(length(l.xz)));
    }
    return color;
  }

  float3 get2dColor( float2 p ) {
    p -= center2d;
    float3 color = float3(0);
    color += doCircles(p);
    color += doLines(p);
    // color = screen(color,sprouts(p.yx)*(-0.4+0.5*sin(time*0.33)));
    return color;
  }

  float3 getRayColor( float3 ro, float3 rd ) {
    float3 color = float3(0);

    float3 pi = intersectCoordSys(ro, rd, plane[0], plane[1], plane[2] );
    if( pi.x > 0. ) color += get2dColor(pi.zy);
    pi = intersectCoordSys(ro, rd, plane[0], plane[2].yxz, float3(0,1,0) );
    // if( pi.x > 0. ) color = screen(color,get2dColor(pi.yz));
    if( pi.x > 0. ) color += get2dColor(pi.yz);
    return color;
  }

  float3 hash3( float n ) { return fract(sin(float3(n,n+1.0,n+2.0))*43758.5453123); }

  struct Ray {
    float3 ro;
    float3 rd;
  };

  float3x3 camMatrix( float3 ff ) {
    ff = normalize(ff);
    float3 uu = normalize(cross(ff, float3(0,1,0)));
    float3 vv = cross(uu, ff);
    return float3x3(uu,vv,ff);
  }

  float2 iResolution;
  float time = 0;
  float2 iMouse = float2(0);

public:
  void setUniforms( float u_time, float2 u_mouse, float2 u_resolution ) {
    iResolution = u_resolution;
    time = u_time;
    iMouse = u_mouse;
  }

  float4 mainImage( float2 fragCoord ) {
    plane[2].yz = pR(plane[2].yz,m.x*k2PI);

    float minD = min(iResolution.x, iResolution.y);
    lineWidth = (0.0013*SCALE*(600./minD));

    float2 cartesian = 2.*(fragCoord-iResolution.xy*0.5) / minD;
    // float2 q = fragCoord/iResolution.xy;

    float3 target = float3(0,0,0);
    float3 camera = float3(0,0,1);
    float3x3 cmat = camMatrix(target-camera);
    float le = 1.;
    float3 rd = normalize(float3(cartesian,le) * cmat);

    // float3 col = get2dColor( cartesian );
    float3 col = getRayColor( camera, rd );

    // dithering
    // col += (1.0/255.0)*hash3(cartesian.x+13.3214*cartesian.y);

    // col *= 1. - texture(u_tex0, q).rgb *0.2;
    float4 fragColor = float4(col,1);
    return fragColor;
  }
};

fragment float4 fragmentShader0(float4 frag_coord [[position]],
                                constant SysUniforms& sys_u [[buffer(0)]],
                                array<texture2d<float>, 4> buffers [[texture(0)]]
                               )
{
  TestClass tc = TestClass(&sys_u);
  float2 u_mouse = float2(fract(sys_u.time*0.1)*sys_u.resolution);
  tc.setUniforms( sys_u.time, u_mouse, sys_u.resolution );
  // return tc.mainImage( frag_coord.xy );

  float3 color = tc.mainImage( frag_coord.xy ).rgb;
  float3 pixel = buffers[0].sample(sampler(mag_filter::linear, min_filter::linear), frag_coord.xy/sys_u.resolution).rgb;
  return float4(color+pixel*0.99,1);
}

fragment float4 fragmentShader1(float4 frag_coord [[position]],
                                constant SysUniforms& sys_u [[buffer(0)]],
                                array<texture2d<float>, 4> buffers [[texture(0)]]
                               )
{
    float3 color = buffers[0].sample(sampler(mag_filter::linear, min_filter::linear), frag_coord.xy/sys_u.resolution).rgb;
    return float4(color, 1);
 }
