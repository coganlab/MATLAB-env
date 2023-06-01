% cost function for the humanoid
function c = getup_cost(x, u)

% constants
k_torque		= .3;   
desired_height	= 1.3;
k_height		= 1;   
k_velocity		= 0.03;
dt				= mj('get','dt');

% set final controls to 0
final		= isnan(u);
u(final)	= 0;

c   = k_torque*sum(u.^2,1) + ...
	  k_height*sqrt((x(3,:,:)-desired_height).^2)+ ...
	  k_velocity*sum(x((27:29),:,:).^2,1); % [27 28] are the horizontal root velocities
  
c   = dt*c;
