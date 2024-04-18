#include <metal_stdlib>
#pragma clang diagnostic ignored "-Wparentheses-equality"
using namespace metal;
struct xlatMtlShaderInput {
  float4 gl_FragCoord [[position]];
};
struct xlatMtlShaderOutput {
  float4 gl_FragColor;
};
struct xlatMtlShaderUniform {
  float iTime;
  float2 iResolution;
  float2 iMouse;
};
fragment xlatMtlShaderOutput xlatMtlMain (xlatMtlShaderInput _mtl_i [[stage_in]], constant xlatMtlShaderUniform& _mtl_u [[buffer(0)]]
  ,   texture2d<float> iChannel0 [[texture(0)]], sampler _mtlsmp_iChannel0 [[sampler(0)]])
{
  xlatMtlShaderOutput _mtl_o;
float t_1 = 0;
float2 m_2 = 0;
  float3 col_3 = 0;
  float2 q_4 = 0;
  m_2 = ((_mtl_u.iMouse / _mtl_u.iResolution) * float2(1.0, -1.0));
  t_1 = (_mtl_u.iTime * 0.2);
  float2 tmpvar_5 = 0;
  tmpvar_5.x = cos((1.570796 * t_1));
  tmpvar_5.y = sin((1.570796 * t_1));
  float2 tmpvar_6 = 0;
  tmpvar_6.x = cos((t_1 * 3.141593));
  tmpvar_6.y = sin((t_1 * 3.141593));
  float2 tmpvar_7 = 0;
  float tmpvar_8 = 0;
  tmpvar_8 = (0.3926991 * _mtl_u.iTime);
  tmpvar_7.x = cos(tmpvar_8);
  tmpvar_7.y = sin(tmpvar_8);
  float4 tmpvar_9 = 0;
  tmpvar_9.w = 1.9;
  tmpvar_9.x = (5.5 * tmpvar_7.x);
  tmpvar_9.y = (5.5 * -(tmpvar_7.y));
  tmpvar_9.z = (4.0 * tmpvar_6.x);
  float4 tmpvar_10 = 0;
  tmpvar_10.w = 1.9;
  tmpvar_10.xy = -(tmpvar_9.xy);
  tmpvar_10.z = -((4.0 * tmpvar_6.x));
  q_4 = (_mtl_i.gl_FragCoord.xy / _mtl_u.iResolution);
  float md_11 = 0;
  float3 c_12 = 0;
  float3 rd_13 = 0;
  float3 tmpvar_14 = 0;
  tmpvar_14.z = -1.0;
  tmpvar_14.xy = (((_mtl_i.gl_FragCoord.xy -
    (0.5 * _mtl_u.iResolution)
  ) / _mtl_u.iResolution.y) * 2.0);
  float3 tmpvar_15 = 0;
  tmpvar_15 = normalize(tmpvar_14);
  rd_13.x = tmpvar_15.x;
  c_12 = float3(0.0, 0.0, 0.0);
  float2 p_16 = 0;
  p_16 = tmpvar_15.yz;
  float a_17 = 0;
  a_17 = (3.141593 * (m_2.y - 0.5));
  float2 tmpvar_18 = 0;
  tmpvar_18.x = p_16.y;
  tmpvar_18.y = -(tmpvar_15.y);
  p_16 = ((cos(a_17) * tmpvar_15.yz) + (sin(a_17) * tmpvar_18));
  rd_13.yz = p_16;
  float2 p_19 = 0;
  p_19 = rd_13.xy;
  float a_20 = 0;
  a_20 = (6.283185 * (m_2.x - 0.5));
  float2 tmpvar_21 = 0;
  tmpvar_21.x = p_19.y;
  tmpvar_21.y = -(tmpvar_15.x);
  p_19 = ((cos(a_20) * rd_13.xy) + (sin(a_20) * tmpvar_21));
  rd_13.xy = p_19;
  float3 pos_22 = 0;
  float3 vel_23 = 0;
  float3 tmpvar_24 = 0;
  tmpvar_24 = (tmpvar_9.xyz - float3(0.0, 7.2, 0.0));
  float3 tmpvar_25 = 0;
  tmpvar_25 = (tmpvar_10.xyz - float3(0.0, 7.2, 0.0));
  vel_23 = (rd_13 + ((
    normalize(tmpvar_24)
   /
    dot (tmpvar_24, tmpvar_24)
  ) + (
    normalize(tmpvar_25)
   /
    dot (tmpvar_25, tmpvar_25)
  )));
  pos_22 = (float3(0.0, 7.2, 0.0) + vel_23);
  float3 pos_26 = 0;
  float3 vel_27 = 0;
  float3 tmpvar_28 = 0;
  tmpvar_28 = (tmpvar_9.xyz - pos_22);
  float3 tmpvar_29 = 0;
  tmpvar_29 = (tmpvar_10.xyz - pos_22);
  vel_27 = (vel_23 + ((
    normalize(tmpvar_28)
   /
    dot (tmpvar_28, tmpvar_28)
  ) + (
    normalize(tmpvar_29)
   /
    dot (tmpvar_29, tmpvar_29)
  )));
  pos_26 = (pos_22 + vel_27);
  float3 pos_30 = 0;
  float3 vel_31 = 0;
  float3 tmpvar_32 = 0;
  tmpvar_32 = (tmpvar_9.xyz - pos_26);
  float3 tmpvar_33 = 0;
  tmpvar_33 = (tmpvar_10.xyz - pos_26);
  vel_31 = (vel_27 + ((
    normalize(tmpvar_32)
   /
    dot (tmpvar_32, tmpvar_32)
  ) + (
    normalize(tmpvar_33)
   /
    dot (tmpvar_33, tmpvar_33)
  )));
  pos_30 = (pos_26 + vel_31);
  float3 pos_34 = 0;
  float3 vel_35 = 0;
  float3 tmpvar_36 = 0;
  tmpvar_36 = (tmpvar_9.xyz - pos_30);
  float3 tmpvar_37 = 0;
  tmpvar_37 = (tmpvar_10.xyz - pos_30);
  vel_35 = (vel_31 + ((
    normalize(tmpvar_36)
   /
    dot (tmpvar_36, tmpvar_36)
  ) + (
    normalize(tmpvar_37)
   /
    dot (tmpvar_37, tmpvar_37)
  )));
  pos_34 = (pos_30 + vel_35);
  float3 pos_38 = 0;
  float3 vel_39 = 0;
  float3 tmpvar_40 = 0;
  tmpvar_40 = (tmpvar_9.xyz - pos_34);
  float3 tmpvar_41 = 0;
  tmpvar_41 = (tmpvar_10.xyz - pos_34);
  vel_39 = (vel_35 + ((
    normalize(tmpvar_40)
   /
    dot (tmpvar_40, tmpvar_40)
  ) + (
    normalize(tmpvar_41)
   /
    dot (tmpvar_41, tmpvar_41)
  )));
  pos_38 = (pos_34 + vel_39);
  float3 vel_42 = 0;
  float3 tmpvar_43 = 0;
  tmpvar_43 = (tmpvar_9.xyz - pos_38);
  float3 tmpvar_44 = 0;
  tmpvar_44 = (tmpvar_10.xyz - pos_38);
  vel_42 = (vel_39 + ((
    normalize(tmpvar_43)
   /
    dot (tmpvar_43, tmpvar_43)
  ) + (
    normalize(tmpvar_44)
   /
    dot (tmpvar_44, tmpvar_44)
  )));
  float3 tmpvar_45 = 0;
  tmpvar_45 = normalize(vel_42);
  float tmpvar_46 = 0;
  tmpvar_46 = (-3.9 / tmpvar_45.z);
  float4 tmpvar_47 = 0;
  tmpvar_47.xyz = (float3(0.0, 7.2, 0.0) + (tmpvar_45 * tmpvar_46));
  tmpvar_47.w = tmpvar_46;
  rd_13 = vel_42;
  float3 tmpvar_48 = 0;
  tmpvar_48 = normalize(vel_42);
  float tmpvar_49 = 0;
  tmpvar_49 = (-1.9 / dot (tmpvar_48, float3(0.0, 0.0, -1.0)));
  float4 tmpvar_50 = 0;
  tmpvar_50.xyz = (float3(0.0, 7.2, 0.0) + (tmpvar_48 * tmpvar_49));
  tmpvar_50.w = tmpvar_49;
  float3 tmpvar_51 = 0;
  tmpvar_51 = normalize(vel_42);
  float4 i_52 = 0;
  i_52 = float4(-1.0, -1.0, -1.0, -1.0);
  float tmpvar_53 = 0;
  float3 tmpvar_54 = 0;
  tmpvar_54 = (float3(0.0, 7.2, 0.0) - tmpvar_10.xyz);
  float tmpvar_55 = 0;
  tmpvar_55 = dot (tmpvar_54, tmpvar_51);
  float tmpvar_56 = 0;
  tmpvar_56 = ((tmpvar_55 * tmpvar_55) - (dot (tmpvar_54, tmpvar_54) - 3.61));
  if ((tmpvar_56 < 0.0)) {
    tmpvar_53 = -1.0;
  } else {
    tmpvar_53 = (-(tmpvar_55) - sqrt(tmpvar_56));
  };
  if ((tmpvar_53 > 0.0)) {
    i_52.xyz = (float3(0.0, 7.2, 0.0) + (tmpvar_51 * tmpvar_53));
    i_52.w = tmpvar_53;
  };
  float3 tmpvar_57 = 0;
  tmpvar_57 = normalize(vel_42);
  float4 i_58 = 0;
  i_58 = float4(-1.0, -1.0, -1.0, -1.0);
  float tmpvar_59 = 0;
  float3 tmpvar_60 = 0;
  tmpvar_60 = (float3(0.0, 7.2, 0.0) - tmpvar_9.xyz);
  float tmpvar_61 = 0;
  tmpvar_61 = dot (tmpvar_60, tmpvar_57);
  float tmpvar_62 = 0;
  tmpvar_62 = ((tmpvar_61 * tmpvar_61) - (dot (tmpvar_60, tmpvar_60) - 3.61));
  if ((tmpvar_62 < 0.0)) {
    tmpvar_59 = -1.0;
  } else {
    tmpvar_59 = (-(tmpvar_61) - sqrt(tmpvar_62));
  };
  if ((tmpvar_59 > 0.0)) {
    i_58.xyz = (float3(0.0, 7.2, 0.0) + (tmpvar_57 * tmpvar_59));
    i_58.w = tmpvar_59;
  };
  md_11 = 1e+10;
  if (((i_52.w > 0.0) && (i_52.w < 1e+10))) {
    md_11 = i_52.w;
    float4 so_63 = 0;
    float md_64 = 0;
    float3 c_65 = 0;
    float3 sc_66 = 0;
    float3 tmpvar_67 = 0;
    tmpvar_67 = normalize((i_52.xyz - tmpvar_10.xyz));
    float3 tmpvar_68 = 0;
    tmpvar_68 = normalize((i_52.xyz - float3(0.0, 7.2, 0.0)));
    sc_66 = float3((max (0.0, dot (
      normalize((float3(-0.0, -0.0, -3.9) - i_52.xyz))
    , tmpvar_67)) * 0.5));
    float3 tmpvar_69 = 0;
    tmpvar_69 = (tmpvar_68 - (2.0 * (
      dot (tmpvar_67, tmpvar_68)
     * tmpvar_67)));
    float tmpvar_70 = 0;
    tmpvar_70 = (-((i_52.z + 3.9)) / tmpvar_69.z);
    float4 tmpvar_71 = 0;
    tmpvar_71.xyz = (i_52.xyz + (tmpvar_69 * tmpvar_70));
    tmpvar_71.w = tmpvar_70;
    float tmpvar_72 = 0;
    tmpvar_72 = (-((
      dot (i_52.xyz, float3(0.0, 0.0, -1.0))
     + 1.9)) / dot (tmpvar_69, float3(0.0, 0.0, -1.0)));
    float4 tmpvar_73 = 0;
    tmpvar_73.xyz = (i_52.xyz + (tmpvar_69 * tmpvar_72));
    tmpvar_73.w = tmpvar_72;
    float4 pi_74 = 0;
    pi_74 = tmpvar_71;
    half3 tmpvar_75 = 0;
    float sl_76 = 0;
    half3 c_77 = 0;
    c_77 = half3(float3(0.0, 0.0, 0.0));
    if ((tmpvar_70 < 0.0)) {
      tmpvar_75 = half3(float3(0.0, 0.0, 0.0));
    } else {
      float2 tmpvar_78 = 0;
      tmpvar_78.x = t_1;
      tmpvar_78.y = tmpvar_5.y;
      half4 tmpvar_79 = 0;
      float2 P_80 = 0;
      P_80 = ((tmpvar_71.xy + (tmpvar_78 * float2(
        sign(tmpvar_71.z)
      ))) * 0.25);
      tmpvar_79 = half4(iChannel0.sample(_mtlsmp_iChannel0, (float2)(P_80)));
      c_77 = half3(dot (tmpvar_79.xyz, (half3)float3(0.333, 0.333, 0.333)));
      float3 tmpvar_81 = 0;
      tmpvar_81.z = 1.0;
      tmpvar_81.xy = tmpvar_71.xy;
      pi_74.w = normalize(tmpvar_81).z;
      float3 tmpvar_82 = 0;
      tmpvar_82 = abs((float3(0.5, 0.0, 0.5) + (0.5 *
        cos((15.0 * ((
          fract(-(pi_74.w))
         -
          (_mtl_u.iTime * 0.08)
        ) + float3(0.0, 0.33, 0.67))))
      )));
      c_77 = ((half3)((float3)(c_77) * tmpvar_82));
      float tmpvar_83 = 0;
      float3 tmpvar_84 = 0;
      tmpvar_84 = (tmpvar_71.xyz - tmpvar_9.xyz);
      float tmpvar_85 = 0;
      tmpvar_85 = dot (tmpvar_84, normalize((tmpvar_9.xyz - tmpvar_71.xyz)));
      float tmpvar_86 = 0;
      tmpvar_86 = ((tmpvar_85 * tmpvar_85) - (dot (tmpvar_84, tmpvar_84) - 3.61));
      if ((tmpvar_86 < 0.0)) {
        tmpvar_83 = -1.0;
      } else {
        tmpvar_83 = (-(tmpvar_85) - sqrt(tmpvar_86));
      };
      sl_76 = (1.0/(min ((tmpvar_83 * tmpvar_83), 10.0)));
      float tmpvar_87 = 0;
      float3 tmpvar_88 = 0;
      tmpvar_88 = (tmpvar_71.xyz - tmpvar_10.xyz);
      float tmpvar_89 = 0;
      tmpvar_89 = dot (tmpvar_88, normalize((tmpvar_10.xyz - tmpvar_71.xyz)));
      float tmpvar_90 = 0;
      tmpvar_90 = ((tmpvar_89 * tmpvar_89) - (dot (tmpvar_88, tmpvar_88) - 3.61));
      if ((tmpvar_90 < 0.0)) {
        tmpvar_87 = -1.0;
      } else {
        tmpvar_87 = (-(tmpvar_89) - sqrt(tmpvar_90));
      };
      c_77 = ((half3)((float3)(c_77) * (sl_76 + (1.0/(
        min ((tmpvar_87 * tmpvar_87), 10.0)
      )))));
      float3 tmpvar_91 = 0;
      tmpvar_91.z = 1.0;
      tmpvar_91.xy = pi_74.xy;
      float tmpvar_92 = 0;
      tmpvar_92 = pow (normalize(tmpvar_91).z, 16.0);
      c_77 = ((half3)((float3)(c_77) + tmpvar_92));
      tmpvar_75 = pow (c_77, (half3)float3(0.666, 0.666, 0.666));
    };
    c_65 = mix (sc_66, (float3)tmpvar_75, 0.5);
    float4 pi_93 = 0;
    pi_93 = tmpvar_73;
    half3 tmpvar_94 = 0;
    float sl_95 = 0;
    half3 c_96 = 0;
    c_96 = half3(float3(0.0, 0.0, 0.0));
    if ((tmpvar_72 < 0.0)) {
      tmpvar_94 = half3(float3(0.0, 0.0, 0.0));
    } else {
      float2 tmpvar_97 = 0;
      tmpvar_97.x = t_1;
      tmpvar_97.y = tmpvar_5.y;
      half4 tmpvar_98 = 0;
      float2 P_99 = 0;
      P_99 = ((tmpvar_73.xy + (tmpvar_97 * float2(
        sign(tmpvar_73.z)
      ))) * 0.25);
      tmpvar_98 = half4(iChannel0.sample(_mtlsmp_iChannel0, (float2)(P_99)));
      c_96 = half3(dot (tmpvar_98.xyz, (half3)float3(0.333, 0.333, 0.333)));
      float3 tmpvar_100 = 0;
      tmpvar_100.z = 1.0;
      tmpvar_100.xy = tmpvar_73.xy;
      pi_93.w = normalize(tmpvar_100).z;
      float3 tmpvar_101 = 0;
      tmpvar_101 = abs((float3(0.5, 0.0, 0.5) + (0.5 *
        cos((15.0 * ((
          fract(-(pi_93.w))
         -
          (_mtl_u.iTime * 0.08)
        ) + float3(0.0, 0.33, 0.67))))
      )));
      c_96 = ((half3)((float3)(c_96) * tmpvar_101));
      float tmpvar_102 = 0;
      float3 tmpvar_103 = 0;
      tmpvar_103 = (tmpvar_73.xyz - tmpvar_9.xyz);
      float tmpvar_104 = 0;
      tmpvar_104 = dot (tmpvar_103, normalize((tmpvar_9.xyz - tmpvar_73.xyz)));
      float tmpvar_105 = 0;
      tmpvar_105 = ((tmpvar_104 * tmpvar_104) - (dot (tmpvar_103, tmpvar_103) - 3.61));
      if ((tmpvar_105 < 0.0)) {
        tmpvar_102 = -1.0;
      } else {
        tmpvar_102 = (-(tmpvar_104) - sqrt(tmpvar_105));
      };
      sl_95 = (1.0/(min ((tmpvar_102 * tmpvar_102), 10.0)));
      float tmpvar_106 = 0;
      float3 tmpvar_107 = 0;
      tmpvar_107 = (tmpvar_73.xyz - tmpvar_10.xyz);
      float tmpvar_108 = 0;
      tmpvar_108 = dot (tmpvar_107, normalize((tmpvar_10.xyz - tmpvar_73.xyz)));
      float tmpvar_109 = 0;
      tmpvar_109 = ((tmpvar_108 * tmpvar_108) - (dot (tmpvar_107, tmpvar_107) - 3.61));
      if ((tmpvar_109 < 0.0)) {
        tmpvar_106 = -1.0;
      } else {
        tmpvar_106 = (-(tmpvar_108) - sqrt(tmpvar_109));
      };
      c_96 = ((half3)((float3)(c_96) * (sl_95 + (1.0/(
        min ((tmpvar_106 * tmpvar_106), 10.0)
      )))));
      tmpvar_94 = pow (c_96, (half3)float3(0.666, 0.666, 0.666));
    };
    float3 tmpvar_110 = 0;
    tmpvar_110 = mix (sc_66, (float3)tmpvar_94, 0.5);
    md_64 = tmpvar_71.w;
    if ((tmpvar_72 > tmpvar_70)) {
      c_65 = tmpvar_110;
      md_64 = tmpvar_73.w;
    };
    so_63 = tmpvar_9;
    if ((tmpvar_10.x == tmpvar_9.x)) {
      so_63 = tmpvar_10;
    };
    float3 tmpvar_111 = 0;
    tmpvar_111 = normalize(tmpvar_69);
    float4 i_112 = 0;
    i_112 = float4(-1.0, -1.0, -1.0, -1.0);
    float tmpvar_113 = 0;
    float3 tmpvar_114 = 0;
    tmpvar_114 = (i_52.xyz - so_63.xyz);
    float tmpvar_115 = 0;
    tmpvar_115 = dot (tmpvar_114, tmpvar_111);
    float tmpvar_116 = 0;
    tmpvar_116 = ((tmpvar_115 * tmpvar_115) - (dot (tmpvar_114, tmpvar_114) - (so_63.w * so_63.w)));
    if ((tmpvar_116 < 0.0)) {
      tmpvar_113 = -1.0;
    } else {
      tmpvar_113 = (-(tmpvar_115) - sqrt(tmpvar_116));
    };
    if ((tmpvar_113 > 0.0)) {
      i_112.xyz = (i_52.xyz + (tmpvar_111 * tmpvar_113));
      i_112.w = tmpvar_113;
    };
    if (((i_112.w > 0.0) && (i_112.w < md_64))) {
      float3 osc_117 = 0;
      float3 tmpvar_118 = 0;
      tmpvar_118 = normalize((i_112.xyz - so_63.xyz));
      float3 tmpvar_119 = 0;
      tmpvar_119 = normalize((i_112.xyz - i_52.xyz));
      osc_117 = float3((max (0.0, dot (
        normalize((float3(-0.0, -0.0, -3.9) - i_112.xyz))
      , tmpvar_118)) * 0.5));
      float3 tmpvar_120 = 0;
      tmpvar_120 = (tmpvar_119 - (2.0 * (
        dot (tmpvar_118, tmpvar_119)
       * tmpvar_118)));
      float tmpvar_121 = 0;
      tmpvar_121 = (-((i_112.z + 3.9)) / tmpvar_120.z);
      float4 tmpvar_122 = 0;
      tmpvar_122.xyz = (i_112.xyz + (tmpvar_120 * tmpvar_121));
      tmpvar_122.w = tmpvar_121;
      float tmpvar_123 = 0;
      tmpvar_123 = (-((
        dot (i_112.xyz, float3(0.0, 0.0, -1.0))
       + 1.9)) / dot (tmpvar_120, float3(0.0, 0.0, -1.0)));
      float4 tmpvar_124 = 0;
      tmpvar_124.xyz = (i_112.xyz + (tmpvar_120 * tmpvar_123));
      tmpvar_124.w = tmpvar_123;
      float4 pi_125 = 0;
      pi_125 = tmpvar_122;
      half3 tmpvar_126 = 0;
      float sl_127 = 0;
      half3 c_128 = 0;
      c_128 = half3(float3(0.0, 0.0, 0.0));
      if ((tmpvar_121 < 0.0)) {
        tmpvar_126 = half3(float3(0.0, 0.0, 0.0));
      } else {
        float2 tmpvar_129 = 0;
        tmpvar_129.x = t_1;
        tmpvar_129.y = tmpvar_5.y;
        half4 tmpvar_130 = 0;
        float2 P_131 = 0;
        P_131 = ((tmpvar_122.xy + (tmpvar_129 * float2(
          sign(tmpvar_122.z)
        ))) * 0.25);
        tmpvar_130 = half4(iChannel0.sample(_mtlsmp_iChannel0, (float2)(P_131)));
        c_128 = half3(dot (tmpvar_130.xyz, (half3)float3(0.333, 0.333, 0.333)));
        float3 tmpvar_132 = 0;
        tmpvar_132.z = 1.0;
        tmpvar_132.xy = tmpvar_122.xy;
        pi_125.w = normalize(tmpvar_132).z;
        float3 tmpvar_133 = 0;
        tmpvar_133 = abs((float3(0.5, 0.0, 0.5) + (0.5 *
          cos((15.0 * ((
            fract(-(pi_125.w))
           -
            (_mtl_u.iTime * 0.08)
          ) + float3(0.0, 0.33, 0.67))))
        )));
        c_128 = ((half3)((float3)(c_128) * tmpvar_133));
        float tmpvar_134 = 0;
        float3 tmpvar_135 = 0;
        tmpvar_135 = (tmpvar_122.xyz - tmpvar_9.xyz);
        float tmpvar_136 = 0;
        tmpvar_136 = dot (tmpvar_135, normalize((tmpvar_9.xyz - tmpvar_122.xyz)));
        float tmpvar_137 = 0;
        tmpvar_137 = ((tmpvar_136 * tmpvar_136) - (dot (tmpvar_135, tmpvar_135) - 3.61));
        if ((tmpvar_137 < 0.0)) {
          tmpvar_134 = -1.0;
        } else {
          tmpvar_134 = (-(tmpvar_136) - sqrt(tmpvar_137));
        };
        sl_127 = (1.0/(min ((tmpvar_134 * tmpvar_134), 10.0)));
        float tmpvar_138 = 0;
        float3 tmpvar_139 = 0;
        tmpvar_139 = (tmpvar_122.xyz - tmpvar_10.xyz);
        float tmpvar_140 = 0;
        tmpvar_140 = dot (tmpvar_139, normalize((tmpvar_10.xyz - tmpvar_122.xyz)));
        float tmpvar_141 = 0;
        tmpvar_141 = ((tmpvar_140 * tmpvar_140) - (dot (tmpvar_139, tmpvar_139) - 3.61));
        if ((tmpvar_141 < 0.0)) {
          tmpvar_138 = -1.0;
        } else {
          tmpvar_138 = (-(tmpvar_140) - sqrt(tmpvar_141));
        };
        c_128 = ((half3)((float3)(c_128) * (sl_127 + (1.0/(
          min ((tmpvar_138 * tmpvar_138), 10.0)
        )))));
        float3 tmpvar_142 = 0;
        tmpvar_142.z = 1.0;
        tmpvar_142.xy = pi_125.xy;
        float tmpvar_143 = 0;
        tmpvar_143 = pow (normalize(tmpvar_142).z, 16.0);
        c_128 = ((half3)((float3)(c_128) + tmpvar_143));
        tmpvar_126 = pow (c_128, (half3)float3(0.666, 0.666, 0.666));
      };
      osc_117 = mix (osc_117, (float3)tmpvar_126, 0.5);
      float4 pi_144 = 0;
      pi_144 = tmpvar_124;
      half3 tmpvar_145 = 0;
      float sl_146 = 0;
      half3 c_147 = 0;
      c_147 = half3(float3(0.0, 0.0, 0.0));
      if ((tmpvar_123 < 0.0)) {
        tmpvar_145 = half3(float3(0.0, 0.0, 0.0));
      } else {
        float2 tmpvar_148 = 0;
        tmpvar_148.x = t_1;
        tmpvar_148.y = tmpvar_5.y;
        half4 tmpvar_149 = 0;
        float2 P_150 = 0;
        P_150 = ((tmpvar_124.xy + (tmpvar_148 * float2(
          sign(tmpvar_124.z)
        ))) * 0.25);
        tmpvar_149 = half4(iChannel0.sample(_mtlsmp_iChannel0, (float2)(P_150)));
        c_147 = half3(dot (tmpvar_149.xyz, (half3)float3(0.333, 0.333, 0.333)));
        float3 tmpvar_151 = 0;
        tmpvar_151.z = 1.0;
        tmpvar_151.xy = tmpvar_124.xy;
        pi_144.w = normalize(tmpvar_151).z;
        float3 tmpvar_152 = 0;
        tmpvar_152 = abs((float3(0.5, 0.0, 0.5) + (0.5 *
          cos((15.0 * ((
            fract(-(pi_144.w))
           -
            (_mtl_u.iTime * 0.08)
          ) + float3(0.0, 0.33, 0.67))))
        )));
        c_147 = ((half3)((float3)(c_147) * tmpvar_152));
        float tmpvar_153 = 0;
        float3 tmpvar_154 = 0;
        tmpvar_154 = (tmpvar_124.xyz - tmpvar_9.xyz);
        float tmpvar_155 = 0;
        tmpvar_155 = dot (tmpvar_154, normalize((tmpvar_9.xyz - tmpvar_124.xyz)));
        float tmpvar_156 = 0;
        tmpvar_156 = ((tmpvar_155 * tmpvar_155) - (dot (tmpvar_154, tmpvar_154) - 3.61));
        if ((tmpvar_156 < 0.0)) {
          tmpvar_153 = -1.0;
        } else {
          tmpvar_153 = (-(tmpvar_155) - sqrt(tmpvar_156));
        };
        sl_146 = (1.0/(min ((tmpvar_153 * tmpvar_153), 10.0)));
        float tmpvar_157 = 0;
        float3 tmpvar_158 = 0;
        tmpvar_158 = (tmpvar_124.xyz - tmpvar_10.xyz);
        float tmpvar_159 = 0;
        tmpvar_159 = dot (tmpvar_158, normalize((tmpvar_10.xyz - tmpvar_124.xyz)));
        float tmpvar_160 = 0;
        tmpvar_160 = ((tmpvar_159 * tmpvar_159) - (dot (tmpvar_158, tmpvar_158) - 3.61));
        if ((tmpvar_160 < 0.0)) {
          tmpvar_157 = -1.0;
        } else {
          tmpvar_157 = (-(tmpvar_159) - sqrt(tmpvar_160));
        };
        c_147 = ((half3)((float3)(c_147) * (sl_146 + (1.0/(
          min ((tmpvar_157 * tmpvar_157), 10.0)
        )))));
        tmpvar_145 = pow (c_147, (half3)float3(0.666, 0.666, 0.666));
      };
      float3 tmpvar_161 = 0;
      tmpvar_161 = mix (osc_117, (float3)tmpvar_145, 0.5);
      if ((tmpvar_123 > tmpvar_121)) {
        osc_117 = tmpvar_161;
      };
      c_65 = mix (sc_66, osc_117, 0.5);
    };
    c_12 = c_65;
  };
  if (((i_58.w > 0.0) && (i_58.w < md_11))) {
    md_11 = i_58.w;
    float4 so_162 = 0;
    float md_163 = 0;
    float3 c_164 = 0;
    float3 sc_165 = 0;
    float3 tmpvar_166 = 0;
    tmpvar_166 = normalize((i_58.xyz - tmpvar_9.xyz));
    float3 tmpvar_167 = 0;
    tmpvar_167 = normalize((i_58.xyz - float3(0.0, 7.2, 0.0)));
    sc_165 = float3((max (0.0, dot (
      normalize((float3(-0.0, -0.0, -3.9) - i_58.xyz))
    , tmpvar_166)) * 0.5));
    float3 tmpvar_168 = 0;
    tmpvar_168 = (tmpvar_167 - (2.0 * (
      dot (tmpvar_166, tmpvar_167)
     * tmpvar_166)));
    float tmpvar_169 = 0;
    tmpvar_169 = (-((i_58.z + 3.9)) / tmpvar_168.z);
    float4 tmpvar_170 = 0;
    tmpvar_170.xyz = (i_58.xyz + (tmpvar_168 * tmpvar_169));
    tmpvar_170.w = tmpvar_169;
    float tmpvar_171 = 0;
    tmpvar_171 = (-((
      dot (i_58.xyz, float3(0.0, 0.0, -1.0))
     + 1.9)) / dot (tmpvar_168, float3(0.0, 0.0, -1.0)));
    float4 tmpvar_172 = 0;
    tmpvar_172.xyz = (i_58.xyz + (tmpvar_168 * tmpvar_171));
    tmpvar_172.w = tmpvar_171;
    float4 pi_173 = 0;
    pi_173 = tmpvar_170;
    half3 tmpvar_174 = 0;
    float sl_175 = 0;
    half3 c_176 = 0;
    c_176 = half3(float3(0.0, 0.0, 0.0));
    if ((tmpvar_169 < 0.0)) {
      tmpvar_174 = half3(float3(0.0, 0.0, 0.0));
    } else {
      float2 tmpvar_177 = 0;
      tmpvar_177.x = t_1;
      tmpvar_177.y = tmpvar_5.y;
      half4 tmpvar_178 = 0;
      float2 P_179 = 0;
      P_179 = ((tmpvar_170.xy + (tmpvar_177 * float2(
        sign(tmpvar_170.z)
      ))) * 0.25);
      tmpvar_178 = half4(iChannel0.sample(_mtlsmp_iChannel0, (float2)(P_179)));
      c_176 = half3(dot (tmpvar_178.xyz, (half3)float3(0.333, 0.333, 0.333)));
      float3 tmpvar_180 = 0;
      tmpvar_180.z = 1.0;
      tmpvar_180.xy = tmpvar_170.xy;
      pi_173.w = normalize(tmpvar_180).z;
      float3 tmpvar_181 = 0;
      tmpvar_181 = abs((float3(0.5, 0.0, 0.5) + (0.5 *
        cos((15.0 * ((
          fract(-(pi_173.w))
         -
          (_mtl_u.iTime * 0.08)
        ) + float3(0.0, 0.33, 0.67))))
      )));
      c_176 = ((half3)((float3)(c_176) * tmpvar_181));
      float tmpvar_182 = 0;
      float3 tmpvar_183 = 0;
      tmpvar_183 = (tmpvar_170.xyz - tmpvar_9.xyz);
      float tmpvar_184 = 0;
      tmpvar_184 = dot (tmpvar_183, normalize((tmpvar_9.xyz - tmpvar_170.xyz)));
      float tmpvar_185 = 0;
      tmpvar_185 = ((tmpvar_184 * tmpvar_184) - (dot (tmpvar_183, tmpvar_183) - 3.61));
      if ((tmpvar_185 < 0.0)) {
        tmpvar_182 = -1.0;
      } else {
        tmpvar_182 = (-(tmpvar_184) - sqrt(tmpvar_185));
      };
      sl_175 = (1.0/(min ((tmpvar_182 * tmpvar_182), 10.0)));
      float tmpvar_186 = 0;
      float3 tmpvar_187 = 0;
      tmpvar_187 = (tmpvar_170.xyz - tmpvar_10.xyz);
      float tmpvar_188 = 0;
      tmpvar_188 = dot (tmpvar_187, normalize((tmpvar_10.xyz - tmpvar_170.xyz)));
      float tmpvar_189 = 0;
      tmpvar_189 = ((tmpvar_188 * tmpvar_188) - (dot (tmpvar_187, tmpvar_187) - 3.61));
      if ((tmpvar_189 < 0.0)) {
        tmpvar_186 = -1.0;
      } else {
        tmpvar_186 = (-(tmpvar_188) - sqrt(tmpvar_189));
      };
      c_176 = ((half3)((float3)(c_176) * (sl_175 + (1.0/(
        min ((tmpvar_186 * tmpvar_186), 10.0)
      )))));
      float3 tmpvar_190 = 0;
      tmpvar_190.z = 1.0;
      tmpvar_190.xy = pi_173.xy;
      float tmpvar_191 = 0;
      tmpvar_191 = pow (normalize(tmpvar_190).z, 16.0);
      c_176 = ((half3)((float3)(c_176) + tmpvar_191));
      tmpvar_174 = pow (c_176, (half3)float3(0.666, 0.666, 0.666));
    };
    c_164 = mix (sc_165, (float3)tmpvar_174, 0.5);
    float4 pi_192 = 0;
    pi_192 = tmpvar_172;
    half3 tmpvar_193 = 0;
    float sl_194 = 0;
    half3 c_195 = 0;
    c_195 = half3(float3(0.0, 0.0, 0.0));
    if ((tmpvar_171 < 0.0)) {
      tmpvar_193 = half3(float3(0.0, 0.0, 0.0));
    } else {
      float2 tmpvar_196 = 0;
      tmpvar_196.x = t_1;
      tmpvar_196.y = tmpvar_5.y;
      half4 tmpvar_197 = 0;
      float2 P_198 = 0;
      P_198 = ((tmpvar_172.xy + (tmpvar_196 * float2(
        sign(tmpvar_172.z)
      ))) * 0.25);
      tmpvar_197 = half4(iChannel0.sample(_mtlsmp_iChannel0, (float2)(P_198)));
      c_195 = half3(dot (tmpvar_197.xyz, (half3)float3(0.333, 0.333, 0.333)));
      float3 tmpvar_199 = 0;
      tmpvar_199.z = 1.0;
      tmpvar_199.xy = tmpvar_172.xy;
      pi_192.w = normalize(tmpvar_199).z;
      float3 tmpvar_200 = 0;
      tmpvar_200 = abs((float3(0.5, 0.0, 0.5) + (0.5 *
        cos((15.0 * ((
          fract(-(pi_192.w))
         -
          (_mtl_u.iTime * 0.08)
        ) + float3(0.0, 0.33, 0.67))))
      )));
      c_195 = ((half3)((float3)(c_195) * tmpvar_200));
      float tmpvar_201 = 0;
      float3 tmpvar_202 = 0;
      tmpvar_202 = (tmpvar_172.xyz - tmpvar_9.xyz);
      float tmpvar_203 = 0;
      tmpvar_203 = dot (tmpvar_202, normalize((tmpvar_9.xyz - tmpvar_172.xyz)));
      float tmpvar_204 = 0;
      tmpvar_204 = ((tmpvar_203 * tmpvar_203) - (dot (tmpvar_202, tmpvar_202) - 3.61));
      if ((tmpvar_204 < 0.0)) {
        tmpvar_201 = -1.0;
      } else {
        tmpvar_201 = (-(tmpvar_203) - sqrt(tmpvar_204));
      };
      sl_194 = (1.0/(min ((tmpvar_201 * tmpvar_201), 10.0)));
      float tmpvar_205 = 0;
      float3 tmpvar_206 = 0;
      tmpvar_206 = (tmpvar_172.xyz - tmpvar_10.xyz);
      float tmpvar_207 = 0;
      tmpvar_207 = dot (tmpvar_206, normalize((tmpvar_10.xyz - tmpvar_172.xyz)));
      float tmpvar_208 = 0;
      tmpvar_208 = ((tmpvar_207 * tmpvar_207) - (dot (tmpvar_206, tmpvar_206) - 3.61));
      if ((tmpvar_208 < 0.0)) {
        tmpvar_205 = -1.0;
      } else {
        tmpvar_205 = (-(tmpvar_207) - sqrt(tmpvar_208));
      };
      c_195 = ((half3)((float3)(c_195) * (sl_194 + (1.0/(
        min ((tmpvar_205 * tmpvar_205), 10.0)
      )))));
      tmpvar_193 = pow (c_195, (half3)float3(0.666, 0.666, 0.666));
    };
    float3 tmpvar_209 = 0;
    tmpvar_209 = mix (sc_165, (float3)tmpvar_193, 0.5);
    md_163 = tmpvar_170.w;
    if ((tmpvar_171 > tmpvar_169)) {
      c_164 = tmpvar_209;
      md_163 = tmpvar_172.w;
    };
    so_162 = tmpvar_9;
    if ((tmpvar_9.x == tmpvar_9.x)) {
      so_162 = tmpvar_10;
    };
    float3 tmpvar_210 = 0;
    tmpvar_210 = normalize(tmpvar_168);
    float4 i_211 = 0;
    i_211 = float4(-1.0, -1.0, -1.0, -1.0);
    float tmpvar_212 = 0;
    float3 tmpvar_213 = 0;
    tmpvar_213 = (i_58.xyz - so_162.xyz);
    float tmpvar_214 = 0;
    tmpvar_214 = dot (tmpvar_213, tmpvar_210);
    float tmpvar_215 = 0;
    tmpvar_215 = ((tmpvar_214 * tmpvar_214) - (dot (tmpvar_213, tmpvar_213) - (so_162.w * so_162.w)));
    if ((tmpvar_215 < 0.0)) {
      tmpvar_212 = -1.0;
    } else {
      tmpvar_212 = (-(tmpvar_214) - sqrt(tmpvar_215));
    };
    if ((tmpvar_212 > 0.0)) {
      i_211.xyz = (i_58.xyz + (tmpvar_210 * tmpvar_212));
      i_211.w = tmpvar_212;
    };
    if (((i_211.w > 0.0) && (i_211.w < md_163))) {
      float3 osc_216 = 0;
      float3 tmpvar_217 = 0;
      tmpvar_217 = normalize((i_211.xyz - so_162.xyz));
      float3 tmpvar_218 = 0;
      tmpvar_218 = normalize((i_211.xyz - i_58.xyz));
      osc_216 = float3((max (0.0, dot (
        normalize((float3(-0.0, -0.0, -3.9) - i_211.xyz))
      , tmpvar_217)) * 0.5));
      float3 tmpvar_219 = 0;
      tmpvar_219 = (tmpvar_218 - (2.0 * (
        dot (tmpvar_217, tmpvar_218)
       * tmpvar_217)));
      float tmpvar_220 = 0;
      tmpvar_220 = (-((i_211.z + 3.9)) / tmpvar_219.z);
      float4 tmpvar_221 = 0;
      tmpvar_221.xyz = (i_211.xyz + (tmpvar_219 * tmpvar_220));
      tmpvar_221.w = tmpvar_220;
      float tmpvar_222 = 0;
      tmpvar_222 = (-((
        dot (i_211.xyz, float3(0.0, 0.0, -1.0))
       + 1.9)) / dot (tmpvar_219, float3(0.0, 0.0, -1.0)));
      float4 tmpvar_223 = 0;
      tmpvar_223.xyz = (i_211.xyz + (tmpvar_219 * tmpvar_222));
      tmpvar_223.w = tmpvar_222;
      float4 pi_224 = 0;
      pi_224 = tmpvar_221;
      half3 tmpvar_225 = 0;
      float sl_226 = 0;
      half3 c_227 = 0;
      c_227 = half3(float3(0.0, 0.0, 0.0));
      if ((tmpvar_220 < 0.0)) {
        tmpvar_225 = half3(float3(0.0, 0.0, 0.0));
      } else {
        float2 tmpvar_228 = 0;
        tmpvar_228.x = t_1;
        tmpvar_228.y = tmpvar_5.y;
        half4 tmpvar_229 = 0;
        float2 P_230 = 0;
        P_230 = ((tmpvar_221.xy + (tmpvar_228 * float2(
          sign(tmpvar_221.z)
        ))) * 0.25);
        tmpvar_229 = half4(iChannel0.sample(_mtlsmp_iChannel0, (float2)(P_230)));
        c_227 = half3(dot (tmpvar_229.xyz, (half3)float3(0.333, 0.333, 0.333)));
        float3 tmpvar_231 = 0;
        tmpvar_231.z = 1.0;
        tmpvar_231.xy = tmpvar_221.xy;
        pi_224.w = normalize(tmpvar_231).z;
        float3 tmpvar_232 = 0;
        tmpvar_232 = abs((float3(0.5, 0.0, 0.5) + (0.5 *
          cos((15.0 * ((
            fract(-(pi_224.w))
           -
            (_mtl_u.iTime * 0.08)
          ) + float3(0.0, 0.33, 0.67))))
        )));
        c_227 = ((half3)((float3)(c_227) * tmpvar_232));
        float tmpvar_233 = 0;
        float3 tmpvar_234 = 0;
        tmpvar_234 = (tmpvar_221.xyz - tmpvar_9.xyz);
        float tmpvar_235 = 0;
        tmpvar_235 = dot (tmpvar_234, normalize((tmpvar_9.xyz - tmpvar_221.xyz)));
        float tmpvar_236 = 0;
        tmpvar_236 = ((tmpvar_235 * tmpvar_235) - (dot (tmpvar_234, tmpvar_234) - 3.61));
        if ((tmpvar_236 < 0.0)) {
          tmpvar_233 = -1.0;
        } else {
          tmpvar_233 = (-(tmpvar_235) - sqrt(tmpvar_236));
        };
        sl_226 = (1.0/(min ((tmpvar_233 * tmpvar_233), 10.0)));
        float tmpvar_237 = 0;
        float3 tmpvar_238 = 0;
        tmpvar_238 = (tmpvar_221.xyz - tmpvar_10.xyz);
        float tmpvar_239 = 0;
        tmpvar_239 = dot (tmpvar_238, normalize((tmpvar_10.xyz - tmpvar_221.xyz)));
        float tmpvar_240 = 0;
        tmpvar_240 = ((tmpvar_239 * tmpvar_239) - (dot (tmpvar_238, tmpvar_238) - 3.61));
        if ((tmpvar_240 < 0.0)) {
          tmpvar_237 = -1.0;
        } else {
          tmpvar_237 = (-(tmpvar_239) - sqrt(tmpvar_240));
        };
        c_227 = ((half3)((float3)(c_227) * (sl_226 + (1.0/(
          min ((tmpvar_237 * tmpvar_237), 10.0)
        )))));
        float3 tmpvar_241 = 0;
        tmpvar_241.z = 1.0;
        tmpvar_241.xy = pi_224.xy;
        float tmpvar_242 = 0;
        tmpvar_242 = pow (normalize(tmpvar_241).z, 16.0);
        c_227 = ((half3)((float3)(c_227) + tmpvar_242));
        tmpvar_225 = pow (c_227, (half3)float3(0.666, 0.666, 0.666));
      };
      osc_216 = mix (osc_216, (float3)tmpvar_225, 0.5);
      float4 pi_243 = 0;
      pi_243 = tmpvar_223;
      half3 tmpvar_244 = 0;
      float sl_245 = 0;
      half3 c_246 = 0;
      c_246 = half3(float3(0.0, 0.0, 0.0));
      if ((tmpvar_222 < 0.0)) {
        tmpvar_244 = half3(float3(0.0, 0.0, 0.0));
      } else {
        float2 tmpvar_247 = 0;
        tmpvar_247.x = t_1;
        tmpvar_247.y = tmpvar_5.y;
        half4 tmpvar_248 = 0;
        float2 P_249 = 0;
        P_249 = ((tmpvar_223.xy + (tmpvar_247 * float2(
          sign(tmpvar_223.z)
        ))) * 0.25);
        tmpvar_248 = half4(iChannel0.sample(_mtlsmp_iChannel0, (float2)(P_249)));
        c_246 = half3(dot (tmpvar_248.xyz, (half3)float3(0.333, 0.333, 0.333)));
        float3 tmpvar_250 = 0;
        tmpvar_250.z = 1.0;
        tmpvar_250.xy = tmpvar_223.xy;
        pi_243.w = normalize(tmpvar_250).z;
        float3 tmpvar_251 = 0;
        tmpvar_251 = abs((float3(0.5, 0.0, 0.5) + (0.5 *
          cos((15.0 * ((
            fract(-(pi_243.w))
           -
            (_mtl_u.iTime * 0.08)
          ) + float3(0.0, 0.33, 0.67))))
        )));
        c_246 = ((half3)((float3)(c_246) * tmpvar_251));
        float tmpvar_252 = 0;
        float3 tmpvar_253 = 0;
        tmpvar_253 = (tmpvar_223.xyz - tmpvar_9.xyz);
        float tmpvar_254 = 0;
        tmpvar_254 = dot (tmpvar_253, normalize((tmpvar_9.xyz - tmpvar_223.xyz)));
        float tmpvar_255 = 0;
        tmpvar_255 = ((tmpvar_254 * tmpvar_254) - (dot (tmpvar_253, tmpvar_253) - 3.61));
        if ((tmpvar_255 < 0.0)) {
          tmpvar_252 = -1.0;
        } else {
          tmpvar_252 = (-(tmpvar_254) - sqrt(tmpvar_255));
        };
        sl_245 = (1.0/(min ((tmpvar_252 * tmpvar_252), 10.0)));
        float tmpvar_256 = 0;
        float3 tmpvar_257 = 0;
        tmpvar_257 = (tmpvar_223.xyz - tmpvar_10.xyz);
        float tmpvar_258 = 0;
        tmpvar_258 = dot (tmpvar_257, normalize((tmpvar_10.xyz - tmpvar_223.xyz)));
        float tmpvar_259 = 0;
        tmpvar_259 = ((tmpvar_258 * tmpvar_258) - (dot (tmpvar_257, tmpvar_257) - 3.61));
        if ((tmpvar_259 < 0.0)) {
          tmpvar_256 = -1.0;
        } else {
          tmpvar_256 = (-(tmpvar_258) - sqrt(tmpvar_259));
        };
        c_246 = ((half3)((float3)(c_246) * (sl_245 + (1.0/(
          min ((tmpvar_256 * tmpvar_256), 10.0)
        )))));
        tmpvar_244 = pow (c_246, (half3)float3(0.666, 0.666, 0.666));
      };
      float3 tmpvar_260 = 0;
      tmpvar_260 = mix (osc_216, (float3)tmpvar_244, 0.5);
      if ((tmpvar_222 > tmpvar_220)) {
        osc_216 = tmpvar_260;
      };
      c_164 = mix (sc_165, osc_216, 0.5);
    };
    c_12 = c_164;
  };
  if (((tmpvar_49 > 0.0) && (tmpvar_49 < md_11))) {
    md_11 = tmpvar_50.w;
    float4 pi_261 = 0;
    pi_261 = tmpvar_50;
    half3 tmpvar_262 = 0;
    float sl_263 = 0;
    half3 c_264 = 0;
    c_264 = half3(float3(0.0, 0.0, 0.0));
    if ((tmpvar_49 < 0.0)) {
      tmpvar_262 = half3(float3(0.0, 0.0, 0.0));
    } else {
      float2 tmpvar_265 = 0;
      tmpvar_265.x = t_1;
      tmpvar_265.y = tmpvar_5.y;
      half4 tmpvar_266 = 0;
      float2 P_267 = 0;
      P_267 = ((tmpvar_50.xy + (tmpvar_265 * float2(
        sign(tmpvar_50.z)
      ))) * 0.25);
      tmpvar_266 = half4(iChannel0.sample(_mtlsmp_iChannel0, (float2)(P_267)));
      c_264 = half3(dot (tmpvar_266.xyz, (half3)float3(0.333, 0.333, 0.333)));
      float3 tmpvar_268 = 0;
      tmpvar_268.z = 1.0;
      tmpvar_268.xy = tmpvar_50.xy;
      pi_261.w = normalize(tmpvar_268).z;
      float3 tmpvar_269 = 0;
      tmpvar_269 = abs((float3(0.5, 0.0, 0.5) + (0.5 *
        cos((15.0 * ((
          fract(-(pi_261.w))
         -
          (_mtl_u.iTime * 0.08)
        ) + float3(0.0, 0.33, 0.67))))
      )));
      c_264 = ((half3)((float3)(c_264) * tmpvar_269));
      float tmpvar_270 = 0;
      float3 tmpvar_271 = 0;
      tmpvar_271 = (tmpvar_50.xyz - tmpvar_9.xyz);
      float tmpvar_272 = 0;
      tmpvar_272 = dot (tmpvar_271, normalize((tmpvar_9.xyz - tmpvar_50.xyz)));
      float tmpvar_273 = 0;
      tmpvar_273 = ((tmpvar_272 * tmpvar_272) - (dot (tmpvar_271, tmpvar_271) - 3.61));
      if ((tmpvar_273 < 0.0)) {
        tmpvar_270 = -1.0;
      } else {
        tmpvar_270 = (-(tmpvar_272) - sqrt(tmpvar_273));
      };
      sl_263 = (1.0/(min ((tmpvar_270 * tmpvar_270), 10.0)));
      float tmpvar_274 = 0;
      float3 tmpvar_275 = 0;
      tmpvar_275 = (tmpvar_50.xyz - tmpvar_10.xyz);
      float tmpvar_276 = 0;
      tmpvar_276 = dot (tmpvar_275, normalize((tmpvar_10.xyz - tmpvar_50.xyz)));
      float tmpvar_277 = 0;
      tmpvar_277 = ((tmpvar_276 * tmpvar_276) - (dot (tmpvar_275, tmpvar_275) - 3.61));
      if ((tmpvar_277 < 0.0)) {
        tmpvar_274 = -1.0;
      } else {
        tmpvar_274 = (-(tmpvar_276) - sqrt(tmpvar_277));
      };
      c_264 = ((half3)((float3)(c_264) * (sl_263 + (1.0/(
        min ((tmpvar_274 * tmpvar_274), 10.0)
      )))));
      tmpvar_262 = pow (c_264, (half3)float3(0.666, 0.666, 0.666));
    };
    c_12 = (c_12 + (float3)(tmpvar_262));
  };
  if (((tmpvar_46 > 0.0) && (tmpvar_46 < md_11))) {
    md_11 = tmpvar_47.w;
    float4 pi_278 = 0;
    pi_278 = tmpvar_47;
    half3 tmpvar_279 = 0;
    float sl_280 = 0;
    half3 c_281 = 0;
    c_281 = half3(float3(0.0, 0.0, 0.0));
    if ((tmpvar_46 < 0.0)) {
      tmpvar_279 = half3(float3(0.0, 0.0, 0.0));
    } else {
      float2 tmpvar_282 = 0;
      tmpvar_282.x = t_1;
      tmpvar_282.y = tmpvar_5.y;
      half4 tmpvar_283 = 0;
      float2 P_284 = 0;
      P_284 = ((tmpvar_47.xy + (tmpvar_282 * float2(
        sign(tmpvar_47.z)
      ))) * 0.25);
      tmpvar_283 = half4(iChannel0.sample(_mtlsmp_iChannel0, (float2)(P_284)));
      c_281 = half3(dot (tmpvar_283.xyz, (half3)float3(0.333, 0.333, 0.333)));
      float3 tmpvar_285 = 0;
      tmpvar_285.z = 1.0;
      tmpvar_285.xy = tmpvar_47.xy;
      pi_278.w = normalize(tmpvar_285).z;
      float3 tmpvar_286 = 0;
      tmpvar_286 = abs((float3(0.5, 0.0, 0.5) + (0.5 *
        cos((15.0 * ((
          fract(-(pi_278.w))
         -
          (_mtl_u.iTime * 0.08)
        ) + float3(0.0, 0.33, 0.67))))
      )));
      c_281 = ((half3)((float3)(c_281) * tmpvar_286));
      float tmpvar_287 = 0;
      float3 tmpvar_288 = 0;
      tmpvar_288 = (tmpvar_47.xyz - tmpvar_9.xyz);
      float tmpvar_289 = 0;
      tmpvar_289 = dot (tmpvar_288, normalize((tmpvar_9.xyz - tmpvar_47.xyz)));
      float tmpvar_290 = 0;
      tmpvar_290 = ((tmpvar_289 * tmpvar_289) - (dot (tmpvar_288, tmpvar_288) - 3.61));
      if ((tmpvar_290 < 0.0)) {
        tmpvar_287 = -1.0;
      } else {
        tmpvar_287 = (-(tmpvar_289) - sqrt(tmpvar_290));
      };
      sl_280 = (1.0/(min ((tmpvar_287 * tmpvar_287), 10.0)));
      float tmpvar_291 = 0;
      float3 tmpvar_292 = 0;
      tmpvar_292 = (tmpvar_47.xyz - tmpvar_10.xyz);
      float tmpvar_293 = 0;
      tmpvar_293 = dot (tmpvar_292, normalize((tmpvar_10.xyz - tmpvar_47.xyz)));
      float tmpvar_294 = 0;
      tmpvar_294 = ((tmpvar_293 * tmpvar_293) - (dot (tmpvar_292, tmpvar_292) - 3.61));
      if ((tmpvar_294 < 0.0)) {
        tmpvar_291 = -1.0;
      } else {
        tmpvar_291 = (-(tmpvar_293) - sqrt(tmpvar_294));
      };
      c_281 = ((half3)((float3)(c_281) * (sl_280 + (1.0/(
        min ((tmpvar_291 * tmpvar_291), 10.0)
      )))));
      float3 tmpvar_295 = 0;
      tmpvar_295.z = 1.0;
      tmpvar_295.xy = pi_278.xy;
      float tmpvar_296 = 0;
      tmpvar_296 = pow (normalize(tmpvar_295).z, 16.0);
      c_281 = ((half3)((float3)(c_281) + tmpvar_296));
      tmpvar_279 = pow (c_281, (half3)float3(0.666, 0.666, 0.666));
    };
    c_12 = (c_12 + (float3)(tmpvar_279));
  };
  c_12 = (c_12 * exp((-0.05 * md_11)));
  float3 tmpvar_297 = 0;
  tmpvar_297 = pow (c_12, float3(0.44, 0.5, 0.55));
  float3 tmpvar_298 = 0;
  tmpvar_298 = clamp (tmpvar_297, 0.0, 1.0);
  float3 tmpvar_299 = 0;
  tmpvar_299 = mix (tmpvar_297, (tmpvar_298 * (tmpvar_298 *
    (3.0 - (2.0 * tmpvar_298))
  )), 0.5);
  col_3 = (mix (tmpvar_299, float3(dot (tmpvar_299, float3(0.333, 0.333, 0.333))), -0.2) * (0.2 + (0.8 *
    pow ((((
      (16.0 * q_4.x)
     * q_4.y) * (1.0 - q_4.x)) * (1.0 - q_4.y)), 0.2)
  )));
  float n_300 = 0;
  n_300 = (q_4.x + (13.3214 * q_4.y));
  float3 tmpvar_301 = 0;
  tmpvar_301.x = n_300;
  tmpvar_301.y = (n_300 + 1.0);
  tmpvar_301.z = (n_300 + 2.0);
  col_3 = (col_3 + (0.003921569 * fract(
    (sin(tmpvar_301) * 43758.55)
  )));
  float4 tmpvar_302 = 0;
  tmpvar_302.w = 1.0;
  tmpvar_302.xyz = col_3;
  _mtl_o.gl_FragColor = tmpvar_302;
  return _mtl_o;
}
