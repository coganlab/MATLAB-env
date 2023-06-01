function arm_gravity_comp(model)

% gravity compensation
comp = zeros(model.nv,1);
for b = 1:model.nbody
	if model.body_tag(b) == 1
        comp = comp - mj('jacbodycom',b-1)' * [0 0 -9.81]' * model.body_mass(b);
	end
end

% apply forces
mj('set','qfrc_applied',comp);

