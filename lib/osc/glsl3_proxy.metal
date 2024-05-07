#ifndef MT_OSC
#define MT_OSC

struct Glsl3Uniforms { // @uniform
    float o_scale;      // @range 1 .. 10
    float o_distance;   // @range -1 .. 1
    float o_fov;
    float o_aim_sc;     // @range 1 .. 10
    float2 o_aim;       // @range -1 .. 1
    float o_pan_sc;     // @range 1 .. 10
    float2 o_pan;       // @range -1 .. 1

    float3 o_col1;
    float3 o_col2;
    float3 o_col3;
    float3 o_col4;
    float3 o_col5;
    float3 o_col6;

    float o_long;
    float o_exp;

    float o_fad1;
    float o_fad2;
    float o_fad3;
    float o_fad4;
    float o_fad5;
    float o_fad6;
    float o_mix1;
    float o_mix2;
    float o_mix3;
    float o_mix4;
    float o_rot1;
    float o_rot2;
    float o_birot1;
    float o_birot2;
    float o_bifad1;
    float o_bifad2;
    float o_lfad1;
    float o_lfad2;
    float o_lfad3;
    float o_lmix1;
    float o_lmix2;
    float o_lmix3;
    float o_lbfad1;
    float3 o_color;
    float o_float5x;
    float o_float5y;
    float o_float5z;
    float o_float5w;

    float o_red;
    float o_green;
    float o_blue;
    float o_gam_r;
    float o_gam_g;
    float o_gam_b;

    float2 o_multixy_1;
    float2 o_multixy_2;
    float2 o_multixy_3;
    float2 o_multixy_4;
    float2 o_multixy_5;

    float o_mfad1;
    float o_mfad2;
    float o_mrot1;
    float o_mrot2;
    float o_mrot3;
    float o_mrot4;


    float o_float1_1;
    float o_float1_2;
    float o_float1_3;
    float o_float1_4;

    float o_tog1;
    float o_tog2;
    float o_tog3;
    float o_tog4;
    float o_tog5;

    // float2 u_resolution;
};

#define o_red (_u.o_red)
#define o_green (_u.o_green)
#define o_blue (_u.o_blue)
#define o_gam_r (_u.o_gam_r)
#define o_gam_g (_u.o_gam_g)
#define o_gam_b (_u.o_gam_b)
#define o_aim (_u.o_aim)
#define o_aim_sc (_u.o_aim_sc)
#define o_pan (_u.o_pan)
#define o_pan_sc (_u.o_pan_sc)
#define o_distance (_u.o_distance)
#define o_scale (_u.o_scale)
#define o_fad1 (_u.o_fad1)
#define o_fad2 (_u.o_fad2)
#define o_fad3 (_u.o_fad3)
#define o_fad4 (_u.o_fad4)
#define o_fad5 (_u.o_fad5)
#define o_fad6 (_u.o_fad6)
#define o_mix1 (_u.o_mix1)
#define o_mix2 (_u.o_mix2)
#define o_mix3 (_u.o_mix3)
#define o_mix4 (_u.o_mix4)
#define o_rot1 (_u.o_rot1)
#define o_rot2 (_u.o_rot2)
#define o_birot1 (_u.o_birot1)
#define o_birot2 (_u.o_birot2)
#define o_long (_u.o_long)
#define o_exp (_u.o_exp)
#define o_bifad1 (_u.o_bifad1)
#define o_bifad2 (_u.o_bifad2)
#define o_lfad1 (_u.o_lfad1)
#define o_lfad2 (_u.o_lfad2)
#define o_lfad3 (_u.o_lfad3)
#define o_lmix1 (_u.o_lmix1)
#define o_lmix2 (_u.o_lmix2)
#define o_lmix3 (_u.o_lmix3)
#define o_lbfad1 (_u.o_lbfad1)
#define o_color (_u.o_color)
#define o_float5x (_u.o_float5x)
#define o_float5y (_u.o_float5y)
#define o_float5z (_u.o_float5z)
#define o_float5w (_u.o_float5w)
#define o_multixy_1 (_u.o_multixy_1)
#define o_multixy_2 (_u.o_multixy_2)
#define o_multixy_3 (_u.o_multixy_3)
#define o_multixy_4 (_u.o_multixy_4)
#define o_multixy_5 (_u.o_multixy_5)
#define o_mfad1 (_u.o_mfad1)
#define o_mfad2 (_u.o_mfad2)
#define o_mrot1 (_u.o_mrot1)
#define o_mrot2 (_u.o_mrot2)
#define o_mrot3 (_u.o_mrot3)
#define o_mrot4 (_u.o_mrot4)
#define o_float1_1 (_u.o_float1_1)
#define o_float1_2 (_u.o_float1_2)
#define o_float1_3 (_u.o_float1_3)
#define o_float1_4 (_u.o_float1_4)
#define o_col1 (_u.o_col1)
#define o_col2 (_u.o_col2)
#define o_col3 (_u.o_col3)
#define o_col4 (_u.o_col4)
#define o_col5 (_u.o_col5)
#define o_col6 (_u.o_col6)
#define o_tog1 (_u.o_tog1)
#define o_tog2 (_u.o_tog2)
#define o_tog3 (_u.o_tog3)
#define o_tog4 (_u.o_tog4)
#define o_tog5 (_u.o_tog5)

#define o_vec5 (float4(o_vec5x,o_vec5y,o_vec5z,o_vec5w))

#define o_vec1 float4(o_vec1_1,o_vec1_2,o_vec1_3,o_vec1_4)


#define TOG1 (o_tog1 == 1.0)
#define TOG2 (o_tog2 == 1.0)
#define TOG3 (o_tog3 == 1.0)
#define TOG4 (o_tog4 == 1.0)
#define TOG5 (o_tog5 == 1.0)

#define COL1 (o_col1)
#define COL2 (o_col2)
#define COL3 (o_col3)
#define COL4 (o_col4)
#define COL5 (o_col5)
#define COL6 (o_col6)

#define o_resolution (sys_u.resolution)

#endif