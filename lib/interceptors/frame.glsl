// TODO make into double box : inner / outter

vec4 frameIntersect( vec3 ro, vec3 rd, vec4 frame, out vec3 outNormal, out vec3 farNormal )
{
  if( rd.x == 0. ) rd.x = 0.0001;
  else if( rd.y == 0. ) rd.y = 0.0001;
  else if( rd.z == 0. ) rd.z = 0.0001;
    float th = frame.w;
    vec3 innerBox = frame.xyz; innerBox.xy -= th;
    vec3 m = 1.0/rd; // can precompute if traversing a set of aligned boxes
    vec3 n = m*ro;   // can precompute if traversing a set of aligned boxes
    vec3 k = abs(m)*frame.xyz;
    vec3 t1 = -n - k;
    vec3 t2 = -n + k;
    float tN = max( max( t1.x, t1.y ), t1.z );
    float tF = min( min( t2.x, t2.y ), t2.z );
    if( tN>tF || tF < 0.0 ) return vec4(-1); // no intersection
    k = abs(m)*innerBox;
    vec3 ti1 = -n - k;
    vec3 ti2 = -n + k;
    float tiN = max( max (ti1.x, ti1.y), ti1.z );
    float tiF = min( min( ti2.x, ti2.y ), ti2.z );

    vec3 pos = abs(ro+tN*rd);
    pos.xy -= innerBox.xy;
    pos.xy = max( pos.xy, pos.yx );
    if( min(pos.x,pos.y) >= 0.0 && vmax(step(innerBox,abs(ro))) > 0.0 ) {
      // ray intersects outside edges of frame
      outNormal = -sign(rd)*step(t1.yzx,t1.xyz)*step(t1.zxy,t1.xyz);
      if( tiN > 0. && !(tiN>tiF || tiF < 0.0) ) {
        farNormal = -sign(rd)*step(ti1.yzx,ti1.xyz)*step(ti1.zxy,ti1.xyz);
      } else {
        tiN = tF;
        farNormal = -sign(rd)*step(-t2.yzx,-t2.xyz)*step(-t2.zxy,-t2.xyz);
      }
      return vec4(tN,tiN,tN,tF);
    } else {
      // ray intersects inside of inner frame front
      if( tiF == ti2.z ) {
        // ray exits through inner frame rear
        return vec4(tN,-1.,tN,tF);
      }
      // if( ti2.x == ti2.z ) ti2.x += 0.0001; // avoid dual normal at edges
      // else if( ti2.x == ti2.y ) ti2.x += 0.0001; // avoid dual normal at edges
      // else if( ti2.z == ti2.y ) ti2.z += 0.0001; // avoid dual normal at edges
        farNormal = -sign(rd)*step(-t2.yzx,-t2.xyz)*step(-t2.zxy,-t2.xyz);
      outNormal = -sign(rd)*step(-ti2.yzx,-ti2.xyz)*step(-ti2.zxy,-ti2.xyz);
      // ray hits inside edge of frame
      return vec4(tiF,tF,tN,tF);
    }

}
