function [Data]=sessPrintFFCoh(Sess,Task,Field,bn,time,freq)
%
%   Data = sessPrintFFCoh(Sess,Task,Field,bn,time,freq)
%
%   SESS    =   Cell array.  Session information
%   TASK    =   Cell array of strings. Each row in the cell 
%               array is a new figure, with each cell containing 
%               a task to include for that figure.
%               'DelReachFix'
%               'DelSaccadeTouch'
%               'DelReachSaccade'
%               
%   FIELD   =   String.  Alignment field
%                   Defaults to 'TargsOn'
%   BN      =   Vector.  Analysis interval in ms 
%                   Defaults to [-1e3,1e3]


global MONKEYDIR MONKEYNAME CONTROLTASKLIST experiment

if (nargin < 2) || isempty(Task);  Task = {'DelReachSaccade'}; end
if (nargin < 3) || isempty(Field);  Field = 'TargsOn'; end
if nargin < 4 || isempty(bn);   bn = [-1e3,2e3]; end
if nargin < 5 || isempty(time);   time = 40; end
if nargin < 6 || isempty(freq);   freq = 7; end
% if nargin < 6 || isempty(freq);   %use peak freq
%     maxP=max(max(log(spectun(:,time,1:100))));
%     [dr,freq]=find(log(spectun(:,time,1:100)) == maxP);
% end


sm =  40; 
number = 1; 
SessionType = 'FieldField';

if ischar(Task);    Task=str2cell(Task); end

Sys = Sess{3}; 
Ch = Sess{4}(1); 
Cl = Sess{5}(1);
if exist([MONKEYDIR '/' Sess{1} '/' Sess{2}{1} '/rec' Sess{2}{1} '.experiment.mat'],'file')
    if ~exist('experiment','var')
        load([MONKEYDIR '/' Sess{1} '/' Sess{2}{1} '/rec' Sess{2}{1} '.experiment.mat'])
    end
end
PossibleTasks = CONTROLTASKLIST;
% PossibleTasks={'DelReachFix','DelSaccadeTouch','DelReachSaccade',...
%     'DelReach','DelSaccade','DelSaccadethenReach','SOA',...
%     'MemoryReachSaccade','MemorySaccade','MemorySaccadeTouch'};

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

AllTasks;
%return
for iTask=1:length(AllTasks)
    N = length(sessTrials(Sess,AllTasks{iTask}));
    if N>0 TaskIndex(iTask)=1; else TaskIndex(iTask)=0; end
end

if sum(TaskIndex)
    AllTasks = AllTasks(find(TaskIndex));
else
    error('Not enough trials for any task');
end


Task = AllTasks;

numfigs = size(Task,1);

%disp(['Dirs is: ' num2str(dirs{1})])
if nargin>=7
    if strcmp('double',class(dirs))
        nfig = size(Task,1);
        tempdirs = dirs;
        clear dirs;
        if floor(size(tempdirs,1)/size(Task,1))==size(tempdirs,1)/size(Task,1)
            tempdirs = repmat(tempdirs,size(tempdirs,1)/size(Task,1),1);
        end
            
        if size(tempdirs,1)==size(Task,1)
            for i = 1:size(tempdirs,1)
                dirs{i} = tempdirs(i,:);
            end
        end
        
        if isempty(tempdirs)
            dirs = {[]};
        end        
    end
end
%disp(['Now dirs is: ' num2str(dirs{1})])

if nargin>=8
    if strcmp('double',class(figITs))
        nfig = size(Task,1);
        tempITs = figITs;
        clear figITs;
        if floor(size(tempITs,1)/size(Task,1))==size(tempITs,1)/size(Task,1)
            tempITs = repmat(tempITs,size(tempITs,1)/size(Task,1),1);
        end

        if size(tempITs,1)==size(Task,1)
            for i = 1:size(tempITs,1)
                figITs{i} = tempITs(i,:);
            end
        end
    end
    if isempty(tempITs)
        figITs = {[0]};
    end
end

for iTask = 1:length(AllTasks)
    disp(['Now working on ' AllTasks{iTask}])
    Raw(iTask).Trials = sessTrials(Sess,AllTasks{iTask});
    tempn = 1;
    if strcmp(AllTasks{iTask},'IntSacc')
        anyIntSacc = 1;
        IntSaccRef = iTask;
    end
    [Raw(iTask).E, Raw(iTask).H] = trialEyeHand(Raw(iTask).Trials,Field,bn,tempn);
    Raw(iTask).E = trialLPEye(Raw(iTask).Trials,Field,bn,tempn);
    if length(Raw(iTask).Trials)==1 %need to reshape matrix for tasks with one trial
        Raw(iTask).E = reshape(Raw(iTask).E,1,size(Raw(iTask).E,1),size(Raw(iTask).E,2)); 
        Raw(iTask).H = reshape(Raw(iTask).H,1,size(Raw(iTask).H,1),size(Raw(iTask).H,2)); 
    end
        
    Raw(iTask).numfigs = 0;
    if isempty(Raw(iTask).Trials)
        disp(['No Trials for ' AllTasks{iTask}]);        
%        return
    else
        disp([num2str(length(Raw(iTask).Trials)) ' Trials for ' AllTasks{iTask}])
        Raw(iTask).Target = getTarget(Raw(iTask).Trials);
        Raw(iTask).IntTarg = 0;%getIntTarg(Raw(iTask).Trials)';
        Raw(iTask).ITs = unique(Raw(iTask).IntTarg);
        if isempty(Raw(iTask).ITs) || Raw(iTask).ITs==0
            Raw(iTask).ITs = 0;
            Raw(iTask).numfigs = Raw(iTask).numfigs+1;
            Raw(iTask).fig(1).ITs = 0;
            Raw(iTask).IntTarg = zeros(size(Raw(iTask).Target,1),1);
        else
            for iT=1:4
                if any(Raw(iTask).ITs==iT|Raw(iTask).ITs==iT+4) %Check for IntSaccs in spec dir.
                    Raw(iTask).numfigs = Raw(iTask).numfigs + 1;
                    Raw(iTask).fig(Raw(iTask).numfigs).ITs = [];
                    if any(Raw(iTask).ITs==iT)
                        Raw(iTask).fig(Raw(iTask).numfigs).ITs = [Raw(iTask).fig(Raw(iTask).numfigs).ITs iT];
                    end
                    if any(Raw(iTask).ITs==iT+4)
                        Raw(iTask).fig(Raw(iTask).numfigs).ITs = [Raw(iTask).fig(Raw(iTask).numfigs).ITs iT+4];
                    end
                end
            end
        end
    end
end

disp(['Setting numplots, tasks, and ITs for each Fig'])
addedfigs = 0;
for iFig = 1:numfigs    
    Fig(iFig+addedfigs).Task = {};
    Fig(iFig+addedfigs).numplots = 0;
    Fig(iFig+addedfigs).ITs = [];
    if nargin > 5
        Fig(iFig+addedfigs).ITs = figITs{iFig};
        Fig(iFig+addedfigs).numplots = length(figITs{iFig});
        NonISaccTasknum = 0;
        for iTask = 1:length(figITs{iFig})
            if figITs{iFig}(iTask) % Assume that any positive input number in figITs refers to an int saccade
                Fig(iFig+addedfigs).Task{end+1} = 'IntSacc';
            else
                NonISaccTasknum = NonISaccTasknum + 1; % Assume this refers to a non-int saccade, only one plot to be made for it
                Fig(iFig+addedfigs).Task{end+1} = Task{iFig,NonISaccTasknum+ISacc};
            end
        end
    else
        for iTask = 1:size(Task,2)
            if ~isempty(Task{iFig,iTask})
                TaskRef = find(strcmp(AllTasks,Task{iFig,iTask}));
                NewFigs = Raw(TaskRef).numfigs-1;                 
                for iFigToAdd = 1:Raw(TaskRef).numfigs
                    if iFigToAdd > 1  %Then a new figure should be initialized
                        Fig(iFig+addedfigs+iFigToAdd-1).Task = {};
                        Fig(iFig+addedfigs+iFigToAdd-1).numplots = 0;
                        Fig(iFig+addedfigs+iFigToAdd-1).ITs = [];
                    end
                    for temp = 1:length(Raw(TaskRef).fig(iFigToAdd).ITs)
                        Fig(iFig+addedfigs+iFigToAdd-1).Task{end+1} = Task{iFig,iTask};
                    end
                    Fig(iFig+addedfigs+iFigToAdd-1).numplots = Fig(iFig+addedfigs+iFigToAdd-1).numplots+length(Raw(TaskRef).fig(iFigToAdd).ITs);
                    Fig(iFig+addedfigs+iFigToAdd-1).ITs = [Fig(iFig+addedfigs+iFigToAdd-1).ITs Raw(TaskRef).fig(iFigToAdd).ITs];
                end
                addedfigs = addedfigs + NewFigs;                    
                numfigs = numfigs + NewFigs;                 
            end
       end
    end
end

disp(['Assigning directions to figure'])
if nargin>=7 && ~isempty(dirs{1}) %Assigning first cell in dirs to [] is like not inputting directions
    if size(dirs,1)~=numfigs
        error(['Input directions should have one cell for each fig. Number of input cells is ' num2str(length(dirs)) ' and number of figures is: ' num2str(numfigs)])
    end
end
for iFig = 1:numfigs
    if nargin<7 || isempty(dirs{1})
        Fig(iFig).dirs = [];
        FigTasks = unique(Fig(iFig).Task);
        for iTask = 1:length(FigTasks)
            if strcmp(AllTasks{iTask},'DelReachSaccade')
                tempn = number;
            else
                tempn = 1;
            end            
            TaskRef = find(strcmp(AllTasks,FigTasks{iTask}));
            tempdirs = unique(Raw(TaskRef).Target);
            Fig(iFig).dirs = unique([Fig(iFig).dirs tempdirs(find(tempdirs~=0))]);
            %disp(['Dirs present for ' AllTasks{TaskRef} ': ' num2str(Fig(iFig).dirs)])
        end
    else
        Fig(iFig).dirs = dirs{iFig};
    end
end
%disp(['Dirs for figure 1 is : ' num2str(Fig(1).dirs) ' when input was: ' num2str(dirs{1})])

disp(['Assigning plotting information to each fig based on number of directions in each'])

for iFig=1:numfigs
    Fig(iFig).minx=1;
    Fig(iFig).miny=1;
    Fig(iFig).numxdirs=3;
    Fig(iFig).numydirs=3; 
    if any(Fig(iFig).dirs==9)||any(Fig(iFig).dirs==11)
        Fig(iFig).numxdirs=Fig(iFig).numxdirs+1;
    end
    if any(Fig(iFig).dirs==10)||any(Fig(iFig).dirs==12)
        Fig(iFig).numxdirs=Fig(iFig).numxdirs+1;
        Fig(iFig).minx=0;
    end
    if any(Fig(iFig).dirs==13)||any(Fig(iFig).dirs==15)
        Fig(iFig).numydirs=Fig(iFig).numydirs+1;
        Fig(iFig).miny=0;
    end
    if any(Fig(iFig).dirs==14)||any(Fig(iFig).dirs==16)
        Fig(iFig).numydirs=Fig(iFig).numydirs+1;
    end        
end

PrintPSTHFigureOptions

disp('Starting to calc spectra and plot figures')
for iFig = 1:numfigs
    disp(['Dirs present for Figure ' num2str(iFig) ': ' num2str(Fig(iFig).dirs)])
    MarkersInFig = zeros(1, length(SpecMarkers));
       
    %Figure and axes spacing based on ratio of dimensions
    if Fig(iFig).numydirs > Fig(iFig).numxdirs
        [Fig,Tit] = FigType(4, Fig, Tit, iFig);                
    elseif Fig(iFig).numxdirs > Fig(iFig).numydirs
        [Fig,Tit] = FigType(5, Fig, Tit, iFig);        
    else
        [Fig,Tit] = FigType(6, Fig, Tit, iFig);        
    end
    Fig(iFig).HorzISaccLegHeight = 0.04;
    
    Fig = DetectISacc(Fig, iFig);  
    Fig = SetPrintPSTHDirpos(Fig, Tit, iFig);
    
    %Create IntSacc Graphic
    if Fig(iFig).HorzISacc && Fig(iFig).IntSaccGraphicFlag
        Fig(iFig).Dirypos(2+2-Fig(iFig).miny:end) = Fig(iFig).Dirypos(2+1-Fig(iFig).miny:end-1 ) - ...
                                                        Fig(iFig).IntSaccGraphicSpace - ...
                                                        Fig(iFig).VertBetweenDirSpace;
        Fig = AddPrintHorzSaccGraphic(Fig,iFig,UseMattscolordefs);
    end
    if Fig(iFig).VertISacc && Fig(iFig).IntSaccGraphicFlag
        Fig(iFig).Dirxpos(2+2-Fig(iFig).minx:end) = Fig(iFig).Dirxpos(2+1-Fig(iFig).minx:end-1) + ...
                                                        Fig(iFig).IntSaccGraphicSpace + ...
                                                        Fig(iFig).HorzBetweenDirSpace;
                                                    Fig = AddPrintVertSaccGraphic(Fig,Tit,iFig,UseMattscolordefs);
                                                    Fig(iFig).Dirypos = Fig(iFig).Dirypos + 0.7*Fig(iFig).VertBorderSpace;
                                                    Fig(iFig).Dirxpos = Fig(iFig).Dirxpos + 0.25*Fig(iFig).HorzBorderSpace;
    end

    %Initialize Title+TaskBar
    [Fig,Tit] = AddTitle(Tit,Fig,iFig);
    Fig = AddTaskBar(Fig,Tit,iFig);
end


%-------------------------------------------------------------------------

Sess{6}
% calculate coh for each direction
Trials = sessTrials(Sess,Task);
for iDir = 1:8 
  numTrials(iDir) = length(find([Trials.Target]==iDir));
end

[trials,PD] = max(numTrials);
if PD > 4
    aPD = PD - 4;
else
    aPD = PD + 4;
end
%bn
PDCoh = sessCoherency(Sess,Task,Field,bn,{[PD]},[],[],[.5,2]);
aPDCoh = sessCoherency(Sess,Task,Field,bn,{[aPD]},[],[],[.5,2]);

PDCoh = abs(PDCoh);
tmpPDCoh = PDCoh(find(~isnan(PDCoh)));
aPDCoh = abs(aPDCoh);
tmpaPDCoh = aPDCoh(find(~isnan(aPDCoh)));
minlevel=min(min(min(tmpPDCoh)),min(min(tmpaPDCoh)));
maxlevel=max(max(max(tmpPDCoh)),max(max(tmpaPDCoh)));
%minlevel
%maxlevel
Data.PDCoh = PDCoh;
Data.aPDCoh = aPDCoh;
if minlevel ==1; minlevel = 0.95; end
if max(abs(PDCoh)) > 0
    if PD>4
        subplot(3,1,2)
        tvimage(aPDCoh(:,1:150),'CLim',[minlevel,maxlevel],'XRange',bn)
        title([num2str(numTrials(aPD)) ' trials  Dir = ' num2str(aPD)])
        colorbar
        subplot(3,1,3)
        tvimage(PDCoh(:,1:150),'CLim',[minlevel,maxlevel],'XRange',bn)
        title([num2str(numTrials(PD)) ' trials  Dir = ' num2str(PD)])
        colorbar
    else
        subplot(3,1,2)
        tvimage(PDCoh(:,1:150),'CLim',[minlevel,maxlevel],'XRange',bn)
        title([num2str(numTrials(PD)) ' trials  Dir = ' num2str(PD)])
        colorbar
        subplot(3,1,3)
        tvimage(aPDCoh(:,1:150),'CLim',[minlevel,maxlevel],'XRange',bn)
        title([num2str(numTrials(aPD)) ' trials  Dir = ' num2str(aPD)])
        colorbar
    end
end


%set printing parameters
orient landscape
