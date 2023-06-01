function [Fig,Tit] = AddTitle(Tit,Fig,iFig)
%
%   [Fig,Tit] = AddTitle(Tit,Fig,iFig)
%

Fig(iFig).Tithandle = axes('Position',...
                                [Fig(iFig).HorzBorderSpace,...
                                1-Fig(iFig).VertBorderSpace-Tit.Height,...
                                1-2*Fig(iFig).HorzBorderSpace,...
                                Tit.Height], 'Ytick', [], 'XTick', []);
box on

for i = 1:Tit.numlines
    for j = 1:Tit.numfields(i)
        Tit.ques(i,j) = AddFittedText(Tit.qstr{i,j}, Tit.HorzPos{i}(j), ...
                                        Tit.VertPos{i}(j), Tit.HorzPos{i}(j) + Tit.MaxQlength, ...
                                        'normalized', Tit.fontsize{i}(j), 'left', 'bold');
    QExt=get(Tit.ques(i,j),'Extent');
        if j == Tit.numfields(i);
            nextedge = 1;
        else
            nextedge = Tit.HorzPos{i}(j+1);
        end
        if ~isempty(Tit.astr{i,j})
            Tit.ans(i,j) = AddFittedText(Tit.astr{i,j}, Tit.HorzPos{i}(j) + QExt(3), ...
                                        Tit.VertPos{i}(j), nextedge, ...
                                        'normalized', Tit.fontsize{i}(j));
        end
    end
end