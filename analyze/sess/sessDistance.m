function Distance = sessDistance(Session)

% where Session is a  FF, SF, or MF session, calculates distance between
% the two components

splitSess = splitSession(Session);
Depth(1) = sessDepth(splitSess{1});
Depth(2) = sessDepth(splitSess{2});
Ch(1) = sessChannel(splitSess{1});
Ch(2) = sessChannel(splitSess{2});
if diff(Ch) == 0 
    factor = 0;
else
    factor = 1;
end
Distance = sqrt(factor.*650.^2 + diff(Depth).^2);
end
