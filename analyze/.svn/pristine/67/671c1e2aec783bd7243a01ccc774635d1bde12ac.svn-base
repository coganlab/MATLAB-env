function ChannelIndex = expChannelIndex(experiment, sys, ch, contact)
%
%  ChannelIndex = expChannelIndex(experiment, sys, ch, contact)
%

nMicrodrive= length(experiment.hardware.microdrive);
for iMicrodrive = 1:nMicrodrive
  Name{iMicrodrive} = experiment.hardware.microdrive(iMicrodrive).name;
end

Microdrive = find(strcmp(Name,sys));

if ch == 1
  ChannelIndex = contact;
else
    ChannelIndex = 0;
    for iElectrode = 1:ch-1
        elec = experiment.hardware.microdrive(Microdrive).electrodes(iElectrode);
        if isfield(elec,'numContacts')
            NumContacts = elec.numContacts;
        else
            NumContacts = 1;
        end
        ChannelIndex = ChannelIndex + NumContacts;
    end
    ChannelIndex = ChannelIndex + contact;
end
