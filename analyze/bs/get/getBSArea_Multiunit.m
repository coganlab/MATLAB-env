function Area = getBSArea_Multiunit(Session)
%
%  Area = getBSArea_Multiunit(Session)
%

Tower = sessTower(Session);
if iscell(Tower); Tower = Tower{1}; end
if iscell(Tower); Tower = Tower{1}; end
MultiunitCh = sessChannel(Session);
if iscell(MultiunitCh); MultiunitCh = MultiunitCh{1}(1); end
if iscell(MultiunitCh); MultiunitCh = MultiunitCh{1}; end

FSessions = MtoF(Session, Tower);
Ch = zeros(1,length(FSessions));
for iSess = 1:length(FSessions)
  Ch(iSess) = FSessions{iSess}{4};
end

FSession = FSessions(Ch == MultiunitCh);

if ~isempty(FSession)
  Area = getBSArea_Field(FSession{1});
else
  Area = 'Unlabelled';
end


% F = MtoF(Session, Session{3}, Session{4});
% if ~isempty(F)
%     Area = sessBSArea_Field(F{1});
%     Area = Area{1}{1};
% else
%     Area = 'Unlabelled';
% end
