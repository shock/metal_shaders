#ifndef GLSL_DEFS
#define GLSL_DEFS

// rotate float2 p by a
#define V2R(p,a) (cos(a)*p+sin(a)*float2(p.y,-p.x))

#endif