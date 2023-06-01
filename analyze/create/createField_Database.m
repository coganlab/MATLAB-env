function createField_Database
%
%  createField_Database
%
%  Appends Field Sessions to existing Field_Database.m 
%	based on Field_Database_working.m and Movement_Database.mat
%	or creates new Field_Database.m
%  LEGACY

global MONKEYDIR MONKEYNAME

Session = Field_Database_working;
%Session=Field_Database

if ~exist([MONKEYDIR '/m/Field_Database.m'])
    fid = fopen([MONKEYDIR '/m/Field_Database.m'],'w');
    
    fwrite(fid,'function Session = Field_Database;','char'); fprintf(fid,'\n\n');
    fwrite(fid,['% ' MONKEYNAME ' field database.']); fprintf(fid,'\n\n');
    fwrite(fid,['ind=1;']); fprintf(fid,'\n');
    fwrite(fid,'Session = {};'); fprintf(fid,'\n');
    ind = 1;
else
    fid = fopen([MONKEYDIR '/m/Field_Database.m'],'a');
    ind = length(loadField_Database)+1;
end

for sid=1:length(Session)
  Sess = Session{sid};
  day = sessDay(Sess);
  recs = sessRec(Sess);
  sys = sessTower(Sess);
  ch = sessElectrode(Sess);
  contact = sessContact(Sess);
%   depthRange = Sess{5};

  sysString = [];
  for s=1:length(sys)
    if s>1
      sysString= [ sysString ',' ];
    end
    sysString = [ sysString '''' sys{s} '''' ];
  end
    
  recString = [];
  for r=1:length(recs)
    if r>1
      recString= [ recString ',' ];
    end
    recString = [ recString '''' recs{r} '''' ];
  end
  
%   [depths, dDays, dRecs] = getSemiChronicChannelDepth(MSession,1,day);
  [depths, dDays, dRecs] = getSemiChronicChannelDepth({Sess});
  
  loc = find(ismember(dDays,day)&ismember(dRecs,recs{end}));
  depths = depths(loc,:);
  
   for ch=1:32
    fwrite(fid,['Session{ind} = {''' day ''',{' recString '},{' sysString '},{' num2str(ch) ',1},{[' num2str(depths(ch)) ',1]},ind}; ind = ind+1; % ' num2str(ind)]);
    fprintf(fid,'\n');
    ind = ind+1;
  end
  fprintf(fid,'\n');
end

fclose(fid);

saveField_Database;
