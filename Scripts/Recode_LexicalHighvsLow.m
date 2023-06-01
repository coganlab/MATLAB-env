%1 = decision
%2 = repetition

OrderIDX=[1,2];
for iOrder=1:2
    Order=OrderIDX(iOrder);
    if Order==2
        Offset2=4;
    elseif Order==1
        Offset2=0;
    end
    for iTrials=1:168
        iTrials2=iTrials+(iOrder-1)*168;
        if intersect(Trials(iTrials2).StartCode,words_high)
            Trials(iTrials2).StartCode=1+Offset2;
            Trials(iTrials2).AuditoryCode=25+Offset2;
            Trials(iTrials2).DelCode=50+Offset2;
            Trials(iTrials2).GoCode=75+Offset2;
        elseif intersect(Trials(iTrials2).StartCode,words_low)
            Trials(iTrials2).StartCode=2+Offset2;
            Trials(iTrials2).AuditoryCode=26+Offset2;
            Trials(iTrials2).DelCode=51+Offset2;
            Trials(iTrials2).GoCode=76+Offset2;
        elseif intersect(Trials(iTrials2).StartCode,nonwords_high)
            Trials(iTrials2).StartCode=3+Offset2;
            Trials(iTrials2).AuditoryCode=27+Offset2;
            Trials(iTrials2).DelCode=52+Offset2;
            Trials(iTrials2).GoCode=77+Offset2;
        elseif intersect(Trials(iTrials2).StartCode,nonwords_low)
            Trials(iTrials2).StartCode=4+Offset2;
            Trials(iTrials2).AuditoryCode=28+Offset2;
            Trials(iTrials2).DelCode=53+Offset2;
            Trials(iTrials2).GoCode=78+Offset2;
        end
    end
end
        