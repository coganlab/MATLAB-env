function plotSpecsSave(nSpec,conds,fvals,cvals,noTicks,filenamePath,filename,experiment)
clear title
if nargin<2
    conds=1:size(nSpec,1);
end

if nargin<3
    fvals=1:200;
end

if nargin<4
    cvals=[0.7 1.5];
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
        clear title
        subplot(6,10,iChan)
        tvimage(sq(mean(nSpec(conds,counter+1,:,fvals))));
        title(experiment.channels(counter+1).name);
        caxis(cvals);
        if noTicks==1
            set(gca,'YTickLabel',[]);
            set(gca,'XTickLabel',[]);
        end
        
        counter=counter+1;
    end
    supertitle(filename)
    print(gcf,[filenamePath filename '_' num2str(iF+1) '.png'],'-dpng')
    close
end
