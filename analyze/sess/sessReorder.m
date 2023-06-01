function NewSession = sessReorder(Session,order)

%   Session = sessReorder(Session,order)
%   Takes a session and reorder
%   Returns the reordered session


SSess = splitSession(Session);

for i = 1:length(SSess)
    mySess{i} = SSess{order(i)};
end

NewSession = createSession(mySess);

end

