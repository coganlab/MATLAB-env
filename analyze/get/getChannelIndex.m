function ChannelIndex = getChannelIndex(Trials, Sys, Electrode, Contacts)
%  Returns the index of the channels for the Electrode and Contacts in a 
%  recording file, Sys.
%
%  ChannelIndex = getChannelIndex(Trials, Sys, Electrode, Contacts)
%
if nargin < 3 || isempty(Electrode); Electrode = []; end
if nargin < 4 || isempty(Contacts); Contacts = []; end

ChannelIndex = 0;
Microdrive = find(ismember(Trials(1).MT,Sys));
if iscell(Contacts)
  Contacts = Contacts{1};
end

if ~isempty(Electrode)
  if isfield(Trials,'NumContacts')
    for iElectrode = 1:Electrode-1
      ChannelIndex = ChannelIndex + Trials(1).NumContacts(Microdrive).Electrode(iElectrode);
    end
    NumContacts = Trials(1).NumContacts(Microdrive).Electrode(Electrode);
    if nargin < 4 || isempty(Contacts); Contacts = 1:NumContacts; end
    ChannelIndex = ChannelIndex + Contacts;
    ChannelIndex = Electrode; %hack to make work 
  else
    %disp('No NumContacts field')
    ChannelIndex = Electrode;
  end
else
  NumChannels = 0;
  NumElectrodes = Trials(1).Ch(Microdrive);
  for iElectrode = 1:NumElectrodes
    if isfield(Trials,'NumContacts')
      NumContacts = Trials(1).NumContacts(Microdrive).Electrode(iElectrode);
    else
      NumContacts = 1;
    end
    NumChannels = NumChannels + NumContacts;
  end
  ChannelIndex = 1:NumChannels;
end
