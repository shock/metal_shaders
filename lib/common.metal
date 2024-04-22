#ifndef MT_COMMON
#define MT_COMMON

// Common utlity function

float vmin(float2 v) { return min(v.x, v.y); }
float vmin(float3 v) { return min(vmin(v.xy), v.z); }
float vmin(float4 v) { return min(vmin(v.xyz), v.w); }

float vmax(float2 v) { return max(v.x, v.y); }
float vmax(float3 v) { return max(vmax(v.xy), v.z); }
float vmax(float4 v) { return max(vmax(v.xyz), v.w); }

#endif