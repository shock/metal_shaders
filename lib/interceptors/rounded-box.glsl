// IQ's - https://www.iquilezles.org/www/articles/intersectors/intersectors.htm
// axis aligned box centered at the origin, with dimensions "size" and extruded by radious "rad"
float roundedboxIntersect( in vec3 ro, in vec3 rd, in vec3 size, in float rad )
{
    // bounding box
    vec3 m = 1.0/rd;
    vec3 n = m*ro;
    vec3 k = abs(m)*(size+rad);
    vec3 t1 = -n - k;
    vec3 t2 = -n + k;
    float tN = max( max( t1.x, t1.y ), t1.z );
    float tF = min( min( t2.x, t2.y ), t2.z );
    if( tN>tF || tF<0.0) return -1.0;
    float t = tN;

    // convert to first octant
    vec3 pos = ro+t*rd;
    vec3 s = sign(pos);
    ro  *= s;
    rd  *= s;
    pos *= s;

    // faces
    pos -= size;
    pos = max( pos.xyz, pos.yzx );
    if( min(min(pos.x,pos.y),pos.z) < 0.0 ) return t;

    // some precomputation
    vec3 oc = ro - size;
    vec3 dd = rd*rd;
    vec3 oo = oc*oc;
    vec3 od = oc*rd;
    float ra2 = rad*rad;

    t = 1e20;

    // corner
    {
    float b = od.x + od.y + od.z;
    float c = oo.x + oo.y + oo.z - ra2;
    float h = b*b - c;
    if( h>0.0 ) t = -b-sqrt(h);
    }
    // edge X
    {
    float a = dd.y + dd.z;
    float b = od.y + od.z;
    float c = oo.y + oo.z - ra2;
    float h = b*b - a*c;
    if( h>0.0 )
    {
        h = (-b-sqrt(h))/a;
        if( h>0.0 && h<t && abs(ro.x+rd.x*h)<size.x ) t = h;
    }
    }
    // edge Y
    {
    float a = dd.z + dd.x;
    float b = od.z + od.x;
    float c = oo.z + oo.x - ra2;
    float h = b*b - a*c;
    if( h>0.0 )
    {
        h = (-b-sqrt(h))/a;
        if( h>0.0 && h<t && abs(ro.y+rd.y*h)<size.y ) t = h;
    }
    }
    // edge Z
    {
    float a = dd.x + dd.y;
    float b = od.x + od.y;
    float c = oo.x + oo.y - ra2;
    float h = b*b - a*c;
    if( h>0.0 )
    {
        h = (-b-sqrt(h))/a;
        if( h>0.0 && h<t && abs(ro.z+rd.z*h)<size.z ) t = h;
    }
    }

    if( t>1e19 ) t=-1.0;

    return t;
}

// normal of a rounded box
vec3 roundedboxNormal( in vec3 pos, in vec3 siz )
{
    return sign(pos)*normalize(max(abs(pos)-siz,0.0));
}
