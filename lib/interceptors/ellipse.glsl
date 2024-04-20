// ellipsoid centered at the origin with radii ra
vec2 eliIntersect( in vec3 ro, in vec3 rd, in vec3 ra )
{
    vec3 ocn = ro/ra;
    vec3 rdn = rd/ra;
    float a = dot( rdn, rdn );
    float b = dot( ocn, rdn );
    float c = dot( ocn, ocn );
    float h = b*b - a*(c-1.0);
    if( h<0.0 ) return vec2(-1.0); //no intersection
    h = sqrt(h);
    return vec2(-b-h,-b+h)/a;
}

vec3 eliNormal( in vec3 pos, in vec3 ra )
{
    return normalize( pos/ra );
}
