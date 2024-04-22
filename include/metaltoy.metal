#ifndef MT_METALTOY
#define MT_METALTOY

// this must be defined in every shader
struct SysUniforms { // DO NOT CHANGE
    float2 resolution;
    uint frame;
    float time;
    uint pass;
};

#endif