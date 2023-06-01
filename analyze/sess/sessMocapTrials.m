function Trials = sessMocapTrials(Sess)
%  Returns mocap trials for recording session
%
%   Trials = sessMocapTrials(Sess)
%
%   Sess is output of Spike_Database, Field_Database,
%       SpikeSpike_Database, SpikeField_Database,
%       FieldField_Database, Multiunit_Database, etc
%
%   Note:  Session should be cell array
%           ie: Sess = {'030702',{'001'},{'F'}, 2,  2};
%               so input should be Session{1}.
%

%disp('Inside sessMocapTrials');

if nargin < 2; Task = ''; end

Rec = sessRec(Sess);
Day = sessDay(Sess);
Trials = dbSelectMocapTrials(Day, Rec);

if isempty(Trials)
    disp('No trials');
    return
end
if length(Sess)>3
    Sys = Sess{3}{1};
    Ch = Sess{4}(1);
    if ~iscell(Sess{5})
        %  Select trials based on first session field
        %  disp('Select trials based on first session field');
        if abs(Sess{5}(1)) < 15
            Cl = Sess{5}(1);
            Trials = getCellTrials(Trials,Sys,Ch,Cl);
        else
            Depth = Sess{5}(1:2);
            Trials = getDepthTrials(Trials,Sys,Ch,Depth);
        end
    elseif iscell(Sess{5})
        % disp('Select trials based on first session field');
        if(iscell(Sess{5}{1}))
            %  Multiunit
            Depth = Sess{5}{1}{1}(1:2);
            Trials = getDepthTrials(Trials,Sys,Ch,Depth);
        elseif length(Sess{5}{1})==3
            %  Multiunit
            Depth = Sess{5}{1}(1:2);
            Trials = getDepthTrials(Trials,Sys,Ch,Depth);
        elseif abs(Sess{5}{1}(1)) < 15
            %     disp('Spike or multiunit Session')
            Cl = Sess{5}{1};
            Trials = getCellTrials(Trials,Sys,Ch,Cl);
        else
            %    disp('Field Session')
            Depth = Sess{5}{1}(1:2);
            Trials = getDepthTrials(Trials,Sys,Ch,Depth);
        end
    end
    if isempty(Trials)
        disp('No trials after');
        return
    end
    
    if length(Sess{5}) > 1
        %disp('Select trials based on second session field');
        if iscell(Sess{5})
            if abs(Sess{5}{2}(1)) < 15
                %       disp('Spike or multiunit Session')
                Sys = Sess{3}{2};
                Ch = Sess{4}(2);
                Cl = Sess{5}{2};
                Trials = getCellTrials(Trials,Sys,Ch,Cl);
            elseif length(Sess{5}{2})==3
                %Multiunit
                Sys = Sess{3}{2};
                Ch = Sess{4}(2);
                Depth = Sess{5}{2}(1);
                Trials = getDepthTrials(Trials,Sys,Ch,Depth);
            else
                %      disp('Field Session')
                Sys = Sess{3}{2};
                Ch = Sess{4}(2);
                Depth = Sess{5}{2};
                Trials = getDepthTrials(Trials,Sys,Ch,Depth);
            end
        end
    end
end
end
