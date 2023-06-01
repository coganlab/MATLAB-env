function decoder = makeKalmanDecoder( pk, kinematics, binWidth, order )
% decoder = makeKalmanDecoder( pk, Marker, binWidth, order )
%
% Wrapper function that returns trained Kalman filter decoder
%
% Inputs:
%   pk - Cell array of spike times.  Even if each entry contains other
%   information, the first column should always be spike times
%
%   kinematics - Cell array of kinematic variables to be decoded, whether
%   joint angles or marker positions.  The first row in each cell should be
%   times, while every row after that is the value of that particular
%   variable at that time
%
%   binWidth - the width of the time bins
%
%   order - the number of time steps into the past on which both the
%   evolution of the kinematic variables and the firing rate are assumed to
%   depend
%
%   fraction - the fraction of the data used for training
%
% Output:
%   decoder - a function handle which, given a cell array of threshold
%   crossings formatted like the input, returns predictions of the
%   kinematics.

[spikes,values,derivs] = binAndClean( pk, binWidth, kinematics );

[A C Q R my mz] = fitKalman( spikes', [values';derivs'], order );

decoder = @(x,format) doKalmanFilter( x, A, C, Q, R, my, mz, binWidth, format );

function z = doKalmanFilter( x, A, C, Q, R, my, mz, dt, format )

switch format
    case 'pk'
        y = bin( x, dt );
    otherwise
        y = x;
end

z = kalmanFilter( y' - my*ones(1,size(y,1)), A, C, Q, R, zeros(size(A,1),1), Q );
z = z + mz*ones(1,size(z,2));
