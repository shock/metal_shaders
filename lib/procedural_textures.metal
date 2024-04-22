#ifndef GLGL_PROC_TEX
#define GLGL_PROC_TEX
#include "./defs.metal"
#include "./random.metal"

// better XY plotter, takes slope into account a general sense, but not suited for any curve
//
float plotXY( float2 pos, float y ) {
  float w = 0.1; // line width without slope adjustment
  float dx = abs(dfdx(y));
  // float dy = abs(dfdx(pos.y));
  float l = abs(pos.y - y);
  l -= dx * 0.999; // tweak constant - line width with slope adjustment
  // l -= 0.1; // min line width no matter distance...
  float fw = length(float2(dfdx(l), dfdy(l)));
  fw = fwidth(l);
  // fw = max(0.1, fw); // uncomment and see
  float ss = smoothstep(w-fw, w+fw, l);
  return 1. - ss;
}

// Procedural Textures

// IQ's box-filtered checkers
float chex(float2 uv)
{
  float2 w = fwidth(uv) + 0.01;
  float2 i = 2.0*(abs(fract((uv-0.5*w)*0.5)-0.5)-abs(fract((uv+0.5*w)*0.5)-0.5))/w;
  return 0.5 - 0.5*i.x*i.y;
}

// my circles, somewhat anti-aliased
float circles( float2 uv ) {
  float2 st = fract(uv)*2.-1.;
  float r = length(st);
  float2 wv = fwidth(uv);
  float w = max(wv.x,wv.y);
  return clamp ((1.+w/2.-r)/w,0.,1.);
}

// IQ's filtered grid textures
float filteredGrid( float2 p )
{
    const float N = 10.0;
    float2 w = fwidth(p);
    float2 a = p + 0.5*w;
    float2 b = p - 0.5*w;
    float2 i = (floor(a)+min(fract(a)*N,1.0)-
              floor(b)-min(fract(b)*N,1.0))/(N*w);
    return (1.0-i.x)*(1.0-i.y);
}

float filteredSquares( float2 p )
{
    const float N = 3.0;
    float2 w = fwidth(p)+0.;
    float2 a = p + 0.5*w;
    float2 b = p - 0.5*w;
    float2 i = (floor(a)+min(fract(a)*N,1.0)-
              floor(b)-min(fract(b)*N,1.0))/(N*w);
    // return 1-i.x*i.y;
    return 1.0-i.x-i.y+2.0*i.x*i.y;
}

float filteredXor( float2 p, int k )
{
    float _xor = 0.0;
    p *= pow(2.,float(k));
    for( int i=0; i<k; i++ )
    {
        float2 w = fwidth(p);
        float2 f = 2.0*(abs(fract((p-0.5*w)/2.0)-0.5)-
		              abs(fract((p+0.5*w)/2.0)-0.5))/w;
        _xor += 0.5 - 0.5*f.x*f.y;

        p    *= 0.5;
        _xor  *= 0.5;
    }
    return _xor;
}

// nice combo of filteredXor
float3 colorGrid( float2 uv ) {
  int k = 6;
  float r = filteredXor( uv, k );
  float g = filteredXor( uv * 2., k );
  float b = filteredXor( uv * 4., k );
  float3 color = r * float3(1.0,0.665,0.669) +
          g * float3(0.633,1.0,0.48) +
          b * float3(0.845,0.836,1.0);
  color *= 0.3333;
  return color;
}

// my grid, w is line width
float grid(float2 uv, float w){
  float2 fuv = fract(uv+0.5);
  float2 fw = fwidth(uv);
  float2 afw = float2(length(float2(dfdx(fuv.x), dfdy(fuv.x))),length(float2(dfdx(fuv.y), dfdy(fuv.y))));
  fuv = smoothstep(0.5-w-afw, 0.5-w+afw, fuv)-smoothstep(0.5+w-afw, 0.5+w+afw, fuv);
  fuv = mix(fuv,float2(sqrt(w*0.5)),clamp((fw),0.,1.));
  fuv = fuv * fuv;
  float g = max(fuv.x, fuv.y);
  return g;
}

float tiles( float2 uv ) {
  float2 w = fwidth(uv) + 0.1;
  float2 i = 2.0 * ( length( fract((uv-0.5*w)*0.5) - 0.5 ) - length(fract((uv+0.5*w)*0.5)-0.5) ) / w;
  float r = length((fract(i*0.5) - 0.5)*2.9);
  r = length(i); r = 1. - r; r = clamp(r, 0., 1.); r = mix( r, 0.28, min(length(fwidth(uv)),0.9));
  return r;
}


float waves( float2 uv ) {
  float2 w = fwidth(uv);
  float2 x0 = uv - w*0.5;
  float2 x1 = x0 + w;
#define iif(x) (x - cos(x))
  float2 f = (iif(x1) - iif(x0))/w;
#undef iif
  return (f.x + f.y)*0.25;
}

float weaves( float2 uv ) {
  float2 w = fwidth(uv);
  float2 x0 = uv - w*0.5;
  float2 x1 = x0 + w;
#define iif(x) (x - cos(x))
  float2 f = (iif(x1) - iif(x0))/w;
#undef iif
  return 0.25*f.x*f.y;
}

float dots_orig(float2 uv) {
	return mix(1.-length(fract(uv)*2.-1.),0.25,min(length(fwidth(uv)),1.));
}

float granite(float2 uv) {
  uv = floor(uv*90.)/90.;
  float2 w2 = fwidth(uv);
  float w = max(w2.x, w2.y) * 16.;
  float g = random2Df(uv*41.126);
  g = mix(g,0.39,clamp(w,0.,1.));
  return g;
}

float noiseTexMono(float2 uv) {
  float2 w2; float w, g;
  float2 uvi = floor(uv);
  // float2 uvf = fract(uv);
  g = random2Df(uvi*41.126);
  w2 = fwidth(uv);
  w = max(w2.x, w2.y);
  g = mix(g,0.5,clamp(w,0.,1.));

  return g;
}

float noiseTexMono(float3 uvw) {
  float3 w2; float w, g;
  float3 uvwi = floor(uvw);
  // float3 uvwf = fract(uvw);
  g = random3Df(uvwi*41.126);
  w2 = fwidth(uvw);
  w = max(max(w2.x, w2.y), w2.z);
  g = mix(g,0.5,clamp(w,0.,1.));

  return g;
}

float3 noiseTexColor(float2 uv) {
  // float2 w2; float w;
  float2 uvi = floor(uv);
  float r = random2Df(uvi*41.126);
  float g = random2Df(uvi*28.284);
  float b = random2Df(uvi*13.947);
  return float3(r,g,b);
}

float3 noiseTexColor(float3 uvw) {
  // float3 w2; float w;
  float3 uvwi = floor(uvw);
  return float3(random3Df(uvwi*41.126),random3Df(uvwi*28.284),random3Df(uvwi*13.947));
}

#ifndef KSTEP
#define KSTEP
float __kStep( float t, float w ) {
  t = t*2.-1.; float s = sign(t); t = pow(abs(t),w); return t*s*0.5+0.5;
}

float2 __kStep( float2 t, float w ) {
  t = t*2.-1.; float2 s = sign(t); t = pow(abs(t),float2(w)); return t*s*0.5+0.5;
}
#endif

// same as above but interpolated.  w = 1 is linear interpolation, w=0.00001 is almost step at 0.5
// this is probably super slow
float3 noiseTexColori( float3 uvw, float w ) {
  float3 uvwi = floor(uvw);
  float3 uvwf = fract(uvw);
  float2 oo = float2(0,1);
  float2 txy;
  float3 a, b, c, d, q;

  // Four corners 2D of a quad XZ plane, Z+0
  q = uvwi + oo.xxx;
  a = float3(random3Df(q*41.126),random3Df(q*28.284),random3Df(q*13.947));;
  q = uvwi + oo.yxx;
  b = float3(random3Df(q*41.126),random3Df(q*28.284),random3Df(q*13.947));;
  q = uvwi + oo.xyx;
  c = float3(random3Df(q*41.126),random3Df(q*28.284),random3Df(q*13.947));;
  q = uvwi + oo.yyx;
  d = float3(random3Df(q*41.126),random3Df(q*28.284),random3Df(q*13.947));;

  // txy = smoothstep(0.,1.,uvwf.xy);
  txy = __kStep(uvwf.xy,w);

  // interpolate
  float3 z0 = mix(a, b, txy.x) +
          (c - a)* txy.y * (1.0 - txy.x) +
          (d - b) * txy.x * txy.y;

  // Four corners 2D of a quad XZ plane, Z+1
  q = uvwi + oo.xxy;
  a = float3(random3Df(q*41.126),random3Df(q*28.284),random3Df(q*13.947));;
  q = uvwi + oo.yxy;
  b = float3(random3Df(q*41.126),random3Df(q*28.284),random3Df(q*13.947));;
  q = uvwi + oo.xyy;
  c = float3(random3Df(q*41.126),random3Df(q*28.284),random3Df(q*13.947));;
  q = uvwi + oo.yyy;
  d = float3(random3Df(q*41.126),random3Df(q*28.284),random3Df(q*13.947));;

  float3 z1 = mix(a, b, txy.x) +
          (c - a)* txy.y * (1.0 - txy.x) +
          (d - b) * txy.x * txy.y;

  // float tz = smoothstep(0.,1.,uvwf.z);
  float tz = __kStep(uvwf.z,w);

  return mix(z0, z1, tz);
}

float noiseTexMonoi( float3 uvw, float w ) {
  float3 uvwi = floor(uvw);
  float3 uvwf = fract(uvw);
  float2 oo = float2(0,1);
  float2 txy;
  float a, b, c, d;
  float3 q;

  // Four corners 2D of a quad XZ plane, Z+0
  q = uvwi + oo.xxx;
  a = random3Df(q*41.126);
  q = uvwi + oo.yxx;
  b = random3Df(q*41.126);
  q = uvwi + oo.xyx;
  c = random3Df(q*41.126);
  q = uvwi + oo.yyx;
  d = random3Df(q*41.126);

  // txy = smoothstep(0.,1.,uvwf.xy);
  txy = __kStep(uvwf.xy,w);

  // interpolate
  float z0 = mix(a, b, txy.x) +
          (c - a)* txy.y * (1.0 - txy.x) +
          (d - b) * txy.x * txy.y;

  // Four corners 2D of a quad XZ plane, Z+1
  q = uvwi + oo.xxy;
  a = random3Df(q*41.126);
  q = uvwi + oo.yxy;
  b = random3Df(q*41.126);
  q = uvwi + oo.xyy;
  c = random3Df(q*41.126);
  q = uvwi + oo.yyy;
  d = random3Df(q*41.126);

  float z1 = mix(a, b, txy.x) +
          (c - a)* txy.y * (1.0 - txy.x) +
          (d - b) * txy.x * txy.y;

  // float tz = smoothstep(0.,1.,uvwf.z);
  float tz = __kStep(uvwf.z,w);

  return mix(z0, z1, tz);
}


/////////////////////////////////
// MULTI - FUNCTION TEXTURES

float sampleCircleCell( float2 uv, float r, float qsmpls, float cw ) {
  float2 st = floor(abs(fract(uv)*2.-1.)*qsmpls)*cw;
  float ri = dot(st,st);
  if( ri >= r ) return 0.;
  // if( TOG2 && vmax(st) < 0.5 ) return 0.;
  st += cw;
  float ro = dot(st,st);
  if( ro < r ) return 1.;
  // ri = sqrt(ri); ro = sqrt(ro);
  float n = ro-r;
  float d = ro-ri;
  d = d*d; n = n*n;
  return mix(1.,0.,n/d);
}

float sampleCircle( float2 uv, float r, float qsmpls ) {
  float k = 0.;
  // if( TOG2 ) k = 0.2;
  if( qsmpls == 1.0 ) return kPI * 0.25 * r - k;
  float wsamps = qsmpls*2.;
  float cw = 1./wsamps;
  float2 c = (floor((uv - cw*0.5)*wsamps) + 0.5)*cw;
  float2 os = float2(cw,0);
  float2 t = (uv - c)*wsamps;
  float is = 1./qsmpls;
  float y0 = mix(sampleCircleCell(c+os.yy, r, qsmpls, is), sampleCircleCell(c+os.xy, r, qsmpls, is), t.x);
  float y1 = mix(sampleCircleCell(c+os.yx, r, qsmpls, is), sampleCircleCell(c+os.xx, r, qsmpls, is), t.x);
  return mix(y0,y1,t.y);
}

float filteredCircle( float2 uv, float r ) {
  float lod = max(0.,-log2((length(fwidth(uv)))));
  float lodf = floor(lod);
  float flod = fract(lod);
  return mix(sampleCircle( uv, r, exp2(lodf) ),sampleCircle( uv, r, exp2(lodf+1.) ),smoothstep(0.,1.,flod*flod));
}

// #define ix( x ) (x - x*x*x*x*x*0.2)
// #define ix( x ) (x - (2/3)*pow(x,3/2))
// #define ix( x ) (-cos(x*kPI)/kPI)
#define ix(x) (2./kPI*sin(x*khPI))


float sampleRadialCell( float2 uv, float r, float qsmpls, float cw ) {
  float2 st = floor(abs(fract(uv)*2.-1.)*qsmpls)*cw;
  float ri = dot(st,st);
  if( ri >= r ) return 0.;
  st += cw;
  float ro = dot(st,st);
  ri = sqrt(ri); ro = sqrt(ro);
  return (ix(ro)-ix(ri))/(ro-ri);
}

float sampleRadial( float2 uv, float r, float qsmpls ) {
  if( qsmpls == 1.0 ) return ix(1.) - ix(0.) - (1. - kPI*0.25);
  float wsamps = qsmpls*2.;
  float cw = 1./wsamps;
  float2 c = (floor((uv - cw*0.5)*wsamps) + 0.5)*cw;
  float2 os = float2(cw,0);
  float2 t = (uv - c)*wsamps;
  float is = 1./qsmpls;
  // return sampleRadialCell(uv, r, exp2(1), 1/exp2(1));
  float y0 = mix(sampleRadialCell(c+os.yy, r, qsmpls, is), sampleRadialCell(c+os.xy, r, qsmpls, is), t.x);
  float y1 = mix(sampleRadialCell(c+os.yx, r, qsmpls, is), sampleRadialCell(c+os.xx, r, qsmpls, is), t.x);
  return mix(y0,y1,t.y);
}

float filteredRadial( float2 uv, float r ) {
  float lod = max(0.,-log2((length(fwidth(uv)))));
  float lodf = floor(lod);
  float flod = fract(lod);
  if( lodf > 1. ) return cos(khPI * min(1.,length(fract(uv)*2.-1.)));
  // return mix(ix(1) - ix(0) - (1 - kPI*0.25), sin(kPI * min(1,length(fract(uv)*2-1))), flod);
  // return sampleRadial( uv, r, exp2(1) );
  return mix(sampleRadial( uv, r, exp2(lodf) ),sampleRadial( uv, r, exp2(lodf+1.) ),smoothstep(0.,1.,flod));
}


#endif