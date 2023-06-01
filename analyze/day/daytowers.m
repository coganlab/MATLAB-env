function towers = daytowers(day)
%
%  towers = daytowers(day)
%

global MONKEYDIR

recs = dayrecs(day);

load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat']);

nTower = numel(experiment.hardware.microdrive);
towers = cell(1,nTower);
for iTower = 1:nTower
	towers{iTower} = experiment.hardware.microdrive(iTower).name;
end
