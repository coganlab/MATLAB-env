function Trials = sessDecisionTrials(Sess, CondParams)
%  Returns trials for recording session and task
%
%   Trials = sessDecisionTrials(Sess, Task)
%
%   Sess is output of Spike_Database, Field_Database,
%       SpikeSpike_Database, SpikeField_Database,
%       FieldField_Database, etc
%
%   CONDPARAMS =   Data structure.  Parameter information for 
%   condition information
%
%   CondParams.Task    =   String/Cell.
%   CondParams.Reward   =   Number 
%                                 1 - 2TReward Magnitude
%                                 2 - 
%    CondParams.Correct   =  Correct 0/1 incorrect/correct
%   CondParams.EyeTarget
%   CondParams.HandTarget
%   CondParams.EyeRewardMag
%   CondParams.HandRewardMag
%      
%
%   Note:  Session should be cell array
%           ie: Sess = {'030702',{'001'},{'F'}, 2,  2};
%               so input should be Session{1}.
%
%

disp('Inside sessDecisionTrials');
TwoTRewardMagTaskCode = 2;
ForcedChoiceTaskCode = 1;

if nargin < 2; CondParams.Task = 'DelReachSaccade'; end

Task = CondParams.Task;

if iscell(Task)
    Trials =[];
    for iTask = 1:length(Task)
        disp('Running myTrials in Task loop');
        Trials = [Trials myTrials(Sess,Task{iTask})];
    end
else
    if(ischar(Sess{3}))
        SessSys = Sess{3};
        switch SessSys
            case {'LL','PL','LP','PP'}
                Trials = oldMyTrials(Sess,Task);
            otherwise
                disp('Running myTrials in switch statement');
                Trials = myTrials(Sess,Task);
        end
    else
        %SessSys = Sess{3};
        disp('Running myCellTrials');
        Trials = myCellTrials(Sess,Task);
    end
end
disp([num2str(length(Trials)) ' session Trials for task ' Task])

disp('Subsetting decision trials')

if(isfield(CondParams,'Reward'))
    if(CondParams.Reward == 0)
        Trials = Trials([Trials.Choice] == ForcedChoiceTaskCode);
    elseif(CondParams.Reward == 1) % 2T target reward magnitude choice task
        Trials = Trials([Trials.Choice] == TwoTRewardMagTaskCode);
    end
end

if(isfield(CondParams,'Correct'))
    correct = calcCorrectChoice(Trials)
    if(CondParams.Correct == 0)% Subset incorrect choices
        Trials = Trials(find(correct) == 0);
    else
        Trials = Trials(find(correct) == 1);
    end
end




end

    function Trials = myCellTrials(Sess,Task)

        Day = Sess{1};
        if isstruct(Day) NeedTrials = 0; elseif ischar(Day) NeedTrials = 1; end
             
        if iscell(Sess{2})
            Recs = Sess{2};
        else
            Recs = dayrecs(Sess{1});
        end

        % nRec = length(Recs);
        if ~isempty(Task)
            if NeedTrials
                disp('Running dbTaskTrials')
                Trials = dbTaskTrials(Day,Recs,Task);
            else
                disp('Trials already loaded')
                Trials = Sess{1};
                Trials = TaskTrials(Trials,Task);
            end
        else
            if NeedTrials
                disp('Running dbSelectTrials')
                Trials = dbSelectTrials(Day,Recs);
            else
                disp('Trials already loaded')
                Trials = Sess{1};
            end
        end

        if isempty(Trials)
            disp('No trials');
            return
        end
        if length(Sess)>3
            if ~iscell(Sess{5})
                %  Select trials based on first session field
                disp('Select trials based on first session field');
                if abs(Sess{5}(1)) < 15
                    Sys = Sess{3}{1};
                    Ch = Sess{4}(1);
                    Cl = Sess{5}(1);
                    Trials = getCellTrials(Trials,Sys,Ch,Cl);
                else
                    Sys = Sess{3}{1};
                    Ch = Sess{4}(1);
                    Depth = Sess{5}(1);
                    Trials = getDepthTrials(Trials,Sys,Ch,Depth);
                end
            elseif iscell(Sess{5})
                disp('Select trials based on first session field');
                if abs(Sess{5}{1}(1)) < 15
                    disp('Spike Session')
                    Sys = Sess{3}{1};
                    Ch = Sess{4}(1);
                    Cl = Sess{5}{1};
                    Trials = getCellTrials(Trials,Sys,Ch,Cl);
                else
                    disp('Field Session')
                    Sys = Sess{3}{1};
                    Ch = Sess{4}(1);
                    Depth = Sess{5}{1};
                    Trials = getDepthTrials(Trials,Sys,Ch,Depth);
                end
            end
            if isempty(Trials)
                disp('No trials');
                return
            end

            if length(Sess{5}) > 1
                disp('Select trials based on second session field');
                if iscell(Sess{5})
                    if abs(Sess{5}{2}(1)) < 15
                        disp('Spike Session')
                        Sys = Sess{3}{2};
                        Ch = Sess{4}(2);
                        Cl = Sess{5}{2};
                        Trials = getCellTrials(Trials,Sys,Ch,Cl);
                    else
                        disp('Field Session')
                        Sys = Sess{3}{2};
                        Ch = Sess{4}(2);
                        Depth = Sess{5}{2};
                        Trials = getDepthTrials(Trials,Sys,Ch,Depth);
                    end
                end
            end
        end
    end


        function Trials = myTrials(Sess,Task)

            Day = Sess{1};
            if isstruct(Day) NeedTrials = 0; elseif ischar(Day) NeedTrials = 1; end
            if iscell(Sess{2})
                Recs = Sess{2};
            else
                Recs = dayrecs(Sess{1});
            end
            
            % nRec = length(Recs);
            if ~isempty(Task)
                if NeedTrials
                    disp('Running dbTaskTrials')
                    Trials = dbTaskTrials(Day,Recs,Task);
                else
                    disp('Trials already loaded')
                    Trials = Sess{1};
                    Trials = TaskTrials(Trials,Task);
                end
            else
                if NeedTrials
                    disp('Running dbSelectTrials')
                    Trials = dbSelectTrials(Day,Recs);
                else
                    disp('Trials already loaded')
                    Trials = Sess{1};
                end
            end

            if isempty(Trials)
                disp('No trials');
                return
            end

            if length(Sess)>3
                if ~iscell(Sess{5})
                    %  Select trials based on first session field
                    disp('Select trials based on first session field');
                    if abs(Sess{5}(1)) < 15
                        Sys = Sess{3}{1};
                        Ch = Sess{4}(1);
                        Cl = Sess{5}(1);
                        Trials = getCellTrials(Trials,Sys,Ch,Cl);
                    else
                        Sys = Sess{3}{1};
                        Ch = Sess{4}(1);
                        Depth = Sess{5}(1);
                        Trials = getDepthTrials(Trials,Sys,Ch,Depth);
                    end
                elseif iscell(Sess{5})
                    if abs(Sess{5}{1}(1)) < 15
                        Sys = Sess{3}{1};
                        Ch = Sess{4}(1);
                        Cl = Sess{5}{1};
                        Trials = getCellTrials(Trials,Sys,Ch,Cl);
                    else
                        Sys = Sess{3}{1};
                        Ch = Sess{4}(1);
                        Depth = Sess{5}{1};
                        Trials = getDepthTrials(Trials,Sys,Ch,Depth);
                    end
                end
                if isempty(Trials)
                    disp('No trials');
                    return
                end
                %
                %  Subselect trials based on second session field if present
                if length(Sess{5}) > 1
                    if iscell(Sess{5})
                        if abs(Sess{5}{2}(1)) < 15
                            Sys = Sess{3}{2};
                            Ch = Sess{4}(2);
                            Cl = Sess{5}{2};
                            Trials = getCellTrials(Trials,Sys,Ch,Cl);
                        else
                            Sys = Sess{3}{2};
                            Ch = Sess{4}(2);
                            Depth = Sess{5}{2};
                            Trials = getDepthTrials(Trials,Sys,Ch,Depth);
                        end
                    elseif ~iscell(Sess{5})
                        if abs(Sess{5}(2)) < 15
                            Sys = Sess{3}{2};
                            Ch = Sess{4}(2);
                            Cl = Sess{5}(2);
                            Trials = getCellTrials(Trials,Sys,Ch,Cl);
                        else
                            Sys = Sess{3}{2};
                            Ch = Sess{4}(2);
                            Depth = Sess{5}(2);
                            Trials = getDepthTrials(Trials,Sys,Ch,Depth);
                        end
                    end
                end
                if length(Sess{5}) > 2
                    if iscell(Sess{5})
                        if abs(Sess{5}{3}(1)) < 15
                            Sys = Sess{3}{3};
                            Ch = Sess{4}(3);
                            Cl = Sess{5}{3};
                            Trials = getCellTrials(Trials,Sys,Ch,Cl);
                        else
                            Sys = Sess{3}{3};
                            Ch = Sess{4}(3);
                            Depth = Sess{5}{3};
                            Trials = getDepthTrials(Trials,Sys,Ch,Depth);
                        end
                    elseif ~iscell(Sess{5})
                        if abs(Sess{5}(3)) < 15
                            Sys = Sess{3}{3};
                            Ch = Sess{4}(3);
                            Cl = Sess{5}(3);
                            Trials = getCellTrials(Trials,Sys,Ch,Cl);
                        else
                            Sys = Sess{3}{3};
                            Ch = Sess{4}(3);
                            Depth = Sess{5}(3);
                            Trials = getDepthTrials(Trials,Sys,Ch,Depth);
                        end
                    end
                end
            end

            if length(Trials)==0
                disp('No trials');
                return
            end

            %  Subselect trials based on third session field if present
            if length(Sess{5}) > 2
                if abs(Sess{5}{3}(1)) < 15
                    Sys = Sess{3}{3};
                    Ch = Sess{4}(3);
                    Cl = Sess{5}{3};
                    Trials = getCellTrials(Trials,Sys,Ch,Cl);
                else
                    Sys = Sess{3}{3};
                    Ch = Sess{4}(3);
                    Depth = Sess{5}{3};
                    Trials = getDepthTrials(Trials,Sys,Ch,Depth);
                end
            end


            if length(Trials)==0
                disp('No trials');
                return
            end


            %  Subselect trials based on fourth session field if present
            if length(Sess{5}) > 3
                if abs(Sess{5}{4}) < 15
                    Sys = Sess{3}{4};
                    Ch = Sess{4}(4);
                    Cl = Sess{5}{4};
                    Trials = getCellTrials(Trials,Sys,Ch,Cl);
                else
                    Sys = Sess{3}{4};
                    Ch = Sess{4}(4);
                    Depth = Sess{5}{4};
                    Trials = getDepthTrials(Trials,Sys,Ch,Depth);
                end
            end
        end
        
        
% 
        function Trials = oldMyTrials(Sess,Task)

            Day = Sess{1};
            if iscell(Sess{2})
                Recs = Sess{2};
            else
                Recs = dayrecs(Sess{1});
            end

            % nRec = length(Recs);
            if ~isempty(Task)
                Trials = dbTaskTrials(Day,Recs,Task);
            else
                Trials = dbSelectTrials(Day,Recs);
            end

            if isempty(Trials)
                disp('No trials');
                return
            end

            if length(Sess)>3
                if ~iscell(Sess{5})
                    %  Select trials based on first session field
                    if abs(Sess{5}(1)) < 15
                        Sys = Sess{3}(1);
                        Ch = Sess{4}(1);
                        Cl = Sess{5}(1);
                        Trials = getCellTrials(Trials,Sys,Ch,Cl);
                    else
                        Sys = Sess{3}(1);
                        Ch = Sess{4}(1);
                        Depth = Sess{5}(1);
                        Trials = getDepthTrials(Trials,Sys,Ch,Depth);
                    end
                elseif iscell(Sess{5})
                    if abs(Sess{5}{1}(1)) < 15
                        Sys = Sess{3}(1);
                        Ch = Sess{4}(1);
                        Cl = Sess{5}{1};
                        Trials = getCellTrials(Trials,Sys,Ch,Cl);
                    else
                        Sys = Sess{3}(1);
                        Ch = Sess{4}(1);
                        Depth = Sess{5}{1};
                        Trials = getDepthTrials(Trials,Sys,Ch,Depth);
                    end
                end
                if isempty(Trials)
                    disp('No trials');
                    return
                end

                %  Subselect trials based on second session field if present
                if length(Sess{5}) > 1
                    if iscell(Sess{5})
                        if abs(Sess{5}{2}(1)) < 15
                            Sys = Sess{3}(2);
                            Ch = Sess{4}(2);
                            Cl = Sess{5}{2};
                            Trials = getCellTrials(Trials,Sys,Ch,Cl);
                        else
                            Sys = Sess{3}(2);
                            Ch = Sess{4}(2);
                            Depth = Sess{5}{2};

                            Trials = getDepthTrials(Trials,Sys,Ch,Depth);
                        end
                    elseif ~iscell(Sess{5})
                        if abs(Sess{5}(2)) < 15
                            Sys = Sess{3}(2);
                            Ch = Sess{4}(2);
                            Cl = Sess{5}(2);
                            Trials = getCellTrials(Trials,Sys,Ch,Cl);
                        else
                            Sys = Sess{3}(2);
                            Ch = Sess{4}(2);
                            Depth = Sess{5}(2);
                            Trials = getDepthTrials(Trials,Sys,Ch,Depth);
                        end
                    end
                end

                if length(Trials)==0
                    disp('No trials');
                    return
                end

                %  Subselect trials based on third session field if present
                if length(Sess{5}) > 2
                    if abs(Sess{5}{3}(1)) < 15
                        Sys = Sess{3}(3);
                        Ch = Sess{4}(3);
                        Cl = Sess{5}{3};
                        Trials = getCellTrials(Trials,Sys,Ch,Cl);
                    else
                        Sys = Sess{3}(3);
                        Ch = Sess{4}(3);
                        Depth = Sess{5}{3};
                        Trials = getDepthTrials(Trials,Sys,Ch,Depth);
                    end
                end


                if length(Trials)==0
                    disp('No trials');
                    return
                end


                %  Subselect trials based on fourth session field if present
                if length(Sess{5}) > 3
                    if abs(Sess{5}{4}) < 15
                        Sys = Sess{3}(4);
                        Ch = Sess{4}(4);
                        Cl = Sess{5}{4};
                        Trials = getCellTrials(Trials,Sys,Ch,Cl);
                    else
                        Sys = Sess{3}(4);
                        Ch = Sess{4}(4);
                        Depth = Sess{5}{4};
                        Trials = getDepthTrials(Trials,Sys,Ch,Depth);
                    end
                end
            end
        end
            %
