function procMultiunit_Database(day)
%
% procMultiunit_Database(day)
%
%  Appends Multiunit sessions based on Field_Database
%  Must run procField_Database in advance

%saveField_Database

global MONKEYDIR MONKEYNAME
% 
% if ~exist([MONKEYDIR '/m/Multiunit_Database.m'],'file')
%     fid = fopen([MONKEYDIR '/m/Multiunit_Database.m'], 'w');
%     
%     fwrite(fid,'function Session = Multiunit_Database;','char'); fprintf(fid,'\n\n');
%     fwrite(fid,['% ' MONKEYNAME ' multiunit database.']); fprintf(fid,'\n\n');
%     fwrite(fid,['Session = {};']); fprintf(fid,'\n\n');
%     fwrite(fid,['ind = 1']); fprintf(fid,'\n\n');
%     fclose(fid);
%     Session = {}; save([MONKEYDIR '/mat/Multiunit_Session.mat'],'Session');
% else
%     saveMultiunit_Database;
% end

Session = loadField_Database;
FieldDay = sessDay(Session);
DayInd = find(strcmp(FieldDay,day));

for iSession = 1:length(DayInd)
  addMultiunitDatabaseMatFromField(Session{DayInd(iSession)});
end

