function saveField_Database
%
%  saveField_Database
%
%  For backwards compatibility

global MONKEYDIR 

Session = loadField_Database;
for iSess = 1:length(Session)
    if length(Session{iSess})==6
        Session{iSess}{7} = MONKEYDIR;
        Session{iSess}{8} = {'Field'};
    elseif ~ismember(Session{iSess}{7},'/')
        Session{iSess}{7} = MONKEYDIR;
    end
end
save([MONKEYDIR '/mat/Field_Session.mat'],'Session');
