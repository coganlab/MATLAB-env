function arm_reach(model)

% gravity compensation
comp = zeros(model.nv,1);
for b = 1:model.nbody
	if model.body_tag(b) == 1
        comp = comp - mj('jacbodycom',b-1)' * [0 0 -9.81]' * model.body_mass(b);
	end
end

% virtual spring-damper
k_spring	= 1;
k_damper	= .2;
handjac		= mj('jacsite',0);
xpos		= mj('get','site_xpos');
spring		= k_spring * handjac' * xpos' * [-1;1];
damper		= -k_damper * (handjac' * handjac) * mj('get','qvel');

% apply forces
mj('set','qfrc_applied',comp + spring + damper);
