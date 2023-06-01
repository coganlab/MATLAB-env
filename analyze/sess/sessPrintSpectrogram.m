function [Data]=sessPrintSpectrogram(Sess,CondParams, AnalParams)
%,Task,Field,bn,time,freq, tapers
%   [Data] = sessPrintSpectrogram(Sess,CondParams, AnalParams)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information for
%   condition information
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   CondParams.Task    =   Cell array of strings. Each row in the cell
%               array is a new figure, with each cell containing
%               a task to include for that figure.
%               'DelReachFix'
%               'DelSaccadeTouch'
%               'DelReachSaccade'
%   CondParams.Field    =   String.  Alignment field
%                   Defaults to 'TargsOn'
%   CondParams.bn     =   Vector.  Analysis interval in ms
%                   Defaults to [-1e3,1e3]
%   CondParams.Time   = Defaults to 40
%   CondParams.Choice  = Defaults to 1;
%
%   AnalParams.tapers   =  Vector.  Spectral analysis smoothing parameters [N,W]
%                   N = smoothing in time (s).
%                   W = smoothing in frequency (Hz)
%
%   AnalParams.freq      =  Defaults to 7 Vector.  Select frequency band to test



global CONTROLTASKLIST MONKEYDIR

Dirs = 8;


if(isfield(CondParams,'Task'))
    Task = CondParams.Task;
else
    Task = {'DelReachSaccade'};
    CondParams.Task= {'DelReachSaccade'};
end
if(isfield(CondParams,'Field'))
    Field = CondParams.Field;
else
    Field = 'TargsOn';
    CondParams.Field = Field;
end
if(isfield(CondParams,'bn'))
    bn = CondParams.bn;
else
    bn = [-1e3,2e3];
    CondParams.bn = bn;
end
if(isfield(CondParams,'Time'))
    time = CondParams.Time;
else
    time=40;
    CondParams.Time = time;
end
if(isfield(CondParams,'Choice'))
    choice = CondParams.Choice;
else
    choice = 0;
    CondParams.Choice = 0;
end

if(isfield(AnalParams,'tapers'))
    tapers = AnalParams.tapers;
else
    tapers = [.5,5];
    AnalParams.tapers = tapers;
end
if(isfield(AnalParams,'freq'))
    freq = AnalParams.freq;
else
    freq=7;
    AnalParams.freq = freq;
end


AnalParams.dn = tapers(1)/10; % Defaults to 10% of the window size
AnalParams.pad = 2;
AnalParams.fk = 200;


if ~iscell(Sess{2})
    Sess{2} = {Sess(2)};
end

if ischar(Task);    Task=str2cell(Task); end

Sys = Sess{3}{1};
Ch = Sess{4}(1);
Cl = Sess{5}(1);
day = Sess{1};
PossibleTasks=CONTROLTASKLIST;

AllTasks=unique(Task);
temprefs=find(~strcmp(AllTasks,[]));
if length(temprefs)~=length(AllTasks)
    tempAllTasks=AllTasks;
    clear AllTasks;
    for iTask=1:length(temprefs)
        AllTasks{iTask}=tempAllTasks{temprefs(iTask)};
    end
end


if ~all(ismember(AllTasks,PossibleTasks))
    msgstr = 'Error, input task(s)';
    tempcheck = find(~ismember(AllTasks,PossibleTasks));
    for iTask = 1:tempcheck
        msgstr = [msgstr AllTasks{tempcheck(iTask)}];
    end
    error([msgstr ' is not a possible task.'])
end

num_trial = zeros(Dirs,1);
% calculate spectrograms for each direction
Trials = sessTrials(Sess,AllTasks);

if ~isempty(Trials)
    trial_indexes = ([Trials.Choice] == 2);
    if(~choice)
        Trials(trial_indexes) =[];
    else
        Trials = Trials(trial_indexes);
    end
    Sess{1} = Trials;

    for iDir = 1:8
        CondParams.conds = {[iDir]};
        spec = sessSpectrum(Sess,CondParams,AnalParams);
        if size(size(spec),2) > 2
            spectun(iDir,:,:) = sq(mean(spec,1));
            tmp_size = size(spec);
            num_trials(iDir) = tmp_size(1);
        else
            spectun(iDir,:,:) = spec;
            num_trials(iDir) = 0;
        end
    end
    Data.Spec = spectun;
    Data.Session = Sess;

    if size(spectun,2)<10
        for i = 1:8
            fh = spectun{i};
            f(i,:,:) = sq(mean(fh,1));
        end
        spectun = f;
    end

    % calculate PD curve
    [PD,phi] = calcPrefDir(sq(log(spectun(:,time,freq))'));

    minlevel = min(min(min(log(spectun))));
    maxlevel = max(max(max(log(spectun))));

    area = Sess{3};
    TaskTitle = ['Task: ' Task{1}];
    AreaTitle = ['Area: ' area];
    recordings = Sess{2};
    RecTitle = ['Recordings: ' recordings{1}];
    for i = 2:length(recordings)
        RecTitle = strcat(RecTitle, ' ', recordings{i});
    end
    SessTitle = ['Session: ' num2str(Sess{6})];

    figure
    subplot(3,3,6)
    if ~(minlevel==maxlevel)
        tvimage(log(spectun(1,:,1:100)),'CLim',[minlevel,maxlevel],'XRange',bn)
        title([num2str(num_trials(1)) ' trials'])
    end
    subplot(3,3,3)
    if ~(minlevel==maxlevel)
        tvimage(log(spectun(2,:,1:100)),'CLim',[minlevel,maxlevel],'XRange',bn)
        title([num2str(num_trials(2))  ' trials'])
        %title(RecTitle)
    end
    subplot(3,3,2)
    if ~(minlevel==maxlevel)
        tvimage(log(spectun(3,:,1:100)),'CLim',[minlevel,maxlevel],'XRange',bn)
        title([num2str(num_trials(3)) ' trials'])
        %title(AreaTitle)
    end
    subplot(3,3,1)
    if ~(minlevel==maxlevel)
        tvimage(log(spectun(4,:,1:100)),'CLim',[minlevel,maxlevel],'XRange',bn)
        title([num2str(num_trials(4)) ' trials'])
        %title(['day: ' Sess{1}])
    end
    subplot(3,3,4)
    if ~(minlevel==maxlevel)
        tvimage(log(spectun(5,:,1:100)),'CLim',[minlevel,maxlevel],'XRange',bn)
        title([num2str(num_trials(5)) ' trials'])
        %title(TaskTitle)
    end
    subplot(3,3,7)
    if ~(minlevel==maxlevel)
        tvimage(log(spectun(6,:,1:100)),'CLim',[minlevel,maxlevel],'XRange',bn)
        title([num2str(num_trials(6)) ' trials'])
        %title(SessTitle)
    end
    subplot(3,3,8)
    if ~(minlevel==maxlevel)
        tvimage(log(spectun(7,:,1:100)),'CLim',[minlevel,maxlevel],'XRange',bn)
        title([num2str(num_trials(7)) ' trials'])
    end
    subplot(3,3,9)
    if ~(minlevel==maxlevel)
        tvimage(log(spectun(8,:,1:100)),'CLim',[minlevel,maxlevel],'XRange',bn)
        title([num2str(num_trials(8)) ' trials'])
    end
    subplot(3,3,5)
    if(iscell(area))
        area = char(area);
    end

    % plot_title = ['day: ' Sess{1} ', Area: ' area  ', Task: ' Task{1} ' Recordings: ' ...
    %     recordings{1} ', timebin ' num2str(time) ' PD=' num2str(PD)...
    %     ', Session: ' num2str(Sess{6})];


    % %plot tuning curve for peak freq
    % dir = [1 2 3 4 5 6 7 8];
    % P = log(spectun(:,time,freq));
    % plot(dir,P)
    % title(['PD curve for ' num2str(freq*10-9) 'Hz'])

    %plot p values
    SessNum = Sess{6};
    if(~isfile([MONKEYDIR '/mat/Field/Field_ControlTuning.' num2str(SessNum) '.mat']))
        disp('Need to run updateField_ControlTuning');
    end
    
        
    if(isfile([MONKEYDIR '/mat/Field/Field_ControlTuning.' num2str(SessNum) '.mat']))
        load([MONKEYDIR '/mat/Field/Field_ControlTuning.' num2str(SessNum) '.mat'])
        cmdstr = (['Tuning = ControlTuning.' Task{1} '.Delay.Tuning.P;']);
        eval(cmdstr)
        if ~isempty(Tuning)
            freq = [1 11 21 31 41 51 61 71 81 91 101 111 121 131 141 151 161 171 181 191];
            Tuning(find(Tuning == 0)) = 0.0001;
            semilogy(freq,Tuning)
            title('p-values')
            hold on;
        end

        cmdstr = (['Tuning = ControlTuning.' Task{1} '.Cue.Tuning.P;']);
        eval(cmdstr)
        if ~isempty(Tuning)
            freq = [1 11 21 31 41 51 61 71 81 91 101 111 121 131 141 151 161 171 181 191];
            % Replace zero values
            Tuning(find(Tuning == 0)) = 0.0001;
            semilogy(freq,Tuning,'r')
            title('p-values')
            hold on;
        end

        cmdstr = (['Tuning = ControlTuning.' Task{1} '.PostMovement.Tuning.P;']);
        eval(cmdstr)
        if ~isempty(Tuning)
            freq = [1 11 21 31 41 51 61 71 81 91 101 111 121 131 141 151 161 171 181 191];
            % Replace zero values
            Tuning(find(Tuning == 0)) = 0.0001;
            semilogy(freq,Tuning,'k')
            title('blue-delay, red-cue, black-postmove')
            ylabel('p-values')
            hold on;
        end

        plot([1 191],[0.01 0.01],'k:')

        H=gca;
        set(H,'XTick',[0 10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180 190 200])

        xticks = get(H,'XTickLabel');
        xticks(2,:)=' ';
        xticks(3,:)=' ';
        xticks(4,:)=' ';
        xticks(5,:)=' ';
        xticks(7,:)=' ';
        xticks(8,:)=' ';
        xticks(9,:)=' ';
        xticks(10,:)=' ';
        xticks(12,:)=' ';
        xticks(13,:)=' ';
        xticks(14,:)=' ';
        xticks(15,:)=' ';
        xticks(17,:)=' ';
        xticks(18,:)=' ';
        xticks(19,:)=' ';
        xticks(20,:)=' ';
        set(H,'XTickLabel',xticks)
%         plot_title = [day ', Sess: ' num2str(Sess{6}) ', ' area  ', El: ' ...
%             num2str(Sess{4})  ', Depth: ' num2str(Sess{5}{1}(1)) ', ' Task{1} ...
%             ' Rec: ' recordings{1} ', Bin: ' num2str(time) ' PD:' num2str(PD)];
%         supertitle(plot_title)
        hold on
    end

end
%set printing parameters
%orient landscape
ind = strfind(area,'_');
iind = setdiff(1:length(area),ind);
area = area(iind);
 plot_title = [day ', Sess: ' num2str(Sess{6}) ', '  area ' , El: ' ...
            num2str(Sess{4})  ', Depth: ' num2str(Sess{5}{1}(1)) ', ' Task{1} ...
            ' Rec: ' recordings{1} ', Bin: ' num2str(time) ' PD:' num2str(PD)]
        
        supertitle(plot_title)
        colorbar



