function Info = sessCellDepthInfo(Sessions)
% Return the Cell or Depth fields from an array of Sessions
%
%   Info = sessCellDepthInfo(Sessions)
%


if ~iscell(Sessions{1})
    tmpInfo = Sessions{5};
    if iscell(tmpInfo)
        for iPart = 1:length(tmpInfo)
            Tmp = tmpInfo(iPart);
            if iscell(Tmp); Tmp = Tmp{1}; end
            Info{iPart} = Tmp;
        end
    else
        for iPart = 1:length(tmpInfo)
            Info{iPart} = tmpInfo(iPart);
        end
    end
else
    Info = cell(1,length(Sessions));
    for iSess = 1:length(Sessions)
        tmpInfo = Sessions{iSess}{5};
        if iscell(tmpInfo)
            for iPart = 1:length(tmpInfo)
                Tmp = tmpInfo(iPart);
                if iscell(tmpInfo{iPart}); Tmp = Tmp{1}; end
                tmpInfo{iPart} = Tmp;
            end
        end
        Info{iSess} = tmpInfo;
    end
end


