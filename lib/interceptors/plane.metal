// IQ's https://www.iquilezles.org/www/articles/intersectors/intersectors.htm
float planeIntersect(float3 ro, float3 rd, float4 p) { return -(dot(ro,p.xyz)+p.w)/dot(rd,p.xyz); }
