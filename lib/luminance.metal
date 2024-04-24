#ifndef MT_LUMINANCE
#define MT_LUMINANCE

// luminance is calculated by the RGB components
// need to cite reference where I got the weights - there are others
float luminance(float3 v) { return dot(v, float3(0.2126, 0.7152, 0.0722)); }

#endif