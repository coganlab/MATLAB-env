function out=runKalman(in,Params)



% Decode on held-out data
[wristEst wristVar] = kalmanFilter(spikeTest'-meanSpike*ones(1,size(spikeTest,1)),A,C,Q,R,zeros(6,1),Q);

function [z V ll VV P] = kalmanFilter(y, A, C, Q, R, z0, P0, varargin)
% Forward pass of a Kalman smoother.  If used for smoothing, we also want
% to output P_{t+1|t}, which we denote P here.
% Also includes optional u, B and D for the input-output case

% for i = 1:2:length(varargin)
%     eval([varargin{i} ' = varargin{' num2str(i+1) '};']);
% end
% if exist('u','var') && ~exist('B','var') && ~exist('D','var')
%     error('Input-output parameters missing!')
% end
% if (exist('B','var') || exist('D','var')) && ~exist('u','var')
%     error('Input data missing!');
% end

% z = zeros(size(P0,1),size(y,2));
% V = zeros(size(P0,1),size(P0,2),size(y,2));
% if nargout > 3
%     VV = zeros(size(V));
% end
% if nargout > 4
%     P = zeros(size(V));
% end

ll = zeros(size(y,2),1); % log likelihood
zt = z0;
Pt = P0;

Rinv = R^-1; % store for fast matrix inversion
for i = 1:size(y,2)
    % Precision matrix of y(:,i) given y(:,1:i-1).
    if size(y,1) > 50
        % Same as (C*Pt*C' + R)^-1 by Woodbury lemma.
        T = Rinv*C;
        Sinv = Rinv - T*(Pt^-1 + C'*T)^-1*T';
    else
        Sinv = (C*Pt*C' + R)^-1;
    end
    xt = y(:,i) - C*zt; % residual
    if exist('D','var')
        xt = xt - D*u(:,i);
    end
    ll(i) = - 0.5*( xt'*Sinv*xt + size(y,1)*log( 2*pi ) - log( det( Sinv ) ) ); % log likelihood of one observation
    
    % update
    Kt = Pt*C'*Sinv; % Kalman gain
    zt = zt + Kt*xt;
    if nargout > 3
        if i > 1
            VV(:,:,i) = A*Vt - Kt*C*A*Vt;
        else
            VV(:,:,i) = A*P0 - Kt*C*A*P0;
        end
    end
    Vt = Pt - Kt*C*Pt;
    
    z(:,i) = zt;
    V(:,:,i) = Vt;
    
    % predict
    zt = A*zt;
    if exist('B','var')
        zt = zt + B*u(:,i);
    end
    Pt = A*Vt*A' + Q;
    if nargout > 4
        P(:,:,i) = Pt;
    end
end


%%
reggie_pmd_sc32
DATES = {'111221'};
TRIALS = [5 6];
calvin_pmd_pmv_ppc_sc32x5
DATES = {'130325'};
TRIALS = [5];

global model
A = model.A;
C = model.C;
Q = model.Q;
R = model.R;
z0 = model.z0;
P0 = model.P0;

%ll = zeros(size(y,2),1); % log likelihood
zt = z0;
Pt = P0;

Rinv = R^-1; % store for fast matrix inversion
% Precision matrix of y(:,i) given y(:,1:i-1).
if size(y,1) > 50
    % Same as (C*Pt*C' + R)^-1 by Woodbury lemma.
    T = Rinv*C;
    Sinv = Rinv - T*(Pt^-1 + C'*T)^-1*T';
else
    Sinv = (C*Pt*C' + R)^-1;
end
xt = y(:) - C*zt; % residual
%ll = - 0.5*( xt'*Sinv*xt + size(y,1)*log( 2*pi ) - log( det( Sinv ) ) ); % log likelihood of one observation

% update
Kt = Pt*C'*Sinv; % Kalman gain
zt = zt + Kt*xt;
%VV(:,:) = A*P0 - Kt*C*A*P0;
Vt = Pt - Kt*C*Pt;

[A C Q R meanSpike meanWrist] = fitKalman(spikeTrain',[wristPosTrain';wristVelTrain'],1);
tmp = spikeTest'-meanSpike*ones(1,size(spikeTest,1));
whos tmp
whos A C Q R
n = size(wristEst,2);
for i = 1:3
    subplot(3,2,2*i-1);
    plot(1:n,wristPosTest(:,i),1:n,wristEst(i,:)+meanWrist(i))
    subplot(3,2,2*i);
    plot(1:n,wristVelTest(:,i),1:n,wristEst(i+3,:)+meanWrist(i+3))
end

% predict
zt = A*zt;
Pt = A*Vt*A' + Q;
%P(:,:) = Pt;
out = zt;
model.z0 = zt;
model.P0 = Pt;

