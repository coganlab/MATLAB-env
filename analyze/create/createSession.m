function Session = createSession(Sess)
%
%   Session = createSession(Sess)
%
%   Inputs:
%     Sess = Cell array with sessions to put together in the order sent
%
%  Outputs: 
%    Session = Cell array.
%

global MONKEYNAME

NSess = length(Sess);
for iSess = 1:NSess
    cmdstr = ['S' num2str(iSess) ' = Sess{' num2str(iSess) '};']; eval(cmdstr)
end

tmpSession = cell(0,0);
switch NSess
    case 1
        tmpSession = S1;
        
    case 2
        tmpSession(1) = intersect(S1(1),S2(1));
        tmpSession{2} = intersect(S1{2},S2{2});
        tmpSession{3}{1} = S1{3}{1};
        tmpSession{3}{2} = S2{3}{1};
        tmpSession{4} = [S1{4},S2{4}];
        if iscell(S1{5})
            if iscell(S2{5})
            tmpSession{5} = {S1{5}{1},S2{5}{1}};
            else
            tmpSession{5} = {S1{5}{1},S2{5}};
            end
        elseif ~iscell(S1{5})
            if iscell(S2{5})
            tmpSession{5} = {S1{5},S2{5}{1}};
            else
            tmpSession{5} = {S1{5},S2{5}};
            end
        end
        tmpSession{6} = [S1{6},S2{6}];
        tmpSession{7} = MONKEYNAME;
        Type1 = getSessionType(S1);
        Type2 = getSessionType(S2);
        tmpSession{8} = {Type1,Type2};
        
    case 3
        tmpSession(1) = intersect(intersect(S1(1),S2(1)),intersect(S1(1),S3(1)));
        tmpSession{2} = intersect(intersect(S1{2},S2{2}),intersect(S1{2},S3{2}));
        tmpSession{3}{1} = S1{3}{1};
        tmpSession{3}{2} = S2{3}{1};
        tmpSession{3}{3} = S3{3}{1};
        tmpSession{4} = [S1{4},S2{4},S3{4}];
        if iscell(S1{5}); e1 = S1{5}{1}; 
        else e1 = S1{5}; 
        end
        if iscell(S2{5}); e2 = S2{5}{1}; 
        else e2 = S2{5}; 
        end
        if iscell(S3{5}); e3 = S3{5}{1}; 
        else e3 = S3{5}; 
        end
        tmpSession{5} = {e1,e2,e3};
        tmpSession{6} = [S1{6},S2{6},S3{6}];
        tmpSession{7} = MONKEYNAME;
        Type1 = getSessionType(S1);
        Type2 = getSessionType(S2);
        Type3 = getSessionType(S3);
        tmpSession{8} = {Type1,Type2,Type3};
end

Session = tmpSession;



