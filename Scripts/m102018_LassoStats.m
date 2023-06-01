idx1=intersect(iiA2,supramIdx);
ta = linspace(-0.5, 1.5, 40);

semplot(sq(mdlBvals(idx1,:,2)),sq(mdlBvals(idx1,:,3)),ta)
hold on;plot(ta,zeros(40,1),'k--');

axis('square')
xticks([-0.5 0 0.5 1 1.5])
yticks([-0.5 0 0.7])
ylim([-0.5 0.7])
set(gca,'linewidth',3)
set(gca,'xticklabel',{[]}) 
set(gca,'yticklabel',{[]})

nPerm=10000;
clear permVals
    bpam=2;
    for iTime=1:40;
         actVal=abs(mean(mdlBvals(idx1,iTime,bpam))-mean(mean(mdlBvals(idx1,1:10,bpam))));
         combVal=cat(1,sq(mdlBvals(idx1,iTime,bpam)),sq(mean(mdlBvals(idx1,1:10,bpam),2)));
        for iPerm=1:nPerm;
            sIdx=shuffle(1:length(combVal));
            permVals(iPerm)=abs(mean(combVal(sIdx(1:length(idx1))))-mean(combVal(sIdx(length(idx1)+1:end))));
        end
        pIdx(iTime)=length(find(permVals>(actVal)))./nPerm;
        display(iTime)
    end

    figure;
    plot(ta,-log(pIdx))
    hold on;
    plot(ta,-log(0.05)*ones(40,1),'k--')
    
    %%
 idx1=intersect(iiP2,supramIdx);

 tm = linspace(-1, 1, 40);
  
%   semplot(Tvlas(idx1,:,3), Tvals(idx,:,5), ta);
  semplot(sq(mdlBvalsP(idx1,:,2)),sq(mdlBvalsP(idx1,:,3)),tm)
hold on;plot(tm,zeros(40,1),'k--');

axis('square')
xticks([-0.5 0 0.5 1 1.5])
yticks([-0.5 0 0.7])
ylim([-0.5 0.7])
set(gca,'linewidth',3)
set(gca,'xticklabel',{[]}) 
set(gca,'yticklabel',{[]})

nPerm=10000;
clear permVals
    bpam=2;
    for iTime=1:40;
         %actVal=abs(mean(LassoVals(idx1,iTime,bpam))-mean(mean(LassoVals(idx1,1:5,bpam))));
         %combVal=cat(1,sq(LassoVals(idx1,iTime,bpam)),sq(mean(LassoVals(idx1,1:5,bpam),2)));
         actVal=abs(mean(mdlBvalsP(idx1,iTime,bpam))-mean(mean(mdlBvalsP(idx1,1:10,bpam))));
         combVal=cat(1,sq(mdlBvalsP(idx1,iTime,bpam)),sq(mean(mdlBvalsP(idx1,1:10,bpam),2)));
%         actVal=mean(LassoVals(idx1,iTime,bpam))-0;
%        combVal=cat(1,sq(LassoVals(idx1,iTime,bpam)),zeros(length(idx1),1));
        for iPerm=1:nPerm;
            sIdx=shuffle(1:length(combVal));
            permVals(iPerm)=abs(mean(combVal(sIdx(1:length(idx1))))-mean(combVal(sIdx(length(idx1)+1:end))));
        end
        pIdx(iTime)=length(find(permVals>(actVal)))./nPerm;
        display(iTime)
    end

    figure;
    plot(tm,-log(pIdx))
    hold on;
    plot(tm,-log(0.05)*ones(40,1),'k--')
%     figure;
%     plot(-log(pIdx))
%     hold on;
%     plot(-log(0.025)*ones(40,1),'k--')   
    
    
    
%idx1=intersect(iiP2,temporalIdx);
idx1=intersect(iiP2,elecLoc{34});
figure;
errorbar(sq(mean(TvalsP(idx1,:,3))),std(sq(TvalsP(idx1,:,3)),[],1)./sqrt(length(idx1)));
hold on
errorbar(sq(mean(TvalsP(idx1,:,5))),std(sq(TvalsP(idx1,:,5)),[],1)./sqrt(length(idx1)));
hold on
errorbar(sq(mean(TvalsP(idx1,:,7))),std(sq(TvalsP(idx1,:,7)),[],1)./sqrt(length(idx1)));
hold on;
plot(zeros(40,1),'k--')


 %   idx1=intersect(iiP,precentralIdx);
    bpam=5;
    for iTime=1:40;
        actVal=abs(mean(TvalsP(idx1,iTime,bpam))-mean(mean(Tvals(idx1,1:10,bpam))));
        combVal=cat(1,sq(TvalsP(idx1,iTime,bpam)),sq(mean(Tvals(idx1,1:10,bpam),2)));
    %     actVal=mean(LassoValsP(idx1,iTime,bpam))-0;
    %    combVal=cat(1,sq(LassoValsP(idx1,iTime,bpam)),zeros(length(idx1),1));
        for iPerm=1:10000;
            sIdx=shuffle(1:length(combVal));
            permVals(iPerm)=abs(mean(combVal(sIdx(1:length(idx1))))-mean(combVal(sIdx(length(idx1)+1:end))));
        end
        pIdx(iTime)=length(find(permVals<(actVal)))./1000;
        display(iTime)
    end

    figure;
    plot(-log(1-pIdx))
    hold on;
    plot(-log(0.05)*ones(40,1),'k--')
%     figure;
%     plot(-log(pIdx))
%     hold on;
%     plot(-log(0.025)*ones(40,1),'k--')