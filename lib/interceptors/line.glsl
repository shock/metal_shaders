// http://geomalgorithms.com/a07-_distance.html
// returns shortest distance between two lines and the distance from ro to the closest point on rd
// result.x = closest distance, result.y = distance from ro to closest point along rd
vec2 lineDistance(vec3 ro, vec3 rd, vec3 lo, vec3 ld) {
  float a = dot(rd,rd);
  float b = dot(rd,ld);
  float c = dot(ld,ld);
  vec3 w0 = ro-lo;
  float d = dot(rd,w0);
  float e = dot(ld,w0);
  float acb2 = a*c - b*b;
  if( acb2 == 0. ) return vec2(-1); // lines are parallel
  float s = (b*e - c*d)/acb2;
  float t = (a*e - b*d)/acb2;
  ro += rd*s;
  lo += ld*t;
  float l = length(ro-lo);
  return vec2(l,s);
}
