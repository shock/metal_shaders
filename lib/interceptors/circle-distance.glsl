// Clost point on circle with origin c in plane with normal n to point p
// https://www.geometrictools.com/Documentation/DistanceToCircle3.pdf
vec3 closestCirclePoint( vec3 p, vec3 c, vec3 n, float r ) {
  vec3 dt = p - c;
  vec3 e = dt - dot(n,dt)*n;
  vec3 k = c + r * e / length(e);
  return k;
}
