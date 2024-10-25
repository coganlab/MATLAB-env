function splitSptoChannels(day,rec,tower)
%
%
%

global MONKEYDIR

if nargin == 1
  recs = dayrecs(day);
  towers = daytowers(day);
end
if nargin == 2
  towers = daytowers(day);
  recs{1} = rec;
end
if nargin == 3
  towers{1} = tower;
  recs{1} = rec;
end

for iRec = 1:length(recs)
  for iTower = 1:length(towers);
    rec = recs{iRec};
    tower = towers{iTower};
    filename=[MONKEYDIR '/' day '/' rec '/rec' rec '.' tower '.sp.mat'];
    load(filename);
    nCh = length(sp);
    totalsp = sp;
    clear sp
    for iCh = 1:nCh
      sp = totalsp{iCh};
      filename=[MONKEYDIR '/' day '/' rec '/rec' rec '.' tower '.' num2str(iCh) '.sp.mat'];
      save(filename,'sp','-v7.3');
    end
  end
end
