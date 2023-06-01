function [MU_x,P_j] = gpb2_collapse(MM_xj,V_xx_j,P_j)
[MU_x,MU_y,P_j] =  gpb2_collapse_cross(MM_xj,MM_xj,V_xx_j,P_j);
