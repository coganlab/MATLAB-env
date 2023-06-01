% recode trials for category
% 1 = decision words
% 2 = decision nonwords
% 3 = repeat words
% 4 = repeat nonwords
for iTrial=1:168
    iTrial2=iTrial;
    if Trials(iTrial2).StartCode<=100
        Trials(iTrial2).StartCode=3;
        Trials(iTrial2).AuditoryCode=28;
        Trials(iTrial2).DelCode=53;
        Trials(iTrial2).GoCode=78;
    elseif Trials(iTrial2).StartCode>100
        Trials(iTrial2).StartCode=4;
        Trials(iTrial2).AuditoryCode=29;
        Trials(iTrial2).DelCode=54;
        Trials(iTrial2).GoCode=79;
    end
    if Trials(iTrial2+168).StartCode<=100
        Trials(iTrial2+168).StartCode=1;
        Trials(iTrial2+168).AuditoryCode=26;
        Trials(iTrial2+168).DelCode=52;
        Trials(iTrial2+168).GoCode=76;
    elseif Trials(iTrial2+168).StartCode>100
        Trials(iTrial2+168).StartCode=2;
        Trials(iTrial2+168).AuditoryCode=27;
        Trials(iTrial2+168).DelCode=53;
        Trials(iTrial2+168).GoCode=77;
    end
end