function Trials = sessTrials(Sess, Task)
%  Returns trials for recording session and task
%
%   Trials = sessTrials(Sess, Task)
%
%   Sess is output of Spike_Database, Field_Database,
%       SpikeSpike_Database, SpikeField_Database,
%       FieldField_Database, Multiunit_Database, etc
%
%   Note:  Session should be cell array
%           ie: Sess = {'030702',{'001'},{'F'}, 2,  2};
%               so input should be Session{1}.
%
%

%disp('Inside sessTrials');

if nargin < 2; Task = ''; end

if iscell(Task)
    Trials =[];
    for iTask = 1:length(Task)
        %disp('Running myTrials in Task loop')
        Trials = [Trials myTrials(Sess,Task{iTask})];
    end
else
    if(ischar(Sess{3}))
        Trials = myTrials(Sess,Task);
    else
        Trials = myCellTrials(Sess,Task);
    end
end
%disp([num2str(length(Trials)) ' session Trials for task ' Task])
end

function Trials = myCellTrials(Sess,Task)
disp('Inside mycelltrials')
NeedTrials = 1;
MonkeyDir = sessMonkeyDir(Sess);
Day = Sess{1};
if isstruct(Day); NeedTrials = 0;
elseif ischar(Day); NeedTrials = 1;
elseif iscell(Day); Day = Day{1}; NeedTrials = 1;
end



if iscell(Sess{2})
    Recs = Sess{2};
else
    Recs = dayrecs(Sess{1},MonkeyDir);
end

% nRec = length(Recs);
if ~isempty(Task)
    if NeedTrials
        Trials = dbTaskTrials(Day,Recs,Task,MonkeyDir);
    else
        disp('Trials already loaded')
        Trials = Sess{1};
        Trials = TaskTrials(Trials,Task);
    end
else
    if NeedTrials
        Trials = dbSelectTrials(Day,Recs,MonkeyDir);
    else
        disp('Trials already loaded')
        Trials = Sess{1};
    end
end

if isempty(Trials)
    disp('No trials');
    return
end
if length(Sess)>3 %When was a session ever less than 6 elements? Yes for behavior database
    
    Type = sessTypeCell(Sess);
    if(~strcmp(Type,'Behavior'))
        
        Sys = sessTower(Sess);
        Info = sessCellDepthInfo(Sess);
        Ch = sessElectrode(Sess);
        for iPart = 1:length(Type)
            PartType = Type{iPart};
            disp([PartType ' Session']);
            switch PartType
                case 'Spike'
                    Trials = getCellTrials(Trials,Sys{iPart},Ch(iPart),Info{iPart});
                case {'Field','Laminar'}
                    depth = Info{iPart};
                    if iscell(depth);
                        depth = depth{1};
                    end
                    Trials = getDepthTrials(Trials,Sys{iPart},Ch(iPart),depth);
                case {'Multiunit'}
                    depth = Info{iPart};
                    if iscell(depth); depth = depth{1}; end
                    Trials = getDepthTrials(Trials,Sys{iPart},Ch(iPart),depth);
                    Trials = getCellTrials(Trials,Sys{iPart},Ch(iPart),1);
                otherwise %add laminar
            end
            if isempty(Trials)
                disp('No trials left in myCellTrials');
                return
            end
        end
    end
end
end


function Trials = myTrials(Sess,Task)

disp('Inside myTrials')
MonkeyDir = sessMonkeyDir(Sess);
Day = Sess{1};
if isstruct(Day); NeedTrials = 0; elseif ischar(Day); NeedTrials = 1; end
if iscell(Sess{2})
    Recs = Sess{2};
else
    Recs = dayrecs(Sess{1},MonkeyDir);
end

% nRec = length(Recs);
if ~isempty(Task)
    if NeedTrials
        Trials = dbTaskTrials(Day,Recs,Task,MonkeyDir);
    else
        Trials = Sess{1};
        subTrials = [];
        if iscell(Task)
            for iTask = 1:length(Task)
                subTrials = [subTrials TaskTrials(Trials,Task{iTask})];
            end
        else
            subTrials = TaskTrials(Trials,Task);
        end
        Trials = subTrials;
    end
else
    if NeedTrials
        Trials = dbSelectTrials(Day,Recs,MonkeyDir);
    else
        Trials = Sess{1};
    end
end

if isempty(Trials)
    disp('No trials');
    return
end
Type = sessTypeCell(Sess);

if(~strcmp(Type,'Behavior'))
    if length(Sess)>3 %When was a session ever less than 6 elements?
        Sys = sessTower(Sess);
        Info = sessCellDepthInfo(Sess);
        Ch = sessElectrode(Sess);
        for iPart = 1:length(Type)
            PartType = Type{iPart};
            disp([PartType ' Session']);
            switch PartType
                case {'Field','Laminar'}
                    depth = Info{iPart};
                    if iscell(depth); depth = depth{1}; end                    
                    Trials = getDepthTrials(Trials,Sys{iPart},Ch(iPart),depth(1:2));
                case 'Spike'
                    Trials = getCellTrials(Trials,Sys{iPart},Ch(iPart),Info{iPart});
                case{'Multiunit'}
                    depth = Info{iPart};
                    if iscell(depth); depth = depth{1}; end
                    Trials = getDepthTrials(Trials,Sys{iPart},Ch(iPart),depth(1:2));
                    Trials = getCellTrials(Trials,Sys{iPart},Ch(iPart),1)
                otherwise %add Ensemble
            end
            if isempty(Trials)
                disp('No trials in myTrials');
                return
            end
        end
    end
end
end

