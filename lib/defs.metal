#ifndef MT_DEFS
#define MT_DEFS

// rotate float2 p by a
#define V2R(p,a) (cos(a)*p+sin(a)*float2(p.y,-p.x))
#define pR(p,a) V2R(p,a)

#endif