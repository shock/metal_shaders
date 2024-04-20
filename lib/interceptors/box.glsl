// adapted from IQ's - returns near and far normals
// original at https://www.iquilezles.org/www/articles/intersectors/intersectors.htm
vec2 boxIntersection( vec3 ro, vec3 rd, vec3 boxSize, out vec3 nearNormal, out vec3 farNormal )
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
    if( t2.x == t2.z ) t2.x += 0.0001; // avoid dual normal at edges
    else if( t2.x == t2.y ) t2.x += 0.0001; // avoid dual normal at edges
    else if( t2.z == t2.y ) t2.z += 0.0001; // avoid dual normal at edges
    if( t1.x == t1.z ) t1.x += 0.0001; // avoid dual normal at edges
    else if( t1.x == t1.y ) t1.x += 0.0001; // avoid dual normal at edges
    else if( t1.z == t1.y ) t1.z += 0.0001; // avoid dual normal at edges
    nearNormal = -sign(rd)*step(t1.yzx,t1.xyz)*step(t1.zxy,t1.xyz);
    farNormal = -sign(rd)*step(-t2.yzx,-t2.xyz)*step(-t2.zxy,-t2.xyz);
    return vec2( tN, tF );
}
