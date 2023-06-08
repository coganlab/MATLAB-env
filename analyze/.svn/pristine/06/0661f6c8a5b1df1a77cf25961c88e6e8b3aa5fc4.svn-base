function [Area1,Area2] = getBSArea_SpikeSpike(Session)
%
%  [Area1,Area2] = getBSArea_SpikeSpike(Session)
%

Tower1 = Session{3}{1};
Tower2 = Session{3}{2};
SpikeCh1 =  Session{4}(1);
SpikeCh2 =  Session{4}(2);
Cl1 = Session{5}{1};
Cl2 = Session{5}{2};
Sess_num1 = Session{6}(1);
Sess_num2 = Session{6}(2);
day = Session{1};
rec = Session{2};

Session1 = {day,rec,Tower1,SpikeCh1,Cl1,Sess_num1,Session{7},Session{8}};
Session2 = {day,rec,Tower2,SpikeCh2,Cl2,Sess_num2,Session{7},Session{8}};


for iLoop = 1:2
    if(iLoop == 1)
        Session = Session1;
        Tower = Tower1;
        SpikeCh = SpikeCh1;
    else
        Session = Session2;
        Tower = Tower2;
        SpikeCh = SpikeCh2;
    end
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
    if(iLoop == 1)
        Area1 = Area;
    else
        Area2 = Area;
    end
end