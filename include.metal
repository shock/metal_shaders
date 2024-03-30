//
// File: include.metal
//

// #define NO

#ifndef NO


// float4 SS( float4 in ) {
//   return smoothstep(0.,1.,in);
// }

#define SS(in) smoothstep(0.,1.,in)
#endif

#include "../shaders/lib/funcs.metal"
