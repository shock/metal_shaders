// Modified from IQ's to do near and far intersections
// cylinder defined by extremes pa and pb, and radious ra
vec2 cylIntersect( in vec3 ro, in vec3 rd, in vec3 pa, in vec3 pb, float ra, bool doCaps, out vec3 nearNorm, out vec3 farNorm )
{
    vec3 ca = pb-pa;
    vec3 oc = ro-pa;
    vec3 ocb = ro-pb;
    float caca = dot(ca,ca);
    float card = dot(ca,rd);
    float caoc = dot(ca,oc);
    float a = caca - card*card;
    float b = caca*dot( oc, rd) - caoc*card;
    float c = caca*dot( oc, oc) - caoc*caoc - ra*ra*caca;
    float h = b*b - a*c;
    if( h<0.0 ) return vec2(-1.0); //no intersection
    float tN = -1, tF = -1.;
    h = sqrt(h);

    float t = (-b-h)/a;
    float y = caoc + t*card;
    if( y>0.0 && y<caca ) {
      // body near
      tN = t;
      nearNorm = normalize(oc+t*rd-ca*y/caca);
    } else if( doCaps ) {
      // cap near
      t = (((y<0.0)?0.0:caca) - caoc)/card;
      if( abs(b+a*t)<h ) {
        tN = t;
        nearNorm = ca*sign(y)/sqrt(caca);
      };
    }

    t = (-b+h)/a;
    y = caoc + t*card;
    if( y>0.0 && y<caca ) {
      // body far
      tF = t;
      farNorm = -normalize(oc+t*rd-ca*y/caca);
    } else if( doCaps ) {
      // cap far
      t = (((y<0.0)?0:caca) - caoc)/card;
      if( abs(b+a*t)<h ) {
        tF = t;
        farNorm = -ca*sign(y)/sqrt(caca);
      };
    }
    return vec2(tN,tF);
}
