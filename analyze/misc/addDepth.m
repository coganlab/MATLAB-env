function addDepth(day,rec,depth)

% ADDDEPTH(day,rec,depth)
%
%   Inputs:	
%           day = String. Recording day
%           rec = String. Recording number
%           depth = Vector. Numerical vestor with a float for each
%           electrode depth in microns.
%
% Modifies the electrode log file to add correct depths of the electrodes 
% timestamped to the beginning and end of the recording 


global MONKEYDIR

load([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat']);
load([MONKEYDIR '/' day '/' rec '/rec' rec '.Events.mat']);


if(isfile([MONKEYDIR '/' day '/' rec '/rec' rec '.electrodelog.txt']))

    %set the initial start and stop time of the recording
    depths(1,:) = [Events.StartOn(1),depth];
    depths(2,:) = [Events.StartOn(end),depth];
    dlmwrite([MONKEYDIR '/' day '/' rec '/rec' rec '.electrodelog.txt'], depths, 'delimiter', ' ');
        
else
    disp('Electrode log file not found');
end





