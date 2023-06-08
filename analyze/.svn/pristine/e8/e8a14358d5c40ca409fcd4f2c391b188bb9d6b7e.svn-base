%Init Title Info
divnum = find(ismember(MONKEYNAME,'/'));
mname = MONKEYNAME(1:3);
rectype = MONKEYNAME(divnum+1:end);
if isempty(rectype) && exist('SessionType','var')
    rectype = SessionType;
end
cellnum = Sess{6};


%load([MONKEYDIR '/' Sess{1} '/' Sess{2}{1} '/rec' Sess{2}{1} '.Rec.mat']);
%load([MONKEYDIR '/' Sess{1} '/' Sess{2}{1} '/rec' Sess{2}{1} '.experiment.mat']);
% if strcmp(Rec.MT1,Sess{3}) | strcmp(Rec.MT1(1),Sess{3})
%     systring = 'a';
% elseif strcmp(Rec.MT2,Sess{3}) | strcmp(Rec.MT2(1),Sess{3})
%     systring = 'b';
% end
    
%[Depth,IsoQual] = getSortDataTitInfo(Sess,systring);
IsoQual = 0;
Depth = sessDepth(Sess);
Depth = mean(Depth);