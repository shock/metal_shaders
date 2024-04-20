#include "./math.metal"
#include "./defs.metal"

#ifndef CAM_UP
#define CAM_UP float3(0,1,0)
#endif

float3x3 getCameraMatrix(float ya, float xa) {
  float3 ff = float3(0,0,-1);
  float3 vv = CAM_UP;
  ff.yz = V2R(ff.yz,xa);
  ff.xz = V2R(ff.xz,ya);
  vv.yz = V2R(vv.yz,xa);
  vv.xz = V2R(vv.xz,ya);
  float3 uu = cross(ff,vv);
  return float3x3(uu,vv,ff);
}

float3 getCameraPosition( float3x3 cameraMatrix, float3 lookAt, float distanceScale,
  float distance, float2 pan, float pan_sc ) {
  float3 cp = -cameraMatrix[2] * (1.-distance) * distanceScale + lookAt;
  cp += cameraMatrix[0] * pan.x * pan_sc * distanceScale;
  cp += cameraMatrix[1] * pan.y * pan_sc * distanceScale;
  return cp;
}

float3 getRayDirection( float3x3 cameraMatrix, float2 ndc, float skew ) {
  return normalize(cameraMatrix * float3(ndc,skew));
}