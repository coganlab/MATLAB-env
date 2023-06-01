function [marker_dropout_rate_ave, trial_dropout_rate] = calcMarkerDropOut(Trials, plot_data, markers, MaxReachDuration)
%
% calcMarkerDropOut determines which 3D markers have data
%
%  [marker_dropout_rate_ave, trial_dropout_rate]  = calcMarkerDropOut(Trials, plot_data, markers, MaxReachDuration)
%
%   marker_dropout_rate_ave - Average marker drop out for each marker
%   trial_dropout_rate - MArker dropout for ach marker and each trial.
%
%
%  Trials = Struct
%  plot_data = 0/1, 1 - plots individual data traces defaults to 0
%  markers = marker number/s that the dropout rate is to be
%  calculated for (defaults to all markers that have data)
%  MaxReachDuration = int (maximum reach duration, defaults to 600 ms)

global MONKEYDIR

CAMERA_SAMPLING_RATE = 480;

if nargin < 2
    plot_data = 0;
end

if nargin < 3
    markers = which3DMarkers(Trials);
    disp(['Markers present: ' num2str(markers)]);
else
    disp(['Markers to calculate: ' num2str(markers)]);
end

if nargin < 4
    MaxReachDuration = 600;
end

ReachDuration = [Trials.TargAq] - [Trials.ReachStart];
Trials = Trials(ReachDuration < MaxReachDuration);
ReachDuration = ReachDuration(ReachDuration < MaxReachDuration);
bn_all = [zeros(length(Trials),1)-100 ReachDuration'+100];
bn = [-100,600];
t = [bn(1):bn(2)-1];
marker_dropout_rate_ave = ones(16,1).*-1;
for iMarker = 1:length(markers)
    %figure;
    Hand3D = trialHand3D(Trials,markers(iMarker),'ReachStart',bn);
    [E,Hand] = trialEyeHand(Trials,'ReachStart',bn);
    marker_name = ['Marker' num2str(markers(iMarker))];
    
    for iTr = 1:length(Hand3D)
        end_time_point = bn_all(iTr,2);
        if(plot_data)
            subplot(4,1,1); %hold on;
            plot(t,sq(Hand(iTr,1,:)));
            title(['Marker Number: ' num2str(markers(iMarker)), ' Trial:  ' num2str(iTr)])
            axis([-100, end_time_point, min(sq(Hand(iTr,1,:))), max(sq(Hand(iTr,1,:)))]);
            ylabel('Touch Screen')
            subplot(4,1,2); %hold on;
            if(length(Hand3D{iTr}(2,:) > 0))
                plot(Hand3D{iTr}(1,:)-100,Hand3D{iTr}(2,:),'.');
                axis([-100, end_time_point, min(Hand3D{iTr}(2,:)), max(Hand3D{iTr}(2,:))]);
                title('x-axis');
            end
            if(length(Hand3D{iTr}(3,:) > 0))
                subplot(4,1,3); %hold on;
                plot(Hand3D{iTr}(1,:)-100,Hand3D{iTr}(3,:),'.');
                axis([-100, end_time_point, min(Hand3D{iTr}(3,:)), max(Hand3D{iTr}(3,:))]);
                title('y-axis');
            end
            if(length(Hand3D{iTr}(4,:) > 0))
                subplot(4,1,4); %hold on;
                plot(Hand3D{iTr}(1,:)-100,Hand3D{iTr}(4,:),'.');
                axis([-100, end_time_point, min(Hand3D{iTr}(4,:)), max(Hand3D{iTr}(4,:))]);
                title('z-axis');
            end
            pause
        end
        end_point = min(find(Hand3D{iTr}(1,:) > end_time_point));
        drop_out = 1-length(Hand3D{iTr}(2,1:end_point))/(((end_time_point+100)/1000)*CAMERA_SAMPLING_RATE);
        trial_dropout_rate.(marker_name)(iTr) = drop_out;

    end
    marker_dropout_rate_ave(markers(iMarker)) = mean(trial_dropout_rate.(marker_name));
end