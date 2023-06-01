function Session = updateMultiunitMultiunit_Database
%
%  Session = updateMultiunitMultiunit_Database
%  To be used for daily updates of new data.
%  


global MONKEYDIR

Session = cell(0,0); 
MultiunitSessions = loadMultiunit_Database;

NumMultiunit= length(MultiunitSessions);

if isfile([MONKEYDIR '/mat/MultiunitMultiunit_Session.mat']);
    load([MONKEYDIR '/mat/MultiunitMultiunit_Session.mat']);
    for iSess = 1:length(Session)
        NMultiunit(iSess) = Session{iSess}{6}(1);
    end
    StartMultiunit = max(NMultiunit)+1;
else
    StartMultiunit = 1;
end

for iMultiunit1 = StartMultiunit:NumMultiunit
  addMultiunitMultiunit_Database(iMultiunit1,[],Session);
end

updateMultiunitMultiunit_NumTrials;
% updateMultiunitMultiunit_NumTrialsConds;
% updateMultiunitMultiunit_Figs;
