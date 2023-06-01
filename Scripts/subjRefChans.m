function refChans=subjRefChans(subject)
if strcmp(subject,'D8');
%     % within single depth
%     for iCh=1:110
%         refChans{iCh}=floor((iCh-1)/10)*10+1:floor((iCh-1)/10)*10+10;
%     end
    
    
    % Laplace
    counter=0;
    for iChOuter=0:10
        idxOuter1=1:10;
        idxOuter2=idxOuter1+iChOuter*10;
        for iChInner=1:length(idxOuter1)
            if idxOuter1(iChInner)==1
                refChans{counter+1}=counter+2;
                counter=counter+1;
            elseif idxOuter1(iChInner)==10
                refChans{counter+1}=counter;
                counter=counter+1;
            else
                refChans{counter+1}=[counter,counter+2];
                counter=counter+1;
            end
        end
    end
    

elseif strcmp(subject,'D12');
%     % within single depth
%     for iCh=1:110
%         refChans{iCh}=floor((iCh-1)/10)*10+1:floor((iCh-1)/10)*10+10;
%     end
    
    
    % Laplace
    counter=0;
    for iChOuter=0:10
        idxOuter1=1:10;
        idxOuter2=idxOuter1+iChOuter*10;
        for iChInner=1:length(idxOuter1)
            if idxOuter1(iChInner)==1
                refChans{counter+1}=counter+2;
                counter=counter+1;
            elseif idxOuter1(iChInner)==10
                refChans{counter+1}=counter;
                counter=counter+1;
            else
                refChans{counter+1}=[counter,counter+2];
                counter=counter+1;
            end
        end
    end
    
% % linear model
% load([DUKEDIR '\' subject '\' subject '_w.mat']);

elseif strcmp(subject,'D13');
%     % within single depth
%     for iCh=1:120
%         refChans{iCh}=floor((iCh-1)/10)*10+1:floor((iCh-1)/10)*10+10;
%     end
    
    % Laplace
    counter=0;
    for iChOuter=0:11
        idxOuter1=1:10;
        idxOuter2=idxOuter1+iChOuter*10;
        for iChInner=1:length(idxOuter1)
            if idxOuter1(iChInner)==1
                refChans{counter+1}=counter+2;
                counter=counter+1;
            elseif idxOuter1(iChInner)==10
                refChans{counter+1}=counter;
                counter=counter+1;
            else
                refChans{counter+1}=[counter,counter+2];
                counter=counter+1;
            end
        end
    end
    
    
elseif strcmp(subject,'D14');
%     % within single depth
%     for iCh=1:120
%         refChans{iCh}=floor((iCh-1)/10)*10+1:floor((iCh-1)/10)*10+10;
%     end
    
    
    % Laplace
    counter=0;
    for iChOuter=0:11
        idxOuter1=1:10;
        idxOuter2=idxOuter1+iChOuter*10;
        for iChInner=1:length(idxOuter1)
            if idxOuter1(iChInner)==1
                refChans{counter+1}=counter+2;
                counter=counter+1;
            elseif idxOuter1(iChInner)==10
                refChans{counter+1}=counter;
                counter=counter+1;
            else
                refChans{counter+1}=[counter,counter+2];
                counter=counter+1;
            end
        end
    end
    
elseif strcmp(subject,'D15')
%     % within single depth
%     for iCh=1:120
%         refChans{iCh}=floor((iCh-1)/10)*10+1:floor((iCh-1)/10)*10+10;
%     end
%     
    
    % Laplace
    counter=0;
    for iChOuter=0:11
        idxOuter1=1:10;
        idxOuter2=idxOuter1+iChOuter*10;
        for iChInner=1:length(idxOuter1)
            if idxOuter1(iChInner)==1
                refChans{counter+1}=counter+2;
                counter=counter+1;
            elseif idxOuter1(iChInner)==10
                refChans{counter+1}=counter;
                counter=counter+1;
            else
                refChans{counter+1}=[counter,counter+2];
                counter=counter+1;
            end
        end
    end
    
    
elseif strcmp(subject,'D16');
    for iCh=1:41;
        refChans{iCh}=1:41;
    end
    
elseif strcmp(subject,'D17')
%     % within single depth
%     for iCh=1:12;
%         refChans{iCh}=1:12;
%     end
%     for iCh=13:20;
%         refChans{iCh}=13:20;
%     end
%     for iCh=21:28
%         refChans{iCh}=21:28;
%     end
%     for iCh=29:36
%         refChans{iCh}=29:36;
%     end
%     for iCh=37:46
%         refChans{iCh}=37:46;
%     end
%     for iCh=47:54
%         refChans{iCh}=47:54;
%     end
%     for iCh=55:66
%         refChans{iCh}=55:66;
%     end
%     for iCh=67:76
%         refChans{iCh}=67:76;
%     end
%     for iCh=77:84
%         refChans{iCh}=77:84;
%     end
%     for iCh=85:94
%         refChans{iCh}=85:94;
%     end
%     for iCh=95:104
%         refChans{iCh}=95:104;
%     end
%     for iCh=105:114;
%         refChans{iCh}=105:114;
%     end
    
    % Laplace
    for iCh=1:12;
        if iCh==1
            refChans{iCh}=iCh+1;
        elseif iCh==12
            refChans{iCh}=iCh-1;
        else
            refChans{iCh}=[iCh-1 iCh+1];
        end
    end
    
    for iCh=13:20;
        if iCh==13
            refChans{iCh}=iCh+1;
        elseif iCh==20
            refChans{iCh}=iCh-1;
        else
            refChans{iCh}=[iCh-1 iCh+1];
        end
    end
    for iCh=21:28
        if iCh==21
            refChans{iCh}=iCh+1;
        elseif iCh==28
            refChans{iCh}=iCh-1;
        else
            refChans{iCh}=[iCh-1 iCh+1];
        end
    end
    for iCh=29:36
        if iCh==29
            refChans{iCh}=iCh+1;
        elseif iCh==36
            refChans{iCh}=iCh-1;
        else
            refChans{iCh}=[iCh-1 iCh+1];
        end
    end
    for iCh=37:46
        if iCh==37
            refChans{iCh}=iCh+1;
        elseif iCh==46
            refChans{iCh}=iCh-1;
        else
            refChans{iCh}=[iCh-1 iCh+1];
        end
    end
    for iCh=47:54
        if iCh==47
            refChans{iCh}=iCh+1;
        elseif iCh==54
            refChans{iCh}=iCh-1;
        else
            refChans{iCh}=[iCh-1 iCh+1];
        end
    end
    for iCh=55:66
        if iCh==55
            refChans{iCh}=iCh+1;
        elseif iCh==66
            refChans{iCh}=iCh-1;
        else
            refChans{iCh}=[iCh-1 iCh+1];
        end
    end
    for iCh=67:76
        if iCh==67
            refChans{iCh}=iCh+1;
        elseif iCh==76
            refChans{iCh}=iCh-1;
        else
            refChans{iCh}=[iCh-1 iCh+1];
        end
    end
    for iCh=77:84
        if iCh==77
            refChans{iCh}=iCh+1;
        elseif iCh==84
            refChans{iCh}=iCh-1;
        else
            refChans{iCh}=[iCh-1 iCh+1];
        end
    end
    for iCh=85:94
        if iCh==85
            refChans{iCh}=iCh+1;
        elseif iCh==94
            refChans{iCh}=iCh-1;
        else
            refChans{iCh}=[iCh-1 iCh+1];
        end
    end
    for iCh=95:104
        if iCh==95
            refChans{iCh}=iCh+1;
        elseif iCh==104
            refChans{iCh}=iCh-1;
        else
            refChans{iCh}=[iCh-1 iCh+1];
        end
    end
    for iCh=105:114;
        if iCh==105
            refChans{iCh}=iCh+1;
        elseif iCh==114
            refChans{iCh}=iCh-1;
        else
            refChans{iCh}=[iCh-1 iCh+1];
        end
    end
elseif strcmp(subject,'D20')
%     % within single depth
%     for iCh=1:120
%         refChans{iCh}=floor((iCh-1)/10)*10+1:floor((iCh-1)/10)*10+10;
%     end
%     
    % Laplace
    counter=0;
    for iChOuter=0:11
        idxOuter1=1:10;
        idxOuter2=idxOuter1+iChOuter*10;
        for iChInner=1:length(idxOuter1)
            if idxOuter1(iChInner)==1
                refChans{counter+1}=counter+2;
                counter=counter+1;
            elseif idxOuter1(iChInner)==10
                refChans{counter+1}=counter;
                counter=counter+1;
            else
                refChans{counter+1}=[counter,counter+2];
                counter=counter+1;
            end
        end
    end
elseif strcmp(subject,'D22')
      counter=0;
    for iChOuter=0:9
        idxOuter1=1:10;
        idxOuter2=idxOuter1+iChOuter*10;
        for iChInner=1:length(idxOuter1)
            if idxOuter1(iChInner)==1
                refChans{counter+1}=counter+2;
                counter=counter+1;
            elseif idxOuter1(iChInner)==10
                refChans{counter+1}=counter;
                counter=counter+1;
            else
                refChans{counter+1}=[counter,counter+2];
                counter=counter+1;
            end
        end
    end
 elseif strcmp(subject,'D23')
    for iCh=1:16;
        if iCh==1
            refChans{iCh}=iCh+1;
        elseif iCh==16
            refChans{iCh}=iCh-1;
        else
            refChans{iCh}=[iCh-1 iCh+1];
        end
    end
     for iCh=17:28;
        if iCh==17
            refChans{iCh}=iCh+1;
        elseif iCh==28
            refChans{iCh}=iCh-1;
        else
            refChans{iCh}=[iCh-1 iCh+1];
        end
     end
     for iCh=29:42;
        if iCh==29
            refChans{iCh}=iCh+1;
        elseif iCh==42
            refChans{iCh}=iCh-1;
        else
            refChans{iCh}=[iCh-1 iCh+1];
        end
     end
     for iCh=43:49;
        if iCh==43
            refChans{iCh}=iCh+1;
        elseif iCh==49
            refChans{iCh}=iCh-1;
        else
            refChans{iCh}=[iCh-1 iCh+1];
        end
     end
     for iCh=50:60;
        if iCh==50
            refChans{iCh}=iCh+1;
        elseif iCh==60
            refChans{iCh}=iCh-1;
        else
            refChans{iCh}=[iCh-1 iCh+1];
        end
     end
     for iCh=61:76;
        if iCh==61
            refChans{iCh}=iCh+1;
        elseif iCh==76
            refChans{iCh}=iCh-1;
        else
            refChans{iCh}=[iCh-1 iCh+1];
        end
     end
     for iCh=77:92;
        if iCh==77
            refChans{iCh}=iCh+1;
        elseif iCh==92
            refChans{iCh}=iCh-1;
        else
            refChans{iCh}=[iCh-1 iCh+1];
        end
     end
     for iCh=93:101;
        if iCh==93
            refChans{iCh}=iCh+1;
        elseif iCh==101
            refChans{iCh}=iCh-1;
        else
            refChans{iCh}=[iCh-1 iCh+1];
        end
     end
     for iCh=102:111;
        if iCh==102
            refChans{iCh}=iCh+1;
        elseif iCh==111
            refChans{iCh}=iCh-1;
        else
            refChans{iCh}=[iCh-1 iCh+1];
        end
     end
     for iCh=112:121;
        if iCh==112
            refChans{iCh}=iCh+1;
        elseif iCh==121
            refChans{iCh}=iCh-1;
        else
            refChans{iCh}=[iCh-1 iCh+1];
        end
    end
end




