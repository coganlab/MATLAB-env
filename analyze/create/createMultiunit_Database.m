function createMultiunit_Database
%
% createMultiunit_Database
%

% Run GenerateMultiunitPk.m prior to this script!

global MONKEYDIR MONKEYNAME

if ~exist([MONKEYDIR '/m/Multiunit_Database.m'],'file')
    fid = fopen([MONKEYDIR '/m/Multiunit_Database.m'], 'w');
    
    fwrite(fid,'function Session = Multiunit_Database;','char'); fprintf(fid,'\n\n');
    fwrite(fid,['% ' MONKEYNAME ' multiunit database.']); fprintf(fid,'\n\n');
    fwrite(fid,['Session = {};']); fprintf(fid,'\n\n');
    fwrite(fid,['ind = 1']); fprintf(fid,'\n\n');
    fclose(fid);
    Session = {}; save([MONKEYDIR '/mat/Multiunit_Session.mat'],'Session');
else
    saveMultiunit_Database;
end

Session = loadField_Database;
for sid = 1:length(Session)
    Session{1}
  addMultiunitDatabaseTextFromField(Session{sid});
end

saveMultiunit_Database;
