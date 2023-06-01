function Cells = sessCell(Sessions)
% Return the Cells fields from an array of Sessions
%
%   Cells = sessCell(Sessions)
%

if ~iscell(Sessions{1})
    Info = sessCellDepthInfo(Sessions);
    Cells = cell(1,length(Info));
    for iPart = 1:length(Info)
        if length(Info(iPart)) == 1
            if iscell(Info)
                Cells{iPart} = Info{iPart};
            else
                Cells{iPart} = Info(iPart);
            end
        else
            Cells{iPart} = NaN;
        end
    end
else
    Info = sessCellDepthInfo(Sessions{1});
    nPart = length(Info);
    Cells = cell(length(Sessions),nPart);
    for iSess = 1:length(Sessions)
        Info = sessCellDepthInfo(Sessions{iSess});
        for iPart = 1:length(Info)
            if length(Info(iPart)) == 1
                if iscell(Info)
                    Cells{iSess,iPart} = Info{iPart};
                else
                Cells{iSess,iPart} = Info(iPart);
                end
                
            else
                Cells{iSess,iPart} = NaN;
            end
        end
    end
end

%Cells = cell2num(Cells); %This doesn't work. You're sometimes returning
%multiple cells, since sessions can be multi-part