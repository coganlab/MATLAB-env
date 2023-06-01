function Fig = AddTaskBar(Fig,Tit,iFig)
%
%   Fig = AddTaskBar(Fig,Tit,iFig)
%
Fig(iFig).TBhandle = axes('Position',[Fig(iFig).HorzBorderSpace, ...
                                        1-Fig(iFig).VertBorderSpace-Tit.Height-Tit.TBSpace-Fig(iFig).TB.Height, ...
                                        1-2*Fig(iFig).HorzBorderSpace, ...
                                        Fig(iFig).TB.Height], 'Ytick', [], 'XTick', []);
box on
for i = 1:Fig(iFig).TB.numlines
    for j = 1:size(Fig(iFig).TB.qstr,2)
        Fig(iFig).TB.ques(i,j) = AddFittedText(Fig(iFig).TB.qstr{i,j}, ...
                                    Fig(iFig).TB.HorzPos{i}(j), ...
                                    Fig(iFig).TB.VertPos{i}(j), ...
                                    Fig(iFig).TB.HorzPos{i}(j) + Fig(iFig).TB.MaxQlength, ...
                                    'normalized', Fig(iFig).TB.fontsize{i}(j), 'left', 'bold');
         QExt = get(Fig(iFig).TB.ques(i,j),'Extent');
        if j > size(Fig(iFig).TB.qstr,2)-Fig(iFig).TB.LastColEntries
            nextedge = 1;
        else
            nextedge = Fig(iFig).TB.HorzPos{i}(j+1);
        end       
        Fig(iFig).TB.ans(i,j) = AddFittedText(Fig(iFig).TB.astr{i,j}, ...
                                    Fig(iFig).TB.HorzPos{i}(j)+QExt(3), ...
                                    Fig(iFig).TB.VertPos{i}(j), ...
                                    nextedge, 'normalized', Fig(iFig).TB.fontsize{i}(j));
    end
end