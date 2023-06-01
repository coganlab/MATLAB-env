function elecRef = findLocalReference(Name,Channels)
% calculates the local reference (i.e. within a single SEEG electrode)
% Name = Subject Name
% Channels = subset of channels that you are using
% Note: Output is in Input Channels space, not experiment Channels space space


% list electrodes from experiment file
elecs=list_electrodes_from_experiment(Name);

% strip number and subject name
for iChan=1:length(Channels)
    elecName=elecs{Channels(iChan)};
    elecName=erase(elecName,[Name '-']);
    ii=find(isletter(elecName));
    elecName=elecName(ii);
    elecNamesStrip{iChan}=elecName;
end

% compute list of electrodes within each depth
counterChan=1;
counterBase=1;
refBase=cell(length(unique(elecNamesStrip)),1);
for iChan=1:length(elecNamesStrip)

    baseComp=elecNamesStrip{counterChan};
    if strcmp(elecNamesStrip{iChan},baseComp)
       refBase{counterBase}=[refBase{counterBase} iChan];
    else 
        counterChan=iChan;
        counterBase=counterBase+1;
    end
end
    
% assign list of electrodes per electrode
elecNamesStripUnique=unique(elecNamesStrip);
for iElec=1:length(elecNamesStripUnique)
    idx=find(contains(elecNamesStrip,elecNamesStripUnique{iElec}));
    for iChan=1:length(idx)
        elecRef{idx(iChan)}=idx;
    end
end
    