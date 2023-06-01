function ev = procGraspEvents(day, rec)
%  If no vizard events file exists, create a trial structure for the grasp
%  times
%
%  PROCGRASPEVENTS(DAY, REC)
%
%  Inputs:  DAY    = String '030603'
%           REC    = String '001', or num [1,2]




global MONKEYDIR
STROBE_THRESHOLD = 1e4;

olddir = pwd;

recs = dayrecs(day);
nRecs = length(recs);

if nargin < 2
    num = [1,nRecs];
elseif ischar(rec)
    num = [find(strcmp(recs,rec)),find(strcmp(recs,rec))];
elseif length(rec)==1
    num = [rec,rec];
elseif length(rec)==2
    num = rec;
end
for iNum = num(1):num(2)
    rec = recs{iNum};
    cd([MONKEYDIR '/' day '/' recs{iNum}]);
    if(isfile(['rec' recs{iNum} '.experiment.mat']))
        load(['rec' recs{iNum} '.experiment.mat']);
        sampling_rate = experiment.hardware.acquisition(1).samplingrate;
        format = experiment.hardware.acquisition(1).data_format;
        if(isfile(['rec' recs{iNum} '.Body.Marker.mat']))
            load(['rec' recs{iNum} '.Body.Marker.mat']);
            load(['rec' recs{iNum} '.Body.marker_names.mat']);
            ind = find(strcmp('R.Hand',marker_names));
            %define movements based on hand marker y-dim
            marker = Marker{8}(3,:);
            [reach_start, reach_stop] = findGrasp(marker);
            behavior.reachStart = reach_start*10;
            behavior.reachStop = reach_stop*10;
            save(['rec' recs{iNum} '.GraspBehavior.mat'], 'behavior');
        end
    end
end



