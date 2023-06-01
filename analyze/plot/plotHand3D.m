function [Hand3D,Trials] = plotHand3D(day)
day
%Trials = dbSelectTrials('090715',{'001','007','010'});
Trials = dbSelectTrials(day);
MarkerIDs = [4,5,6,7,8,9,10,11,12];
Hand3D = trialHand3D(Trials,MarkerIDs,'ReachStart',[-500,500]);

close all
clf
CLIST = {'b.','r.','g.','m.','b.','c.','k.','m.'};

MARKERS = [1:8];
for iTarget = 1:8
    figure
    ind = find([Trials.Target]==iTarget);
    clf
    for iTrial = 1:length(ind)
        for iMarker = MARKERS
            data = Hand3D{ind(iTrial),iMarker};
            if ~isempty(data)
                for iPlot = 1:3
                    subplot(3,1,iPlot);
                    hold on;
                    h = plot(data(1,:),data(iPlot+1,:),CLIST{iMarker});
                    set(h,'Markersize',4);
                end
            end
        end
    end
    supertitle(['Target ' num2str(iTarget)]);
end

CLIST = {'b.','r.','g.','m.','b.','c.','k.','m.'};
%clf

for iMarker = MARKERS
    figure;
    for iTarget = 1:8
        ind = find([Trials.Target]==iTarget);
        for iTrial = 1:length(ind)
            data = Hand3D{ind(iTrial),iMarker};
            if ~isempty(data)
                hold on;
                h = plot3(data(2,:),data(3,:),data(4,:),CLIST{iTarget});
                set(h,'Markersize',10);
                title(['Marker ' num2str(MarkerIDs(iMarker))]);
            end
        end
    end
end


%
% CLIST = {'b.','r.','g.','m.','b.','c.','k.','m.'};
% clf
% figure;
% for iTarget = 1:8
%     ind = find([Trials.Target]==iTarget);
%     for iTrial = 1:length(ind)
%         data = Hand3D{ind(iTrial),3};
%         if ~isempty(data)
%             comet3(data(2,:),data(4,:),data(3,:));
%         end
%         pause
%     end
% end
