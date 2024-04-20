// IQ's https://www.iquilezles.org/www/articles/intersectors/intersectors.htm
vec2 cylIntersect( in vec3 ro, in vec3 rd, in vec3 cb, in vec3 ca, float cr )
{
    vec3  oc = ro - cb;
    float card = dot(ca,rd);
    float caoc = dot(ca,oc);
    float a = (1.0 - card*card);
    float b = dot( oc, rd) - caoc*card;
    b = dot( oc, rd) - caoc*card;
    float c = dot( oc, oc) - caoc*caoc - cr*cr;
    float h = b*b - a*c;
    if( h<0.0 ) return vec2(h); //no intersection
    h = sqrt(h);
    return vec2(-b-h,-b+h)/a;
}

// IQ's https://www.iquilezles.org/www/articles/intersectors/intersectors.htm
vec2 boundsIntersect( vec3 ro, vec3 rd, vec3 boxSize )
{
  if( rd.x == 0. ) rd.x = 0.0001;
  else if( rd.y == 0. ) rd.y = 0.0001;
  else if( rd.z == 0. ) rd.z = 0.0001;
    vec3 m = 1.0/rd; // can precompute if traversing a set of aligned boxes
    vec3 n = m*ro;   // can precompute if traversing a set of aligned boxes
    vec3 k = abs(m)*boxSize;
    vec3 t1 = -n - k;
    vec3 t2 = -n + k;
    float tN = max( max( t1.x, t1.y ), t1.z );
    float tF = min( min( t2.x, t2.y ), t2.z );
    if( tN>tF || tF < 0.0) return vec2(-1.0); // no intersection
    return vec2( tN, tF );
}

vec2 surfaceUV;

float surfaceIntersect(vec3 ro, vec3 rd, out vec3 nor, vec4 surface) {
  float dz = surface.w;
  float r = surface.w+surface.z;
  float cellDim = sqrt(r*r - dz*dz)*2.;
  vec3 bdim = vec3(surface.xy,surface.z+0.1);
  vec2 bi = boundsIntersect(ro, rd, bdim);
  float nt = max(0.,bi.x), t = 0., ft = bi.y;
  if( ft < 0. ) return -1.;

  if( rd.x == 0. ) rd.x = 0.001; // don't divide by zero
  float sr = sign(rd.x);
  float dx = sr*cellDim/rd.x;
  float os = 0.;  // X offset of curve from origin
  ro.x -= os;
  vec3 pos = (ro + nt*rd);
  vec3 go = pos;
  float pd = planeIntersect(go, rd, vec4(0,0,1,0));
  if( pd < 0. ) pd = 1e10;  // avoid pricision sign swap
  float px = pos.x/cellDim;
  float gx = floor(px);
  float ax = mod(gx, 2.)*2.-1.;
  float nextT = (step(0,sr)-fract(px)) * dx * sr;
  for( int i=0; i<128; i++ ) {
    vec3 cb = vec3((gx + 0.5)*cellDim,0,dz*ax);
    vec2 ci = cylIntersect(go, rd, cb, vec3(0,1,0), r);
    float ss = ax * sign(pos.z);
    float inside = (step(length(pos.xz-cb.xz), r) * step(ss, 0))*-2.+1.;
    ss *= inside;
    float tt = ss > 0. ? ci.y : ci.x;
    if( (!(pd <= t && ss > 0.) || inside < 0.) &&
      (pd*ss*inside <= tt*ss*inside + 0.01 || ss < 0 || pd < 0.) &&
      tt < nextT + 0.01 &&
      tt + nt < ft - 0.01 &&
      tt >= 0. &&
      true
    ) {
      float arcLength = atan(cellDim/2.,dz)*r*2.;
      pos = go + tt*rd; pos.xz -= cb.xz;
      float relx = os;
      float relFloor = floor(relx/cellDim);
      float v = (gx+0.5) * arcLength;
      v += atan(pos.x,-ax*(pos.z))*r;
      relx = relx - relFloor*cellDim;
#ifdef FIXED_UV // offsets uv.x so that 0 is always at origin
      v += (relFloor + 0.5) * arcLength;
      v -= asin((cellDim-relx*2)/(r*2.))*r; // https://www.omnicalculator.com/math/arc-length
#else
      // continuous (fluid) offset so that uv.x=0 remains close to origin, but without the "swooping" that keeps it exact like in FIXED
      v += os/cellDim * arcLength;
#endif
      surfaceUV = vec2(v,pos.y);
      nor = -ss*(vec3(pos.xz,0).xzy)/r;
      return nt+tt;
    }
    t = nextT; if( t + nt > ft ) break;
    nextT += dx; pos = go + t*rd; gx += sr; ax *= -1.;
  }
  return -1.;
}
