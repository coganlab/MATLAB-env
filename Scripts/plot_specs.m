function plot_specs(nSpec,conds,fvals,cvals,noTicks)
if nargin<2
    conds=1:size(nSpec,1);
end

if nargin<3
    fvals=1:200;
end

if nargin<4
    cvals=[0.7 1.5];
end

if nargin<4
   titleVal=0;
end

numChan=size(nSpec,2);

basechans=60;

ifMax=ceil(numChan/basechans)-1;
chanRem=numChan-ifMax*basechans;
counter=0;
for iF=0:ifMax
    if iF<ifMax
        chanMax=basechans;
    elseif iF==ifMax
        chanMax=chanRem;
    end
    figure;
    for iChan=1:chanMax
        subplot(6,10,iChan)
        tvimage(sq(mean(nSpec(conds,counter+1,:,fvals))));
        caxis(cvals);
        if noTicks==1
            set(gca,'YTickLabel',[]);
            set(gca,'XTickLabel',[]);
        end
        counter=counter+1;
    end
end
