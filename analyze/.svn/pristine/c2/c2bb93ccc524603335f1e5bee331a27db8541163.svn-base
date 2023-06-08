% cost function for the cart-pole system
function c = cartpole_cost(x, u)

% constants
k_force		= 1;   
k_height    = 1;   
k_position	= 0.1; 
k_velocity	= 0.001; 
dt			= mj('get','dt');

% set final controls to 0
final		= isnan(u);
u(final)	= 0;

c   = k_force*u.^2 + ...
	  k_position*x(1,:,:).^2 + k_height*(1-cos(x(2,:,:))) + k_velocity*x(4,:,:).^2;
c   = dt*c;
