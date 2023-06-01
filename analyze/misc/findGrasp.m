function [start_grasp, stop_grasp] = findGrasp(marker_pos)

disp('Inside findGrasp')


%clean up data remove Inf
marker_pos(marker_pos < -360) = 0;
marker_pos(marker_pos > 360) = 360;

%set a threhold for detection 
thresh = mean(marker_pos);
thres_data = marker_pos;
thres_data(thres_data < thresh) = -1;
thres_data(thres_data >= thresh) = 1;
smooth_param = 5;
smooth_thres_data = smooth(thres_data,smooth_param);
smooth_thres_data(smooth_thres_data<0) = -1;
smooth_thres_data(smooth_thres_data>=0) = 1;
ind = diff(smooth_thres_data);
start_grasp = find(ind < 0);
stop_grasp = find(ind > 0);



figure
hold on
plot(marker_pos)
plot(start_grasp,ones(1,length(start_grasp))*175,'gx')
plot(stop_grasp,ones(1,length(stop_grasp))*175,'ro')
plot((thres_data*2)*30+75,'r')
plot((([smooth_thres_data(1),smooth_thres_data])*2)*30+75,'k')
title('red start grasp, green grasp stop')