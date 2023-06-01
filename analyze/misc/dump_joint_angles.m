% DUMP_JOINT_ANGLES(names, joints, outfile, recs)
%
% Dumps joint angles to disk in ASCII format for
% rendering with fakecortex and friends.
%
% Input:
%
% names: 1xN cell array of joint names
%
% joints: 1xN cell array of 2xM double arrays
% where N is the angle count.  the first row in the
% double arrays is NSpike timestamp and the second
% row in the double array is the value of the joint
% angle for M total samples.  
%
% *OR* just a NxM double array
%
% outfile: full path to ASCII outfile
%
% recs: (optional) dump only first n records
%
% Output:
%
% Comma delimited textfile.  First line contains
% joint names, following lines are frames.
%
% BUGS: Handling of NaNs
%
function dump_joint_angles(names, angles, outfile, recs)
fid = fopen(outfile, 'W');

if nargin < 4
	recs = inf;
end

if iscell(angles)
	for iJoint = 1:length(angles)
		angles_fixed(iJoint, :) = angles{iJoint}(2,:);
	end
else
	angles_fixed = angles;
end

if length(names) ~= size(angles_fixed,1)
	error('joint names <-> data mismatch');
end

% write out the header
%
for i=1:length(names) - 1
	fwrite(fid, [names{i} ',']);
end

% ASCII code 10 is '\n'
fwrite(fid, [names{i+1} 10]);

for iFrame=1:min(length(angles_fixed), recs)
	fprintf(fid, '%f,', angles_fixed(1:end-1,iFrame));
	fprintf(fid, '%f\n', angles_fixed(end,iFrame));
end

fclose(fid);

