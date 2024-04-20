#ifndef GLSL_MATH
#define GLSL_MATH

#define kPI 3.14159265
#define khPI 1.57079633
#define k3qPI 4.71238898
#define k2PI 6.2831853072
#define kPIi (1./kPI)
#define k2PIi (1./k2PI)

float3 round( float3 p ) {
  return floor(floor(p * 2. + 1.)*0.5);
}

float2 round( float2 p ) {
  return floor(floor(p * 2. + 1.)*0.5);
}

#endif