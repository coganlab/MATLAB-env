%--------------------------------------%
%  cart-pole trajectory optimization   %
%--------------------------------------%

% -- prepare  

% convert 
xml2mjb('cartpole.xml')

% load model
mj('load',which('cartpole.mjb'))
model = mj('getmodel');

%% -- control with MPC
if ~isempty(findobj(0,'Tag','mjplot'))
	figure(findobj(0,'Tag','mjplot'))
end
mjsim(@MPC_controller);