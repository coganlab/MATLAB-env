function saveMultiunit_Database
%
%  saveMultiunit_Database
%

global MONKEYDIR

Session = loadMultiunit_Database;
for iSess = 1:length(Session)
    if length(Session{iSess})==6
        Session{iSess}{7} = MONKEYDIR;
        Session{iSess}{8} = {'Multiunit'};
    elseif ~ismember(Session{iSess}{7},'/')
        Session{iSess}{7} = MONKEYDIR;
    end
end

save([MONKEYDIR '/mat/Multiunit_Session.mat'],'Session');
