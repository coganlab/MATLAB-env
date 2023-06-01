function [spike, pos, vel] = binAndClean( pk, dt, kinematics )
% Given data in the post-processed format, turn it into something easy to
% use for training or testing a decoder.
%
% Input:
%   pk - Cell array of threshold crossing times and intensities.  Ignores
%        intensities for now.
%   dt - Width of the time bins for spikes and arm kinematics
%   kinematics - Cell array of arm kinematics, either joint angles or
%                marker positions.  The first row in each cell is always
%                time stamps, the rest of the rows are values.
%
% Output:
%   spike - 2D array of spike counts, one column for each cell of pk
%   pos - 2D array of average values of kinematics, one column for each row
%         after the first one of kinematics.
%   vel - 2D array of average derivatives of kinematics, same format as pos

% Process kinematics into form we can pass to bin
kin = {};
if ~iscell(kinematics) % If only a single array of kinematics is passed
    kinematics = {kinematics};
end
for i = 1:length(kinematics)
    for j = 2:size(kinematics{i},1)
        kin = [kin kinematics{i}([1 j],:)'];
    end
end

[spike, pos, vel] = bin( pk, dt, kin );

% Clear zeros
idx = find(pos(:,1));
spike = spike(idx,:);
pos = pos(idx,:);
vel = vel(idx,:);