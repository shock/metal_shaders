// adapted from IQ's boxIntersection
vec4 roomIntersection( vec3 ro, vec3 rd, vec3 boxSize )
{
    // don't divide by zero
    if( rd.x == 0. ) rd.x = 0.0001;
    else if( rd.y == 0. ) rd.y = 0.0001;
    else if( rd.z == 0. ) rd.z = 0.0001;
    vec3 m = 1.0/rd;
    vec3 n = m*ro;
    vec3 k = abs(m)*boxSize;
    vec3 t1 = -n - k;
    vec3 t2 = -n + k;
    float tN = max( max( t1.x, t1.y ), t1.z );
    float tF = min( min( t2.x, t2.y ), t2.z );
    if( tN>tF || tF<0.0) return vec4(-1.0); // no intersection
    if( t2.x == t2.z ) t2.x += 0.0001; // avoid dual normal at edges
    else if( t2.x == t2.y ) t2.x += 0.0001; // avoid dual normal at edges
    else if( t2.z == t2.y ) t2.z += 0.0001; // avoid dual normal at edges
    vec3 normal = -sign(rd)*step(-t2.yzx,-t2.xyz)*step(-t2.zxy,-t2.xyz);
    return vec4(tF, normal);
}

vec2 uvForNormal( vec3 pos, vec3 nor ) {
  vec3 wallMask = 1. - abs(nor);
  if( wallMask.x < 0.5 ) return pos.zy * vec2(-nor.x,1);
  if( wallMask.y < 0.5 ) return pos.xz;
  return pos.xy * vec2(nor.z,1.);
}
