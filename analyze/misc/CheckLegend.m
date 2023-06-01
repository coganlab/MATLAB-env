function Fig=CheckLegend(Fig,iFig,MarkersInFig)

%if Fig(iFig).numplots>1    
    for iplot=1:Fig(iFig).numplots
        Ext=get(Fig(iFig).Legend.plotline(iplot),'Extent');
        disp(['Check Loop: ' num2str(iplot) ' Ext is: ' num2str(Ext)])
        numloops=0;
        tempfont=Fig(iFig).Legend.fontsize;
        while Ext(3)+Ext(1)>1-Fig(iFig).Legend.HorzBdr&numloops<100
            numloops=numloops+1;
            disp(['Shrinking font for: Fig(' num2str(iFig) ').Legend.plotline(' num2str(iplot) ')' ]);
            tempfont=.9*tempfont;
            set(Fig(iFig).Legend.plotline(iplot),'FontSize',tempfont);
            Ext=get(Fig(iFig).Legend.plotline(iplot),'Extent');
            %            disp(['In while loop Ext is ' numstr(Ext)]);
        end
        set(Fig(iFig).Legend.plotmark(iplot),'XData',[Ext(1)-Fig(iFig).Legend.PlotmarkOffset ...
                Ext(1)-Fig(iFig).Legend.PlotmarkOffset-Fig(iFig).Legend.PlotmarkLength],'YData',[Ext(2)+.5*Ext(4) Ext(2)+.5*Ext(4)])
    end
    %end

% Markinds=find(MarkersInFig);
% for iMark=1:sum(MarkersInFig)
%     NewExt{iMark}=get(Fig(iFig).Legend.Markerline(iMark),'Extent');
%     disp(['Markerline Check Loop: ' num2str(iMark) ' Ext is: ' num2str(NewExt{iMark})])
%     numloops=0;
%     tempfont=Fig(iFig).Legend.fontsize;
%     while NewExt{iMark}(3)+NewExt{iMark}(1)>1-Fig(iFig).Legend.HorzBdr&numloops<100
%         numloops=numloops+1;
%         disp(['Shrinking font for: Fig(' num2str(iFig) ').Legend.Markerline(' num2str(iMark) ')' ]);
%         tempfont=.9*tempfont;
%         set(Fig(iFig).Legend.Markerline(iMark),'FontSize',tempfont);
%         NewExt{iMark}=get(Fig(iFig).Legend.Markerline(iMark),'Extent');
%         disp(['In while loop Ext is ' num2str(NewExt{iMark})]);
%     end
%     if iMark~=2
%         disp(['Adjusting Mark ' num2str(iMark) ' to X: ' num2str(NewExt{iMark}(1)-Fig(iFig).Legend.MarkerOffset) ' Y: ' num2str(NewExt{iMark}(2)+.5*NewExt{iMark}(4))]);
%         set(Fig(iFig).Legend.Marker(iplot),'XData',[NewExt{iMark}(1)-Fig(iFig).Legend.MarkerOffset],...
%             'YData',[NewExt{iMark}(2)+.5*NewExt{iMark}(4)])
%     end
% end
% axis([0 1 0 1])