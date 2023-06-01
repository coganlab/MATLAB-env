function [MM_x,MM_y,V_xy] = gpb2_collapse_cross(MM_xj, MM_yj,V_xyj,P_j)
dims = size(MM_xj,1);
m = size(MM_xj,2);
MM_x = zeros(size(MM_xj,1),1);
MM_y = zeros(size(MM_xj,1),1);
V_xy = zeros(dims,dims);
for i=1:m
    MM_x = MM_x + P_j(i)*MM_xj(:,i);
    MM_y = MM_y + P_j(i)*MM_yj(:,i);
end
for i=1:m
    V_xy = V_xy + P_j(i)*V_xyj(:,:,i)...
	        + P_j(i)*(MM_xj(:,i)-MM_x)*(MM_yj(:,i)-MM_y)';
end

