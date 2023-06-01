function [params hyperparams] = train( arm_data, neural_data, hyperparams )

n = size(arm_data,2);
arm_mean = mean(arm_data,2);
arm_data = arm_data - arm_mean*ones(1,n);

neural_mean = mean(neural_data,2);
neural_data = neural_data - neural_mean*ones(1,n);

A = arm_data(:,2:end) * pinv( arm_data(:,1:end-1) );
C = neural_data * pinv( arm_data );

Ares = arm_data(:,2:end) - A*arm_data(:,1:end-1);
Q = Ares*Ares'/n;

Cres = neural_data - C*arm_data;
R = Cres*Cres'/n;

params = struct('A',A,'C',C,'Q',Q,'R',R,'Rinv',R^-1,'mz',arm_mean,'my',neural_mean,'z0',zeros(size(arm_data,1),1),'V0',Q);
if nargin == 2
    hyperparams = struct();
end