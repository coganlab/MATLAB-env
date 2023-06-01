function NumChannels = getSysNumChannels(day, sys, MonkeyDir)
%
%  NumChannels = getSysNumChannels(day, sys, MonkeyDir)
%

NumChannels = [];
recs = dayrecs(day, MonkeyDir); rec = recs{1};
load([MonkeyDir '/' day '/' rec '/rec' rec '.experiment.mat']);
for iSys = 1:length(experiment.hardware.microdrive)
    if strcmp(experiment.hardware.microdrive(iSys).name,sys)
        NumElectrodes = length(experiment.hardware.microdrive(iSys).electrodes);
	NumChannels = 0;
        for iElectrode = 1:NumElectrodes
          tmp = experiment.hardware.microdrive(iSys).electrodes(iElectrode);
	  if isfield(tmp,'numcontacts')
	    NumContacts = experiment.hardware.microdrive(iSys).electrodes(iElectrode).numcontacts;
	  else
	    NumContacts = 1;
	  end
          NumChannels = NumChannels + NumContacts;
	end
    end
end

if isempty(NumChannels) 
    error(['No channels in experiment defn file for ' sys]);
end
