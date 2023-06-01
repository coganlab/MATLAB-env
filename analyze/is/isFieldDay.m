function flag = isFieldDay(day, tower, ch, FieldSession)
%
%  flag = isFieldDay(day, tower, ch, FieldSession)
%

if nargin < 4 FieldSession = loadField_Database; end

FieldDays = sessDay(FieldSession);
FieldChannels = sessChannel(FieldSession);
FieldTowers = sessTower(FieldSession);

flag = 0;
if ~isempty(find(strcmp(FieldDays, day))) 
  DayInd = find(strcmp(FieldDays,day));
  if ~isempty(find(strcmp(FieldTowers(DayInd), tower)))
    TowerInd = find(strcmp(FieldTowers(DayInd), tower));
    if ~isempty(find(intersect(FieldChannels(DayInd(TowerInd)),ch)))
      flag = 1;
    end
  end
end
