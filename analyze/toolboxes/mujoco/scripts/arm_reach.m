function arm_reach(model)
global xposmatrix qposmatrix sites% CJC
% qpos = mj('get','qpos');% 26 x 1 matrix, CJC
% qposmatrix = [qposmatrix qpos];% CJC
% xpos = mj('get','site_xpos'); xpos = xpos(1,:) + [0.045 0 0];% CJC
% xposmatrix = [xposmatrix xpos'];% 3 x numT matrix, CJC


% gravity compensation
comp = zeros(model.nv,1);
for b = 1:model.nbody
	if model.body_tag(b) == 1
        %comp = comp - mj('jacbodycom',b-1)' * [0 0 -9.81]' * model.body_mass(b);
        comp = comp - mj('jacbodycom',b-1)' * [0 0 0]' * model.body_mass(b);% CJC
	end
end

% virtual spring-damper
k_spring	= 30;
%k_damper	= .2;
k_damper    = 1;% CJC
handjac		= mj('jacsite',0);
xpos		= mj('get','site_xpos');
%xpos = xpos(end-1:end,:);
spring		= k_spring * handjac' * xpos' * [-1;1];
damper		= -k_damper * (handjac' * handjac) * mj('get','qvel');

% apply forces
mj('set','qfrc_applied',comp + spring + damper);


qpos = mj('get','qpos');% 26 x 1 matrix, CJC
qposmatrix = [qposmatrix qpos];% CJC
xpos = mj('get','site_xpos'); 
%xpos = xpos(end-1:end,:);
xpos = xpos(1,:) + [0.045 0 0];% CJC
xposmatrix = [xposmatrix xpos'];% 3 x numT matrix, CJC
tmp = mj('get','site_xpos');
%tmp2 = reshape(tmp(1:end-1,:), 1, 3*(length(tmp)-1));
%sites = [sites; tmp2];