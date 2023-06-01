function Fig = SetPrintPSTHDirpos(Fig,Tit,iFig)
%
% function Fig(iFig) = SetPSTHDirpos(Fig, Tit, iFig)
%
% Setting widths and heighths of each direction for sessPrintPSTH    


Fig(iFig).VertISacc = 0;
Fig(iFig).HorzISacc = 0;
Fig(iFig).DirWidth = (1-(Fig(iFig).VertISaccLegWidth+Fig(iFig).HorzBorderSpace)*Fig(iFig).VertISacc - ...
                        2*Fig(iFig).HorzBorderSpace-Fig(iFig).LabelSpace - ...
                        Fig(iFig).HorzBetweenDirSpace*(Fig(iFig).numxdirs-1))/(Fig(iFig).numxdirs - ...
                        Fig(iFig).NoIntSaccAxisGraphs*Fig(iFig).VertISacc);
Fig(iFig).DirHeight = (1-(Fig(iFig).HorzISaccLegHeight+Fig(iFig).VertBorderSpace)*Fig(iFig).HorzISacc - ...
                        Tit.Height - Tit.TBSpace - Fig(iFig).TB.Height - 3*Fig(iFig).VertBorderSpace - ...
                        Fig(iFig).VertBetweenDirSpace*(Fig(iFig).numydirs-1))/(Fig(iFig).numydirs - ...
                        Fig(iFig).NoIntSaccAxisGraphs*Fig(iFig).HorzISacc);
% disp(['Before alteration Dir Height is: ' num2str(Fig(iFig).DirHeight)])
% if Fig(iFig).numplots > 2 | (Fig(iFig).numplots > 1 & Fig(iFig).HorzISacc)
%      Fig(iFig).DirHeight = Fig(iFig).DirHeight - 0.022*(Fig(iFig).numplots-1);
% end  
% disp(['After alteration Dir Height it''s: ' num2str(Fig(iFig).DirHeight)])
Fig(iFig).Dirxpos = (1:Fig(iFig).numxdirs);
Fig(iFig).Dirypos = (1:Fig(iFig).numydirs);
Fig(iFig).Dirxpos = Fig(iFig).HorzBorderSpace+Fig(iFig).LabelSpace + (Fig(iFig).DirWidth+Fig(iFig).HorzBetweenDirSpace)*(Fig(iFig).Dirxpos-1);
Fig(iFig).Dirypos = 1-(Tit.Height + Tit.TBSpace+Fig(iFig).TB.Height+2*Fig(iFig).VertBorderSpace + ...
                        Fig(iFig).DirHeight*Fig(iFig).Dirypos + Fig(iFig).VertBetweenDirSpace*(Fig(iFig).Dirypos-1));
% if Fig(iFig).numplots > 2 | Fig(iFig).numplots > 1 & Fig(iFig).HorzISacc
%      Fig(iFig).Dirypos = Fig(iFig).Dirypos - 0.022*(Fig(iFig).numplots-1);
% end  
Fig(iFig).HistHeight = (Fig(iFig).DirHeight - Fig(iFig).BetweenGraphSpace1 - Fig(iFig).BetweenGraphSpace2)*Fig(iFig).HistSpaceFrac;

%Adjust Hist Height to account for the number of lines in the title above each direction graph
if Fig(iFig).numplots>2
    Fig(iFig).HistHeight=Fig(iFig).HistHeight/(1+Fig(iFig).numplots*Fig(iFig).DirTitleFontSize);
end

Fig(iFig).EHHeight = (Fig(iFig).DirHeight - Fig(iFig).BetweenGraphSpace1 - Fig(iFig).BetweenGraphSpace2)*(1-Fig(iFig).HistSpaceFrac)/2;