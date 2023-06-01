
cutoff=2e4

newtrigs1=zeros(1,length(triggerdata));

    tt1=find(triggerdata>cutoff);
    newtrigs1(tt1)=1;
newtrigs3=diff(newtrigs1);
newtrigs4=find(newtrigs3>0);


    
