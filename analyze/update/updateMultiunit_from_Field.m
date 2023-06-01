function updateMultiunit_from_Field(DayList)
%  Update Multiunit database so it mirrors LFP database
%
%  updateMultiunit_from_Field(DayList)
%
%  INPUTS:  DAYLIST = Cell array of strings.  List of Days to process.
%		ie {'091023'};
%

global MONKEYDIR

MINTRIALS = 50;
FieldSession = loadField_Database;

Days = sessDay(FieldSession);
Towers = sessTower(FieldSession);
Channels = sessChannel(FieldSession);

if nargin < 1; DayList = unique(Days); end
if ~iscell(DayList); DayList = {DayList}; end

SessInd = [];
for iDay = 1:length(DayList);
  SessInd = [SessInd find(ismember(Days,DayList{iDay}))];
end

Days = Days(SessInd);
Towers = Towers(SessInd);
Channels = Channels(SessInd);


for iDay = 1:length(DayList)
  flag = 1;
  currentday = DayList{iDay}
  DayInd = find(strcmp(Days, currentday));
  DayTowers = Towers(DayInd);
  DayTowerList = unique(DayTowers);
  
  load([MONKEYDIR '/' currentday '/mat/Trials.mat']);
  TrialRecs = getRec(Trials);

  Recs = dayrecs(currentday);
  for iRecs = 1:length(Recs)
    currentrec = Recs{iRecs};
    if sum(strcmp(TrialRecs, currentrec)) > MINTRIALS
      for iTower = 1:length(DayTowerList)
        currenttower = DayTowerList{iTower};
        TowerInd = find(strcmp(DayTowers, currenttower));
        DayTowerChannels = Channels(DayInd(TowerInd));
        DayTowerChannelList = unique(DayTowerChannels);

        for iChannel = 1:length(DayTowerChannelList)
          currentchannel = DayTowerChannelList(iChannel);
          %currentday currentrec currenttower currentchannel
     	  tmpflag = procMultiunit(currentday, currentrec, currenttower, currentchannel); 
	  flag = flag * ~tmpflag;
        end
      end
    end
  end
  if ~flag  %  flag becomes 0 if iso file changes.
    disp(['......  Database changed']);
    saveTrials(currentday);
  end
end
