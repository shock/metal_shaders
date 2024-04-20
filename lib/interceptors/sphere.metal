// returns distance to sphere if intersected, -1 otherwise
// sphere.xyz is center of sphere, sphere.w is radius
float sphereIntersection( float3 ro, float3 rd, float4 sphere )
{
	float3 oc=ro-sphere.xyz;
	float b=dot(oc,rd), c=dot(oc,oc)-sphere.w*sphere.w, h=b*b-c;
	if(h<0.0) return -1.0;
	return -b-sqrt(h);             // near only
	// h = sqrt( h );
	// return float2( -b-h, -b+h );  // near and far
}
