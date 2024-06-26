#include <metal_stdlib>
using namespace metal;

#pragma arguments

float2 u_resolution;
float u_time;
float2 u_mouse_b;
vec4 u_date;
sampler2D u_tex0;

#pragma body
#pragma transparent

constant float2 u_mouse_b = float2(0);
#define iResolution u_resolution
#define iMouse float3(u_mouse_b,0)
#define iTime u_time
#define ut iTime
#define kPI 3.14159265
#define khPI 1.57079633
#define k3qPI 4.71238898
#define k2PI (2.*kPI)
#define kPIi (1./kPI)
#define k2PIi (1./k2PI)
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

float smoothMin(float x, float min) {
  float k = (1.-min);
  return SS((x - min)/k)*k+min;
}
float notch(float t, float a, float b, float w ) {
  return smoothstep(b, b+w, t) + 1. - smoothstep(a-w, a, t );
}

#define SMin(x,m) smoothMin(x,m)
#define inf 1e20

// constant float2 m = float2(iMouse.xy/iResolution);
constant float2 m = float2(1);
// float2 md = ((m - 0.5) * 2.);
constant float t = ut;
constant #define ssigScale (1./0.4813)
constant float ssig = sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(t))))))))))*ssigScale;
constant float2 tc1;
constant float SCALE = 1.;
constant float cameraDistance = 1.;
constant float lineWidth = (0.004*SCALE*cameraDistance);
constant float cSpread = 0.05 * SCALE;
constant float t1, t2, t3, t4;
constant float s1, s2, s3, s4;
// float cSpread = 0.;
constant mat3 pm, pmi;

#define fill(x,f) (1. - smoothstep(0.,lineWidth*(f),(x)))
#define stroke(x,f) (1. - smoothstep(0.,lineWidth*(f),abs(x)))
#define glow(x,f) (1. - pow(smoothstep(0.,(f)*lineWidth,abs(x)),0.2))
#define fillGlow(x,f) (1. - pow(smoothstep(0.,(f)*lineWidth,(x)),0.2))
#define T (ut*0.25)

struct RI { // 3D Ray Info
  float3 pos;
  float d;
  float3 rd;
  float3 nor;
  int mid;
  float3 col;
  float specPower;
  float specLevel;
};

struct DI { // 2D Distance Info
  float2 pos;
  float d;
  float3 col;
  float a;
  int mid;
  float specPower;
  float specLevel;
};

RI minRI( RI ri1, RI ri2 ) {
  if( ri1.d <= ri2.d ) return ri1;
  return ri2;
}

DI minDI( DI di1, DI di2 ) {
  if( di1.d <= di2.d ) return di1;
  return di2;
}

// Misc Functions

void pR(inout float2 p,float a) {
	p=cos(a)*p+sin(a)*float2(p.y,-p.x);
}

// Noise functions

float random (in float2 st) {
    return fract(sin(dot(st.xy,
                         float2(12.9898,78.233)))
                * 43758.5453123);
}

// Value noise by Inigo Quilez - iq/2013
// https://www.shadertoy.com/view/lsf3WH
float noise(float2 st) {
  float2 i = floor(st);
  float2 f = fract(st);
  float2 u = f*f*(3.0-2.0*f);
  return mix( mix( random( i + float2(0.0,0.0) ),
                    random( i + float2(1.0,0.0) ), u.x),
              mix( random( i + float2(0.0,1.0) ),
                    random( i + float2(1.0,1.0) ), u.x), u.y);
}

float lines(in float2 pos, float b){
    float scale = 10.0;
    pos *= scale;
    return smoothstep(0.0,
                    .5+b*.5,
                    abs((sin(pos.x*3.1415)+b*2.0))*.5);
}

// 2D Distance Functions

float circleDist(float2 p, float radius) {
	return length(p) - radius;
}

float sdSegment( float2 p, float2 a, float2 b ) {
  float2 pa = p-a, ba = b-a;
  float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
  return length( pa - ba*h );
}

float roundSeg( float2 p, float2 a, float2 b, float r ) {
  return sdSegment( p, a, b ) - r;
}

float sdTrapezoid( in float2 p, in float r1, float r2, float he )
{
    float2 k1 = float2(r2,he);
    float2 k2 = float2(r2-r1,2.0*he);
    p.x = abs(p.x);
    float2 ca = float2(p.x-min(p.x,(p.y<0.0)?r1:r2), abs(p.y)-he);
    float2 cb = p - k1 + k2*clamp( dot(k1-p,k2)/dot(k2,k2), 0.0, 1.0 );
    float s = (cb.x<0.0 && ca.y<0.0) ? -1.0 : 1.0;
    return s*sqrt( min(dot(ca,ca),dot(cb,cb)) );
}

// 3D ray intersection functions

float pD(float3 ro,float3 rd,vec4 p) {
	return -(dot(ro,p.xyz)+p.w)/dot(rd,p.xyz);
}

vec4 pI(float3 ro, float3 rd,vec4 p) {
	float d=pD(ro,rd,p);
  float3 i = ro+rd*d;
	return vec4(i,d);
}

// cylinder defined by extremes pa and pb, and radious ra
vec4 cylIntersect( in float3 ro, in float3 rd, in float3 pa, in float3 pb, float ra )
{
    float3 ca = pb-pa;
    float3 oc = ro-pa;
    float caca, card, caoc, a, b, c, h, t, y;
    caca = dot(ca,ca); card = dot(ca,rd); caoc = dot(ca,oc);
    a = caca - card*card; b = caca*dot( oc, rd) - caoc*card;
    c = caca*dot( oc, oc) - caoc*caoc - ra*ra*caca;
    h = b*b - a*c;
    if( h<0.0 ) return vec4(-1.0); //no intersection
    h = sqrt(h); t = (-b-h)/a;
    // body
    y = caoc + t*card;
    if( y>0.0 && y<caca ) return vec4( (oc+t*rd-ca*y/caca)/ra, t );
    // caps
    t = (((y<0.0)?0.0:caca) - caoc)/card;
    if( abs(b+a*t)<h ) return vec4( ca*sign(y)/caca, t );
    return vec4(-1.0); //no intersection
}

// torus distance
float torIntersect( in float3 ro, in float3 rd, in float2 tor )
{
    float po = 1.0;
    float Ra2 = tor.x*tor.x;
    float ra2 = tor.y*tor.y;
    float m = dot(ro,ro);
    float n = dot(ro,rd);
    float k = (m + Ra2 - ra2)/2.0;
    float k3 = n;
    float k2 = n*n - Ra2*dot(rd.xy,rd.xy) + k;
    float k1 = n*k - Ra2*dot(rd.xy,ro.xy);
    float k0 = k*k - Ra2*dot(ro.xy,ro.xy);

    if( abs(k3*(k3*k3-k2)+k1) < 0.01 )
    {
        po = -1.0;
        float tmp=k1; k1=k3; k3=tmp;
        k0 = 1.0/k0;
        k1 = k1*k0;
        k2 = k2*k0;
        k3 = k3*k0;
    }

    float c2 = k2*2.0 - 3.0*k3*k3;
    float c1 = k3*(k3*k3-k2)+k1;
    float c0 = k3*(k3*(c2+2.0*k2)-8.0*k1)+4.0*k0;
    c2 /= 3.0;
    c1 *= 2.0;
    c0 /= 3.0;
    float Q = c2*c2 + c0;
    float R = c2*c2*c2 - 3.0*c2*c0 + c1*c1;
    float h = R*R - Q*Q*Q;

    if( h>=0.0 )
    {
        h = sqrt(h);
        float v = sign(R+h)*pow(abs(R+h),1.0/3.0); // cube root
        float u = sign(R-h)*pow(abs(R-h),1.0/3.0); // cube root
        float2 s = float2( (v+u)+4.0*c2, (v-u)*sqrt(3.0));
        float y = sqrt(0.5*(length(s)+s.x));
        float x = 0.5*s.y/y;
        float r = 2.0*c1/(x*x+y*y);
        float t1 =  x - r - k3; t1 = (po<0.0)?2.0/t1:t1;
        float t2 = -x - r - k3; t2 = (po<0.0)?2.0/t2:t2;
        float t = 1e20;
        if( t1>0.0 ) t=t1;
        if( t2>0.0 ) t=min(t,t2);
        return t;
    }

    float sQ = sqrt(Q);
    float w = sQ*cos( acos(-R/(sQ*Q)) / 3.0 );
    float d2 = -(w+c2); if( d2<0.0 ) return -1.0;
    float d1 = sqrt(d2);
    float h1 = sqrt(w - 2.0*c2 + c1/d1);
    float h2 = sqrt(w - 2.0*c2 - c1/d1);
    float t1 = -d1 - h1 - k3; t1 = (po<0.0)?2.0/t1:t1;
    float t2 = -d1 + h1 - k3; t2 = (po<0.0)?2.0/t2:t2;
    float t3 =  d1 - h2 - k3; t3 = (po<0.0)?2.0/t3:t3;
    float t4 =  d1 + h2 - k3; t4 = (po<0.0)?2.0/t4:t4;
    float t = 1e20;
    if( t1>0.0 ) t=t1;
    if( t2>0.0 ) t=min(t,t2);
    if( t3>0.0 ) t=min(t,t3);
    if( t4>0.0 ) t=min(t,t4);
    return t;
}

float3 torNormal( in float3 pos, float2 tor )
{
    return normalize( pos*(dot(pos,pos)-tor.y*tor.y - tor.x*tor.x*float3(1.0,1.0,-1.0)));
}

// Sphere distance
float sD(float3 ro,float3 rd,vec4 sph) {
	float3 oc=ro-sph.xyz;
	float b=dot(oc,rd), c=dot(oc,oc)-sph.w*sph.w, h=b*b-c;
	if(h<0.0) return -1.0;
	return -b-sqrt(h);
}


// Procedural Textures

float chex(float2 uv)
{
  float2 w = fwidth(uv) + 0.01;
  // w = w / 2. + 0.01;
  float2 i = 2.0*(abs(f((uv-0.5*w)*0.5)-0.5)-abs(f((uv+0.5*w)*0.5)-0.5))/w;
  return 0.5 - 0.5*i.x*i.y;
}

float grid( float2 uv ) {
  float2 w = fwidth(uv) + 0.2;
  float2 i = 2.0 * ( length( fract((uv-0.5)*0.5) - 0.5 ) - length(fract((uv+0.5)*0.5)-0.5) ) / w;
  float r = length((fract(i*0.5) - 0.5)*2.9);
  r = length(i); r = 1. - r; r = clamp(r, 0., 1.); r = mix( r, 0.28, min(length(fwidth(uv)),0.9));
  return r;
}

float tiles( float2 uv ) {
  float2 w = fwidth(uv) + 0.1;
  float2 i = 2.0 * ( length( fract((uv-0.5*w)*0.5) - 0.5 ) - length(fract((uv+0.5*w)*0.5)-0.5) ) / w;
  float r = length((fract(i*0.5) - 0.5)*2.9);
  r = length(i); r = 1. - r; r = clamp(r, 0., 1.); r = mix( r, 0.28, min(length(fwidth(uv)),0.9));
  return r;
}

float dots(float2 uv) {
	return mix(1.-l(f(uv)*2.-1.),0.25,min(l(fwidth(uv)),1.));
}

float wood( float2 uv ) {
  float w = l(fwidth(uv))*18.;
  uv *= float2(1.,0.3);
  pR(uv, noise(uv));
  float p = lines(uv,.5);
  return mix(p,0.5,SS(w));
}

float ai( float x, float m, float n ) {
    if( x>m ) return x; float a, b, t;
    a = 2.0*n - m; b = 2.0*m - 3.0*n; t = x/m;
    return (a*t + b)*t*t + n;
}

/*

 WWWWW  WWWWW  WWWWW  WW   W  WWWWW
 W      W      W      W W  W  W
 WWWWW  W      WWW    W  W W  WWW
     W  W      W      W   WW  W
 WWWWW  WWWWW  WWWWW  W    W  WWWWW

*/
float3 circle = float3(0,0,0.3);
float3 faceCenter = float3(0,0,0);
float3 rimCenter = faceCenter - float3(0,0,0.01);
float3 faceBack = float3(0,0,-1.1);
float faceRadius = 2.0;
float rimThickness = 0.12;
float innerRadius = faceRadius - rimThickness;
float2 rimTorus = float2( faceRadius, rimThickness );
float bubbleRad = 8.*faceRadius;
// float2 rimTorus = float2( rimInside, rimTickness );
vec4 facePlane = vec4(n(float3(0,0,1)),-0.025);
vec4 hourPlane = vec4(n(float3(0,0,1)),facePlane.w-0.05);
vec4 minutePlane = vec4(n(float3(0,0,1)),hourPlane.w-0.02);
vec4 secondPlane = vec4(n(float3(0,0,1)),minutePlane.w-0.02);
vec4 bubble = vec4(0,0,-secondPlane.w+0.02-bubbleRad,bubbleRad);
vec4 wallPlane = vec4(n(float3(0,0,1)),rimThickness*1.5);
float3 lightPos = float3( faceRadius*1.,0.,11.4);
float lightIntensity = 10.;
float ambientLevel = 2.;

#define BACK 0
#define WALL 1
#define FACE 2
#define RIM 3
#define HOUR 4
#define MINUTE 5
#define SECOND 6

#define WALL_COLOR float3(0.395,0.25, 0.21)*0.66
// #define FACE_COLOR float3(0.4,0.5,0.78) * 0.95
#define FACE_COLOR float3(0.46,0.55,0.78) * 0.95
// #define RIM_COLOR float3(0.285,0.38, 0.4)*1.
#define RIM_COLOR float3(0.385+sin(t*0.125)*0.1,0.43, 0.2)*1.
#define HAND_COLOR float3(0.1)

RI newRI() {
  RI ri; ri.d = inf; ri.mid = BACK; ri.col=v3; ri.specPower = 0.; ri.specLevel = 1.; return ri;
}

DI newDI() {
  DI di; di.specPower = 0.; di.specLevel = 1.; return di;
}

// #define HIQ
#define REAL_WOOD
// #define STEREO

#ifdef HIQ
#define MA 0.75
#else
#define MA 1.
#endif

float handOffset = innerRadius * 0.055;
DI hand( float2 pos, float angle, float length, float r, float d ) {
  length *= 0.94;
  pR(pos, -angle);
  pos = pos - float2(0,length - handOffset);
  DI di = newDI();
  di.d = sdTrapezoid( pos, r, r*0.28, length );
  di.col = HAND_COLOR;
  di.a = fillGlow(di.d,5.*d);
  di.specPower = 30.;
  return di;
}

float seconds = floor(u_date.w);
// float seconds = 0.;
float minutes = seconds / 60.;
float hours = minutes / 60.;
float hAngle = mod(hours, 12.) * k2PI / 12.;
float mAngle = mod(minutes, 60.) * k2PI / 60.;
float sAngle = mod(seconds, 60.);

float handWidth = 0.035 * innerRadius;
float minHandLength = 0.49 * innerRadius;
float hourHandLength = 0.32 * innerRadius;
DI minuteHand( float2 pos, float d ) {
  return hand( pos, mAngle, minHandLength, handWidth, d );
}
DI hourHand( float2 pos, float d ) {
  return hand( pos, hAngle, hourHandLength, handWidth, d );
}

float secHandLength = 0.83 * innerRadius;
float secHandWidth = 0.013 * innerRadius;
DI secondHand( float2 pos, float d ) {
  float2 a = faceCenter.xy + float2(0,-0.02);
  float2 b = faceCenter.xy + float2(0, secHandLength);
  pR(a, sAngle); pR(b, sAngle);
  DI di = newDI();
  di.d = roundSeg(pos, a, b, secHandWidth);
  #ifdef STEREO
  di.col = float3(0.7);
  #else
  di.col = float3(0.7,0,0);
  #endif
  di.a = fillGlow(di.d,6.*d) * 0.7;
  di.specPower = 30.;
  return di;
}

float faceZ = faceRadius-rimThickness+0.0008;
DI faceColor( float3 pos, float dt ) {
  DI di = newDI();
  float3 c; float2 p; float d;
  c = float3(0,0,faceZ);
  p = pos.xy - c.xy;
  d = circleDist( p, c.z );
  di.col = FACE_COLOR;
  di.col -= tiles(p.xy*1.6+0.5) * 0.04;;
  di.d = d;
  di.a = fill(di.d,3.*dt) * MA;
  di.specPower = 5.;
  return di;
}

DI hourColor( float3 p, float d ) {
  return hourHand(p.xy, pow(d,0.7));
}

DI minuteColor( float3 p, float d ) {
  return minuteHand(p.xy, pow(d,0.7));
}

DI secondColor( float3 p, float d ) {
  return secondHand(p.xy, pow(d,0.7));
}

// #define TEST
#ifdef TEST
float test = 1;
#else
float test = 0;
#endif

RI wall( float3 ro, float3 rd) {
  RI ri = newRI();
  if(test == 1) return ri;
  vec4 pi;
  pi = pI(ro,rd,wallPlane);
  if( pi.w > 0. ) {
    ri.mid = WALL;
    ri.d = pi.w;
    ri.pos = pi.xyz;
    ri.nor = n(wallPlane.xyz);
    float n = notch(fract(pi.x*0.25),0.1, 0.1, 0.02);
    n *= notch(fract(pi.x*0.25),0.7, 0.7, 0.02);
    float w = l(fwidth(pi.x));
    n = mix(n,1.,SS(w*5.));
#ifdef REAL_WOOD
    float3 wc = texture(u_tex0, pi.yx*0.2).rgb;
    ri.col = wc * float3(0.5,0.4,0.99);
#else
    ri.col = (WALL_COLOR + wood(pi.xy*2.-2.85) * 0.07) * SMin(n,0.4);
#endif
    ri.specLevel = 0.;
  }
  return ri;
}

RI rim( float3 ro, float3 rd ) {
  RI ri = newRI();
  // if(test == 1) return ri;
  float td = torIntersect( ro - rimCenter, rd, rimTorus );
  if( td > 0. ) {
    ri.d = td;
    ri.pos = ro + rd*td;
    ri.nor = torNormal(ri.pos, rimTorus);
    ri.mid = RIM;
    ri.col = RIM_COLOR;
    ri.specPower = 4.5;
    ri.specLevel = 3.;
  }
  return ri;
}

RI map( float3 ro, float3 rd ) {
  return minRI( wall(ro, rd), rim(ro, rd) );
}

float shadow( float3 pos, float3 nor, int mid, float d ) {
  // return 1.;
  float3 ro = pos + 0.005 * nor;
  float3 rd = n(lightPos - pos);
  RI sec = newRI();
  sec.d = inf;
  vec4 pi;
  float s = 1.;
  float ma = 0.;
  DI di;

  #ifdef HIQ
  if( mid == WALL ) sec = map(ro, rd);

  if( ma < 1. && pos.z < -facePlane.w ) {
    pi = pI(ro, rd, facePlane);
    if( pi.w > 0. && pi.w < sec.d ) {
      di = faceColor(pi.xyz, d);
      di.a *= 0.5;
      ma = max(ma,di.a);
    }
  }
  #endif

  #ifndef HIQ
  if( pos.z >= -facePlane.w ) {
  #endif
    if( ma < 1. && pos.z < -hourPlane.w ) {
      pi = pI(ro, rd, hourPlane);
      if( pi.w > 0. && pi.w < sec.d ) {
        di = hourColor(pi.xyz, d*3.);
        ma = max(ma,di.a);
      }
    }

    if( ma < 1. && pos.z < -minutePlane.w ) {
      pi = pI(ro, rd, minutePlane);
      if( pi.w > 0. && pi.w < sec.d ) {
        di = minuteColor(pi.xyz, d*3.);
        ma = max(ma,di.a);
      }
    }

    if( ma < 1. && pos.z < -secondPlane.w ) {
      pi = pI(ro, rd, secondPlane);
      if( pi.w > 0. && pi.w < sec.d ) {
        di = secondColor(pi.xyz, d*3.);
        ma = max(ma,di.a);
      }
    }

  #ifndef HIQ
  }
  #endif

  s = (1.-ma);
  if( sec.mid == RIM ) { s = 0.; }
  s = SMin(s,0.2);
  return s;
}

void light( float3 pos, float3 nor, float3 rd, float specPower, float specLevel, float sh, inout float3 col ) {
  float3 ol = lightPos - pos; float light = 1.;
  ol = n(ol);
  float dif = clamp( dot(nor,ol), 0.0, 1.0 );
  float amb = clamp( 0.5 + 0.5*nor.y, 0.5 + 0.5*nor.y, 1.0 );
  float3 hal = normalize(-rd+ol);
  col *= float3(0.15,0.25,0.35)*amb*ambientLevel + 1.05*float3(1.0,0.9,0.7)*dif*sh;
  float spec = pow(clamp(dot(hal,nor),0.0,1.0),30.0);
  // spec = pow(spec,8.);
  // spec = spec * spec;
  spec = pow(spec,specPower);
  float sl = (1.-length(col*(float3(0.3,0.5,1)))) * 0.3 * spec * specLevel * sh;
  // float sl = 0.3 * spec * specLevel * sh;
  // float sl = spec;
  col += sl;
}


float3 getRayColor( float3 ro, float3 rd ) {
  RI ri = map( ro, rd );

  vec4 pi;
  float3 pos;
  float bubbleHighlight = 0.;
  float sh = 1.;

  if( ri.mid != BACK ) {
    sh = shadow( ri.pos, ri.nor, ri.mid, ri.d );
    light( ri.pos, ri.nor, rd, ri.specPower, ri.specLevel, sh, ri.col );
  }

  #ifndef TEST

    pi = pI(ro, rd, facePlane);
    if( pi.w > 0. && pi.w < ri.d ) {
      ri.d = pi.w;
      pi.z = -facePlane.w;
      pos = pi.xyz;
      DI di = faceColor(pos, pi.w);
      sh = shadow( pi.xyz, facePlane.xyz, FACE, ri.d );
      light( pi.xyz, facePlane.xyz, rd, di.specPower, di.specLevel, sh, di.col );
      // if( di.a > 0.1 ) bubbleHighlight = 2.;
      bubbleHighlight = di.a * 2.;
      // if( l(pi.xy) < faceRadius - rimThickness ) bubbleHighlight = 2.;
      ri.col = mix(ri.col, di.col, di.a);
    }

    pi = pI(ro, rd,hourPlane);
    if( pi.w > 0. && pi.w < ri.d ) {
      ri.d = pi.w;
      pi.z = -hourPlane.w;
      pos = pi.xyz;
      DI di = hourColor(pos, pi.w);
      sh = shadow( pi.xyz, hourPlane.xyz, HOUR, ri.d );
      light( pi.xyz, hourPlane.xyz, rd, di.specPower, di.specLevel, sh, di.col );
      ri.col = mix(ri.col, di.col, di.a);
    }

    pi = pI(ro, rd,minutePlane);
    if( pi.w > 0. && pi.w < ri.d ) {
      ri.d = pi.w;
      pi.z = -minutePlane.w;
      pos = pi.xyz;
      DI di = minuteColor(pos, pi.w);
      sh = shadow( pi.xyz, minutePlane.xyz, MINUTE, ri.d );
      light( pi.xyz, minutePlane.xyz, rd, di.specPower, di.specLevel, sh, di.col );
      ri.col = mix(ri.col, di.col, di.a);
    }

    pi = pI(ro, rd,secondPlane);
    if( pi.w > 0. && pi.w < ri.d ) {
      ri.d = pi.w;
      pi.z = -secondPlane.w;
      pos = pi.xyz;
      DI di = secondColor(pos, pi.w);
      light( pi.xyz, secondPlane.xyz, rd, di.specPower, di.specLevel, 1., di.col );
      ri.col = mix(ri.col, di.col, di.a);
    }

    if( bubbleHighlight > 0. ) {
      float sd = sD(ro, rd, bubble); // check bubble intersection;
      if( sd > 0. ) {
        pos = ro + rd*sd;
        float3 nor = n(pos - bubble.xyz);
        float3 reflection = float3(0.2,0.18,0.18);
        light( pos, nor, rd, 30., 3.3333, 1., reflection );
        reflection += 0.02;
        reflection = pow(reflection,float3(15.));
        ri.col = 1.-((1. - ri.col) * (1. - reflection*0.8));
      }
    }

  #endif
  return ri.col;
}

float3 hash3( float n ) { return fract(sin(float3(n,n+1.0,n+2.0))*43758.5453123); }

float3 ff = float3(0,0,-1);
float3 up = float3(0,1,0);
mat3 projMatrix(float3 ff) {
  float3 uu = n(cross(ff,up));
  float3 vv = n(cross(uu,ff));
  mat3 m;
  m[0] = uu;
  m[1] = vv;
  m[2] = ff;
  return m;
}

float camPan, camAlt, camDepth;

// #define FREECAM
#define FLIPLIGHT

void animate() {
  t1 = t * 0.25;
  t2 = t * 0.5;
  t3 = t * 1.25;
  t4 = t * 1.5;
  s1 = sin(t1)*0.5+0.5;
  s2 = sin(t2)*0.5+0.5;
  s3 = sin(t3)*0.5+0.5;
  s4 = sin(t4)*0.5+0.5;
  cSpread = 0.05 * SCALE;
  // pR(lightPos.xy, t1*1.55);

  float st = fract(u_date.w);
  st = 1. - st;
  st *= st;st *= st;st *= st;
  sAngle = st*sin(sin(t*40.)) * 0.01 + sAngle * k2PI / 60.;

  #ifdef FREECAM
  camPan = (m.x-0.5) * 2.;
  camDepth = cos(asin(camPan));
  cameraDistance = (7.-m.y*6.9);
  camAlt = 0.;
  #else
  float ca = t*0.125 + m.x*2.*k2PI;
  float sca = sin(ca), psca = sca*0.5+0.5;
  cameraDistance = sin(ca*0.5-khPI)*3.5 + 3.035;
  camPan = sca;
  camDepth = SS(abs(cos(ca)));
  camAlt = sin(ca*3) * 0.13;
  #endif


}

void mainImage( out vec4 fragColor, in float2 fragCoord ) {
  animate();
  float2 q = fragCoord.xy / iResolution.xy;
  float2 p = (2.0*fragCoord.xy-iResolution.xy)/iResolution.y;

  float minD = min(iResolution.x, iResolution.y);
  // cameraDistance = 7.-m.y*6.9;
  lineWidth = (0.0013*SCALE*(600./minD));

  float3 ro = n(float3(camPan,camAlt,camDepth));
  float3 target = float3(0,0,-wallPlane.w);
  ff = n(target - ro);
  pm = projMatrix(ff);
  ro -= pm[2]*cameraDistance;
  float le = 1.5;

  float2 uv = 2.*(fragCoord-iResolution*0.5) / minD * SCALE;
  float3 rd, col=v3;

  lightPos = ro;

  lightPos += pm[0]*-0.25* cameraDistance+0.1;
  lightPos += pm[1]*1.* cameraDistance+0.1;
  lightPos += pm[2]*-2.* cameraDistance+0.1;
  lightPos.z += 0.2;

  #ifdef FLIPLIGHT
  lightPos.x = -lightPos.x;
  #endif

  #ifdef STEREO
  float focalDistance = 2.0;
  float spread = 0.015;
  target = ro + pm[2] * focalDistance;
  float3 rol = ro + pm[0] * spread;
  float3 ror = ro + pm[0] * -spread;

  ff = n(target - rol);
  pm = projMatrix(ff);
  rd = normalize( float3(uv,le) * pm );
  col += getRayColor( rol, rd ) * float3(1,0,0);
  ff = n(target - ror);
  pm = projMatrix(ff);
  rd = normalize( float3(uv,le) * pm );
  col += getRayColor( ror, rd ) * float3(0,1.,1);
  col *= 0.5;
  #else
  float2 os = float2(0.5,0.);
  uv = 2.*(fragCoord-iResolution*0.5) / minD * SCALE;
  rd = normalize( float3(uv,le) * pm );
  col += getRayColor( ro, rd );
  uv = 2.*(fragCoord+os.xy-iResolution*0.5) / minD * SCALE;
  rd = normalize( float3(uv,le) * pm );
  col += getRayColor( ro, rd );
  uv = 2.*(fragCoord+os.yx-iResolution*0.5) / minD * SCALE;
  rd = normalize( float3(uv,le) * pm );
  col += getRayColor( ro, rd );
  uv = 2.*(fragCoord+os.xx-iResolution*0.5) / minD * SCALE;
  rd = normalize( float3(uv,le) * pm );
  col += getRayColor( ro, rd );
  col *= 0.25;
  #endif

  // gama
  // col = pow( col, float3(0.44,0.44,0.44) );
  col = pow( col, float3(0.9) );

  // col += 0.2; // brightness
  col = mix( col, smoothstep( 0.0, 1.0, col ), 0.5 ); // contrast

  // saturate
  col = mix( col, float3(dot(col,float3(0.333))), -0.2 );

  // vigneting
  col *= 0.2 + 0.8*pow(16.0*q.x*q.y*(1.0-q.x)*(1.0-q.y),0.2);

  // dithering
  col += (1.0/255.0)*hash3(q.x+13.3214*q.y);

  // col = float3(length(col)); // grayscale
  // col = smoothstep(0.,1.,col);
  fragColor = vec4(col,1);
}

out vec4 FragColor;

void main() {
  mainImage(FragColor, gl_FragCoord.xy);
  // if( gl_FragCoord.y < 10. ) { gl_FragColor=vec4(pal(gl_FragCoord.x/u_resolution.x),1.); }
}

fragment float4 fragmentShader0(VertexOut vout [[stage_in]],
                               constant float2& u_resolution [[buffer(0)]],
                               constant uint& u_frame [[buffer(1)]],
                               constant float& u_time [[buffer(2)]],
                               constant uint& u_pass [[buffer(3)]],
                               texture2d<float> buffer0 [[texture(0)]],
                               texture2d<float> buffer1 [[texture(1)]],
                               texture2d<float> buffer2 [[texture(2)]],
                               texture2d<float> buffer3 [[texture(3)]]
                               ) {

    return float4(1,1,0,1));
}
