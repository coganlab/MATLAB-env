function Depth = sessMocapDepth(Session, Tower)
%
%  Depth = sessMocapDepth(Session, Tower)
%


Field_Session = loadField_Database;
FieldTower = sessTower(Field_Session);
FieldDay = sessDay(Field_Session);
Day = sessDay(Session);
ind = find(ismember(FieldTower,Tower)' & ismember(FieldDay,Day));
% tmp = Field_Session(ind);
%  tmp{1}
%  tmp{1}{5}{1}
%  tmp{2}{5}{1}
Depth = sessDepth(Field_Session(ind));


