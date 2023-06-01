function Trials = dbTrials(Subject,Day,Task)
%
%
%   Trials = dbTrials(Subject,Day,Task)
%
%  Task = 'Speech_CovertOvert'
%

global DUKEDIR experiment

if nargin < 3 || isempty(Task) Task = 'Speech_CovertOvert'; end

if isfile([DUKEDIR '/' Subject '/' Day '/mat/Trials.mat'])
    load([DUKEDIR '/' Subject '/' Day '/mat/Trials.mat'])
else
    Trials = struct([]);
    Dirs = dir([DUKEDIR '/' Subject '/' Day]);
    for iDir = 1:length(Dirs)
        RecTrials = struct([]);
        if Dirs(iDir).isdir
            Rec = Dirs(iDir).name;
            
           Filename = dir([DUKEDIR '/' Subject '/' Day '/' Rec '/*.low.nspike.dat']); % Raw Data
           if isempty(Filename)
           Filename = dir([DUKEDIR '/' Subject '/' Day '/' Rec '/*.cleanieeg.dat']); 
           end
            if ~isempty(Filename)
                Periods = strfind(Filename.name,'.');
                FilenamePrefix = Filename.name(1:Periods(1)-1);
                dio = load([DUKEDIR '/' Subject '/' Day '/' Rec '/' FilenamePrefix '.dio.txt']);
                Codes = [dio(:,1) bin2dec(num2str(dio(:,end-15:end-8)))];
                ind = find(Codes(:,2));
                Codes = Codes(ind,:);
                RecTrials = procCodes(Task,Codes);
                disp([Subject ':' Day ':' Rec ':' FilenamePrefix ' ' num2str(length(RecTrials)) ' Trials']);

                for iTrial = 1:length(RecTrials)
                    RecTrials(iTrial).Subject = Subject;
                    RecTrials(iTrial).Trial = iTrial;
                    RecTrials(iTrial).Day = Day;
                    RecTrials(iTrial).Rec = Rec;
                    RecTrials(iTrial).FilenamePrefix = FilenamePrefix;
                    RecTrials(iTrial).Manual.AuditoryStart = 0;
                    RecTrials(iTrial).Manual.AuditoryStop = 0;
                    RecTrials(iTrial).Manual.ResponseStart = 0;
                    RecTrials(iTrial).Manual.ResponseStop = 0;
                    RecTrials(iTrial).AuditoryFStart = 0;
                    RecTrials(iTrial).AuditoryFStop = 0;
                    RecTrials(iTrial).ResponseFStart = 0;
                    RecTrials(iTrial).ResponseFStop = 0;
                    RecTrials(iTrial).Noisy = 0;
                    RecTrials(iTrial).NoResponse = 0;
                end  %  Trial loop
            end    %  if Filename
        end  % if Recording
        Trials = [Trials RecTrials]; %#ok<AGROW>
    end    % Directory loop
end

disp([Subject ':' Day ' ' num2str(length(Trials)) ' Trials']);
