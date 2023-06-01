function gp = PlusOperator(g,nchan,nfreq)

% This function is for [ ]+operation: 
% to take the positive lags & half of the zero lag and reconstitute 
% M. Dhamala, UF, August 2006

g   = transpose(reshape(g, nchan^2, []));
gam = ifft(g);

% taking only the positive lags and half of the zero lag
gamp  = gam;
beta0 = 0.5*gam(1,:);

gamp(1,          :) = reshape(triu(reshape(beta0, [nchan nchan])),[1 nchan^2]);
gamp(nfreq+1:end,:) = 0;

% reconstituting
gp = fft(gamp);
gp = reshape(transpose(gp), [nchan nchan numel(gp)/(nchan^2)]); 