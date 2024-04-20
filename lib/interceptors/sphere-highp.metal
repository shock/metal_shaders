float3 sphereIntersectHighP(float3 orig, float3 dir, float4 sph) {
  // Hearn and Baker equation 10-72 for when radius^2 << distance between origin and center
  // Also at https://www.cg.tuwien.ac.at/courses/EinfVisComp/Slides/SS16/EVC-11%20Ray-Tracing%20Slides.pdf
  // Assumes ray direction is normalized
  float3 oc = sph.xyz - orig;
  float b = dot(dir, oc);

  float3 l = oc - b * dir; // l is midpoint on secant line, if sphere center is origin
  float h = sph.w * sph.w - dot(l, l);
  if( h < 0 ) return float3(h);
  h = sqrt(h);
  return float3(b - h, b + h, h);
}
