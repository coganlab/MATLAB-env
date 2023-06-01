function Area = getBSArea_Spike(Session)
%
%  Area = getBSArea_Spike(Session)
%

%Tower = Session{3}{1};
Tower = sessTower(Session);
if iscell(Tower); Tower = Tower{1}; end
if iscell(Tower); Tower = Tower{1}; end
%SpikeCh = Session{4};
SpikeCh = sessChannel(Session);
if iscell(SpikeCh); SpikeCh = SpikeCh{1}(1); end
if iscell(SpikeCh); SpikeCh = SpikeCh{1}; end

FSessions = StoF(Session, Tower);
Ch = zeros(1,length(FSessions));
for iSess = 1:length(FSessions)
  Ch(iSess) = FSessions{iSess}{4};
end

FSession = FSessions(Ch == SpikeCh);

if ~isempty(FSession)
  Area = getBSArea_Field(FSession{1});
else
  Area = 'Unlabelled';
end
