function [RewardDur, RewardDist, HighReward, RewardConfig, OutputTarget, ReachChoice, SaccadeChoice] = sessPrintDecisionPSTH(Sess,CondParams)
%
%   sessPlotDecisionPSTH(Sess,CondParams)
%
%   SESS    =   Cell array.  Session information
%   CondParams.TASK    =   Cell array of strings. Each row in the cell 
%               array is a new figure, with each cell containing 
%               a task to include for that figure.
%               'DelReachFix'
%               'DelSaccadeTouch'
%               'DelReachSaccade'
%               
%   CondParams.FIELDS   =   String/Cell array.  Alignment field and latency field
%                   Defaults to 'TargsOn'.    
%                   Example:  {'TargsOn','Go'} plots rasters sorted by 
%                   the time between 'Go' and 'TargsOn'.
%   CondParams.BN      =   Vector.  Analysis interval in ms 
%                   Defaults to [-1e3,1e3]
%   CondParams.SM      =   Scalar.  Smoothing parameter in ms
%                   Defaults to 40
%
%   CondParams.PlotType = string - e.g. 'Movement', or 'Correct'
%
%   CondParams = Data structure to subset specific timing conditions
%                   CondParams.IntervalName = 'STRING';
%                   CondParams.IntervalDuration = [min,max]
%                       IntervalDuration is either in ms or proportions
%                       if min and max are between 0 and 1 IntervalDuration
%                       is a proportion, otherwise a time duration in ms.
%                       For example
%                         IntervalDuration = [0,500] means time duration
%                         IntervalDuration = [0,0.5] means fastest 50% of
%                           intervals
%


global MONKEYDIR MONKEYNAME PSTHTASKLIST experiment


MattsTextDefaults
number  = 1;
dirs = [];
figITs = [];

if(isfield(CondParams,'Task'))
    Task = CondParams.Task;
    tmpTask = {};
    duplicate = 0;
    for i = 1:length(Task)
        for j = 1:length(tmpTask)
            if(strcmp(Task{i},tmpTask{j}) == 1)
                duplicate = 1;
            end
        end
        if(duplicate == 0)
            tmpTask = [tmpTask,Task{i}];
        end
        duplicate = 0;
    end
    CondParams.Task= tmpTask;
    
else
    Task = {'DelReachSaccade'};
end
if(isfield(CondParams,'Fields'))
    Fields = CondParams.Fields;
else
    if strcmp(Task,'SOA')
        Fields = 'SaccStart';
    else
        Fields = 'TargsOn';
    end
end
if(isfield(CondParams,'bn'))
    bn = CondParams.bn;
else
    bn = [-1e3,2e3];
end
if(isfield(CondParams,'sm'))
    sm = CondParams.sm;
else
    sm =  40;
end

if strcmp('char',class(Task));    Task=str2cell(Task); end

Sys = Sess{3}{1};
Ch = Sess{4}(1); 
Cl = Sess{5}(1);
PossibleTasks = PSTHTASKLIST;
if(exist([MONKEYDIR '/' Sess{1} '/' Sess{2}{1} '/rec' Sess{2}{1} '.experiment.mat']))
    load([MONKEYDIR '/' Sess{1} '/' Sess{2}{1} '/rec' Sess{2}{1} '.experiment.mat']);
end

AllTasks = Task;


if ~all(ismember(AllTasks,PossibleTasks))
    msgstr = 'Error, input task(s)'  
    tempcheck = find(~ismember(AllTasks,PossibleTasks))
    for iTask = 1:tempcheck
        msgstr = [msgstr AllTasks{tempcheck(iTask)}];        
    end
    disp([msgstr ' is not a possible task.']);
    return
end


AllTasks
Trials = sessTrials(Sess,CondParams.Task);
% subset the trials based on the condpaarams structure
Trials = subsetTrials(Trials,CondParams);

for iTask=1:length(AllTasks)
    N = length(trialTask(Trials, AllTasks{iTask}));
    if N > 0 TaskIndex(iTask) = 1; else TaskIndex(iTask) = 0; end
end

if sum(TaskIndex)
    AllTasks = AllTasks(find(TaskIndex));
else
    error('Not enough trials for any task');
end

Task = AllTasks;

numfigs = size(Task,1);
% if ~isempty(dirs)
%     if strcmp('double',class(dirs))
%         nfig = size(Task,1);
%         tempdirs = dirs;
%         clear dirs;
%         if floor(size(tempdirs,1)/size(Task,1)) == size(tempdirs,1)/size(Task,1)
%             tempdirs = repmat(tempdirs,size(tempdirs,1)/size(Task,1),1);
%         end
%             
%         if size(tempdirs,1) == size(Task,1)
%             for i = 1:size(tempdirs,1)
%                 dirs{i} = tempdirs(i,:);
%             end
%         end
%         
%         if isempty(tempdirs)
%             dirs = {[]};
%         end        
%     end
% end

% if ~isempty(figITs)
%     if strcmp('double',class(figITs))
%         nfig = size(Task,1);
%         tempITs = figITs;
%         clear figITs;
%         if floor(size(tempITs,1)/size(Task,1)) == size(tempITs,1)/size(Task,1)
%             tempITs = repmat(tempITs,size(tempITs,1)/size(Task,1),1);
%         end
% 
%         if size(tempITs,1) == size(Task,1)
%             for i = 1:size(tempITs,1)
%                 figITs{i} = tempITs(i,:);
%             end
%         end
%     end
%     if isempty(tempITs)
%         figITs = {[0]};
%     end
% end

for iTask=1:length(AllTasks)
    disp(['Now working on ' AllTasks{iTask}])

    TrialsTmp = trialTask(Trials,AllTasks{iTask});

    number_trials = size(TrialsTmp)
    if iscell(Fields)
        Field = Fields{1};
        if ~isfield(TrialsTmp,Fields{1})
            error([Fields{1} ' is not in Trials']);
        end
        if ~isfield(TrialsTmp,Fields{2})
            error([Fields{2} ' is not in Trials']);
        end
        eval(['T1 = [TrialsTmp. ' Fields{1} '];']);
        eval(['T2 = [TrialsTmp. ' Fields{2} '];']);
        [dum, trialsind] = sort(T2-T1,'ascend');
        TrialsTmp = TrialsTmp(trialsind);
    else
        Field = Fields;
    end

    Raw(iTask).Trials = TrialsTmp;
    tempn = 1;
    if(exist([MONKEYDIR '/' Sess{1} '/' Sess{2}{1} '/rec' Sess{2}{1} '.experiment.mat']))
        Raw(iTask).Spike = trialSpike(Raw(iTask).Trials, Sys, Ch, Cl, Field, bn, tempn);
        %     [Raw(iTask).E, Raw(iTask).H] = EyeHandTrial(Raw(iTask).Trials, Field, bn, tempn);
        Raw(iTask).E = trialLPEye(Raw(iTask).Trials, Field, bn, tempn);
    else %Backwards compatiblity with pre acquire data on rig 1
        Raw(iTask).Spike = trialSpike(Raw(iTask).Trials, Sys, Ch, Cl, Field, bn, tempn);
        Raw(iTask).E = trialLPEye(Raw(iTask).Trials, Field, bn, tempn);
    end
    if isfield(CondParams,'IntervalName')
        eval(['Raw(iTask).Interval = calc' CondParams(iTask).IntervalName '(TrialsTmp);']);
    end
    if length(Raw(iTask).Trials) == 1 %need to reshape matrix for tasks with one trial
        Raw(iTask).E = reshape(Raw(iTask).E, 1, size(Raw(iTask).E,1), size(Raw(iTask).E,2));
        %         Raw(iTask).H = reshape(Raw(iTask).H, 1, size(Raw(iTask).H,1), size(Raw(iTask).H,2));
    end


    Raw(iTask).numfigs = 0;
    if isempty(Raw(iTask).Trials)
        disp(['No Trials for ' AllTasks{iTask}]);
        %        return
    else
        disp([num2str(length(Raw(iTask).Trials)) ' Trials for ' AllTasks{iTask}])
        Raw(iTask).Target = calcPlotDirection(Raw(iTask).Trials,CondParams.task(iTask));
        Raw(iTask).IntTarg = 0;
        Raw(iTask).ITs = unique(Raw(iTask).IntTarg);
        Raw(iTask).ITs = 0;
        Raw(iTask).numfigs = Raw(iTask).numfigs+1;
        Raw(iTask).fig(1).ITs = 0;
        Raw(iTask).IntTarg = zeros(size(Raw(iTask).Target,1),1);
    end
end



disp(['Setting numplots, tasks, and ITs for each Fig'])
addedfigs = 0;
for iFig = 1:numfigs
    Fig(iFig+addedfigs).Task = {};
    Fig(iFig+addedfigs).TaskRef = [];
    Fig(iFig+addedfigs).numplots = 0;
    Fig(iFig+addedfigs).ITs = [];
    for iTask = 1:size(Task,2)
        if ~isempty(Task{iFig,iTask})
%             TaskRef =find(strcmp(AllTasks,Task{iFig,iTask}));
            TaskRef = iTask;
            NewFigs = Raw(TaskRef).numfigs - 1;
            for iFigToAdd = 1:Raw(TaskRef).numfigs
                if iFigToAdd > 1  %Then a new figure should be initialized
                    Fig(iFig+addedfigs+iFigToAdd-1).Task = {};
                    Fig(iFig+addedfigs+iFigToAdd-1).numplots = 0;
                    Fig(iFig+addedfigs+iFigToAdd-1).ITs = [];
                end
                for temp = 1:length(Raw(TaskRef).fig(iFigToAdd).ITs)
                    Fig(iFig+addedfigs+iFigToAdd-1).Task{end+1} = Task{iFig,iTask};
                    Fig(iFig+addedfigs+iFigToAdd-1).TaskRef(end+1) = TaskRef;
                end
                Fig(iFig+addedfigs+iFigToAdd-1).numplots=Fig(iFig+addedfigs+iFigToAdd-1).numplots + length(Raw(TaskRef).fig(iFigToAdd).ITs);
                Fig(iFig+addedfigs+iFigToAdd-1).ITs=[Fig(iFig+addedfigs+iFigToAdd-1).ITs Raw(TaskRef).fig(iFigToAdd).ITs];
            end
            addedfigs = addedfigs + NewFigs;
            numfigs = numfigs + NewFigs;
        end
    end
end
% 
% disp(['Assigning directions to figure'])
% if nargin >= 7 & ~isempty(dirs{1}) %Assigning first cell in dirs to [] is like not inputting directions
%     if size(dirs,1) ~= numfigs
%         error(['Input directions should have one cell for each fig. Number of input cells is ' num2str(length(dirs)) ' and number of figures is: ' num2str(numfigs)])
%     end
% end

for iFig = 1:numfigs
%     if nargin < 7 | isempty(dirs{1})
        Fig(iFig).dirs = [];
        FigTasks = unique(Fig(iFig).Task);
        for iTask = 1:length(FigTasks)
            tempn = 1;
            %TaskRef = find(strcmp(AllTasks,FigTasks{iTask}));
            TaskRef = iTask;
            tempdirs = unique(Raw(TaskRef).Target);
            Fig(iFig).dirs = unique([Fig(iFig).dirs tempdirs(find(tempdirs ~= 0))]);
            %disp(['Dirs present for ' AllTasks{TaskRef} ': ' num2str(Fig(iFig).dirs)])
        end
%     else
%         Fig(iFig).dirs = dirs{iFig};
%     end
end
%disp(['Dirs for figure 1 is : ' num2str(Fig(1).dirs) ' when input was: ' num2str(dirs{1})])

disp(['Assigning plotting information to each fig based on number of directions in each'])
%Set direction position look-up table
%%%%[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16]
XLU=[3 3 2 1 1 1 2 3 4 0  4  0  3  3  1  1 ];
YLU=[2 1 1 1 2 3 3 3 1 1  3  3  0  4  0  4 ];
for iFig=1:numfigs
    Fig(iFig).minx = 1;
    Fig(iFig).miny = 1;
    Fig(iFig).numxdirs = 3;
    Fig(iFig).numydirs = 3; 
    if any(Fig(iFig).dirs == 9) | any(Fig(iFig).dirs == 11)
        Fig(iFig).numxdirs = Fig(iFig).numxdirs+1;
    end
    if any(Fig(iFig).dirs==10) | any(Fig(iFig).dirs==12)
        Fig(iFig).numxdirs = Fig(iFig).numxdirs+1;
        Fig(iFig).minx = 0;
    end
    if any(Fig(iFig).dirs==13) | any(Fig(iFig).dirs==15)
        Fig(iFig).numydirs = Fig(iFig).numydirs+1;
        Fig(iFig).miny = 0;
    end
    if any(Fig(iFig).dirs==14) | any(Fig(iFig).dirs==16)
        Fig(iFig).numydirs = Fig(iFig).numydirs+1;
    end        
end

PrintPSTHFigureOptions

disp('Starting to calc PSTH''s and plot figures')
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
    
    %Initialize Title+TaskBar
    [Fig,Tit] = AddTitle(Tit,Fig,iFig);
    Fig = AddTaskBar(Fig,Tit,iFig);
        
    maxvalue = 0;
    %Find number of tsteps from 1st PSTH plot available in the first IT direction of First Task
    for iDr = 1:length(Fig(iFig).dirs)
        %TaskRef = find(strcmp(AllTasks,Fig(iFig).Task{1}));
        TaskRef = 1;
        %CurIT = Fig(iFig).ITs(1);
        CurDir = Fig(iFig).dirs(iDr);
        ind = find(Raw(TaskRef).Target == CurDir);% & Raw(TaskRef).IntTarg == CurIT);
        if ~isempty(ind)
            numtsteps = length(psth(Raw(TaskRef).Spike(ind), bn, sm));
            break
        end        
    end
    t = linspace(bn(1), bn(2), numtsteps);
    t2 = linspace(bn(1), bn(2), size(Raw(TaskRef).E,3));
    btwnDirTitleSpc = (t(end)-t(1))/Fig(iFig).numplots;
    
    %Calculate histograms, determine maxvalue, determine total number of rasters
    Fig(iFig).numras = zeros(length(Fig(iFig).dirs), Fig(iFig).numplots);
    for iplot = 1:Fig(iFig).numplots
        %TaskRef = find(strcmp(AllTasks, Fig(iFig).Task{iplot}));
        TaskRef = Fig(iFig).TaskRef(iplot);
        CurIT = Fig(iFig).ITs(iplot);
        Fig(iFig).PSTHplot(iplot).PSTH = zeros(length(Fig(iFig).dirs),numtsteps);
        
        if strcmp(AllTasks{TaskRef},'Free3T')
            tempn = number;
        else
            tempn = 1;
        end
        
        for iDr = 1:length(Fig(iFig).dirs)
            CurDir = Fig(iFig).dirs(iDr);
            ind = find(Raw(TaskRef).Target == CurDir);% & Raw(TaskRef).IntTarg==CurIT);
            if isfield(CondParams,'IntervalName')
                disp('Using CondParams')
                SelInd = CondSelIndices(Raw(TaskRef).Interval(ind), CondParams(TaskRef).IntervalDuration);
            else
                SelInd = 1:length(ind);
            end
            if ~isempty(ind)
                Fig(iFig).PSTHplot(iplot).PSTH(iDr,:) = psth(Raw(TaskRef).Spike(ind(SelInd)),bn,sm);
                A = [Raw(TaskRef).Trials(ind(SelInd)).RewardDur];
                A = reshape(A,[4,length(A)./4]);
                RewardDur{iDr,TaskRef} = A;
                A = [Raw(TaskRef).Trials(ind(SelInd)).RewardDist];
                A = reshape(A,[4,length(A)./4]);
                RewardDist{iDr,TaskRef} = A;
                A = [Raw(TaskRef).Trials(ind(SelInd)).HighReward];
                HighReward{iDr,TaskRef} = A;
                A = [Raw(TaskRef).Trials(ind(SelInd)).RewardConfig];
                RewardConfig{iDr,TaskRef} = A;
                A = [Raw(TaskRef).Trials(ind(SelInd)).Target];
                OutputTarget{iDr,TaskRef} = A;
                A = [Raw(TaskRef).Trials(ind(SelInd)).ReachChoice];
                ReachChoice{iDr,TaskRef} = A;                
                A = [Raw(TaskRef).Trials(ind(SelInd)).SaccadeChoice];
                SaccadeChoice{iDr,TaskRef} = A;               
            end
            Fig(iFig).numras(iDr,iplot) = length(SelInd);
            Fig(iFig).numplotras(iDr,iplot) = min([length(SelInd) MaxRasPerPlot]);
        end
        maxvalue = max([maxvalue max(max(Fig(iFig).PSTHplot(iplot).PSTH))]);
    end
    CovArea = CovAreaRatio*maxvalue;

    %Plot everything    
    for iplot = 1:Fig(iFig).numplots
        %TaskRef = find(strcmp(AllTasks,Fig(iFig).Task{iplot}));
        TaskRef = Fig(iFig).TaskRef(iplot);
        %CurIT = Fig(iFig).ITs(iplot);

        for iDr = 1:length(Fig(iFig).dirs)
            CurDir = Fig(iFig).dirs(iDr);
            ind = find(Raw(TaskRef).Target == CurDir);% & Raw(TaskRef).IntTarg == CurIT);
            if isfield(CondParams,'IntervalName')
                SelInd = CondSelIndices(Raw(TaskRef).Interval(ind), CondParams(TaskRef).IntervalDuration);
            else
                SelInd = [1:length(ind)];
            end
            CurNumras = length(SelInd);
            RasSpacing = CovArea/sum(Fig(iFig).numplotras(iDr,:),2);

            %Initializeaxes if its the first figure plot
            if iplot == 1
                xnum = XLU(CurDir) - Fig(iFig).minx + 1;
                ynum = YLU(CurDir) - Fig(iFig).miny + 1;
                Fig = InitializePrintDirAxes(Fig, xnum, ynum, numYTicks, maxvalue, CovArea, iFig, iDr, t, t2);
            end

            %Add Titles to histograms
            if Fig(iFig).DirTitleFontSize>0
                    titlestr = [' ' num2str(CurNumras) ' ' AllTasks{TaskRef} ' Trials;'];
                
                if Fig(iFig).numplots<3               
                    if iplot == Fig(iFig).numplots
                        titlestr = titlestr(1:end-1);
                    end
                    
                    axes(Fig(iFig).ax(iDr))
                    titlehandle = AddFittedText(titlestr, t(1)+(iplot-1)*btwnDirTitleSpc,...
                        (maxvalue+CovArea)*(1+Fig(iFig).InitDirTitleOffset),...
                        t(1)+(iplot)*btwnDirTitleSpc, 'normalized', Fig(iFig).DirTitleFontSize, 'left');
                    
                    if UseMattscolordefs
                        set(titlehandle, 'Color', Mattscolordefs(iplot,1))
                    else
                        set(titlehandle, 'Color', matlabcolordefs(ITcolors(iplot)))
                    end
                else
                    titlestr = titlestr(1:end-1);
                    
                    axes(Fig(iFig).ax(iDr))
                    titlehandle = AddFittedText(titlestr,mean([t(1) t(end)]),...
                        (maxvalue+CovArea)*(1+Fig(iFig).DirTitleFontSize*(iplot-1)+Fig(iFig).InitDirTitleOffset),...
                        t(end),'normalized',Fig(iFig).DirTitleFontSize,'center');
                    if UseMattscolordefs
                        set(titlehandle,'Color',Mattscolordefs(iplot,1))
                    else
                        set(titlehandle,'Color',matlabcolordefs(ITcolors(iplot)))
                    end
                end
            end
            %Add histogram data
            if CurNumras
                axes(Fig(iFig).ax(iDr))
                set(gca,'DrawMode','fast');
                hold on
                %disp(['Should be plotting hist line for plot: ' num2str(iplot) ' Dir: ' num2str(iDr)])
                temphand = line(t, squeeze(Fig(iFig).PSTHplot(iplot).PSTH(iDr,:)),'Color', Mattscolordefs(iplot,1));
               
            end
            
            %Add Rasters and Markers to Plots
            prevnumras = sum(Fig(iFig).numplotras(iDr,1:iplot-1),2);
            XMarks = []; YMarks = [];
            axes(Fig(iFig).ax(iDr));
            set(gca,'DrawMode','fast');
            for ras = 1:min(CurNumras,MaxRasPerPlot)
                %Add Rasters
                Alignev = eval(['Raw(TaskRef).Trials(ind(SelInd(ras))).' Field '(' num2str(tempn) ')']);
                tempypos = maxvalue + CovArea - RasSpacing*(ras+prevnumras);
                %plot(Spike{ind{iDr}(ras)}+bn(1),ones(length(Spike{ind{iDr}(ras)}),1)*tempypos,'k.','Markersize',MarkSize)
                numspikes = length(Raw(TaskRef).Spike{ind(SelInd(ras))});
                %                disp(['Plotting ' num2str(numspikes) ' spikes at ypos ' num2str(tempypos) ' for raster: ' num2str(ras) ' on fig: ' num2str(iFig) ' plot: ' num2str(iplot) ' Dir: ' num2str(iDr)])
                %                 disp(['RasSpacing is: ' num2str(RasSpacing) '; IntFrac is: ' num2str(RasIntSpaceFrac)])
                XMarks=[(Raw(TaskRef).Spike{ind(SelInd(ras))})'+bn(1); (Raw(TaskRef).Spike{ind(SelInd(ras))})'+bn(1)];

                YMarks = [ones(1,numspikes)*(tempypos+RasSpacing*(1-RasIntSpaceFrac)/2); ... 
                    ones(1,numspikes)*(tempypos-RasSpacing*(1-RasIntSpaceFrac)/2)];

                line(XMarks,YMarks, 'Color', Mattscolordefs(iplot,1));

                
                %add Markers
                for ev = 1:length(SpecMarkers)
                    tempev = eval(['Raw(TaskRef).Trials(ind(SelInd(ras))).' AllMarkers{SpecMarkers(ev)}]);
                    tempev = tempev(find(tempev)) - Alignev;
                    tempev = tempev(find(isbetween(tempev,bn)));
                    if ~isempty(tempev)
                        temphand = line(tempev, tempypos*ones(length(tempev),1), ...
                                             'Color', MarkerCode{SpecMarkers(ev)}(1), ...
                                             'Marker', MarkerCode{SpecMarkers(ev)}(2), ...
                                             'Markersize', SpecMarkerSize(SpecMarkers(ev)));
                        MarkersInFig(ev) = 1;
                        if ev == 2
                           set(temphand, 'Color', Mattscolordefs(7))
                        elseif ev == 9 | ev == 10
                           set(temphand, 'Color', Mattscolordefs(10))
                        end
                    end
                end
                
               
                
%                 %Add HandData
%                 axes(Fig(iFig).hax(iDr))
%                 tempHplot1=plot(t2,squeeze(Raw(TaskRef).H(ind(ras),1,:)),HandEyeColors(2*(iplot-1)+1));
%                 tempHplot2=plot(t2,squeeze(Raw(TaskRef).H(ind(ras),2,:)),HandEyeColors(2*(iplot-1)+2));
                
%                 if UseMattscolordefs
%                     set(tempEplot1, 'Color', Mattscolordefs(iplot,1))
%                     set(tempEplot2, 'Color', Mattscolordefs(iplot,1))
% %                     set(tempHplot1,'Color',Mattscolordefs(iplot,1))
% %                     set(tempHplot2,'Color',Mattscolordefs(iplot,1))
%                 end

            end
            %Add EyeData
            axes(Fig(iFig).eax(iDr))
            set(gca,'DrawMode','fast');
            if CurNumras
                EyeData = reshape(Raw(TaskRef).E(ind(SelInd(1:min(CurNumras,MaxRasPerPlot))),:,1:15:end),2*min(CurNumras,MaxRasPerPlot),length(t2(1:15:end)));
                line(t2(1:15:end), EyeData, 'Color',Mattscolordefs(iplot,1));
            end
            axis([myminmax(t2) -20 20])
        end
            
    end
    
%     %For VertISacc graphics, this will make each letter be as tall as each axis
%     if VertISacc&IntSaccGraphicFlag
%         HistHeight
%         axpos=get(Fig.VertSaccGraphic.axhandle,'Position')
% %        figpos=get(gcf,'Position')
%         FontSize=HistHeight/axpos(4)
%         for iLet=1:3
%             set(Fig(iFig).VertSaccGraphic.LetHandle(iLet),'FontSize',FontSize);
%         end
%     end

    %Adding a legend
    if Fig(iFig).HorzISacc
        Fig = AddPrintHorzISaccLeg(Fig, iFig, MarkersInFig, AllMarkers, SpecMarkers, MarkerCode, IntSaccLabels, UseMattscolordefs);      
    elseif Fig(iFig).VertISacc
        Fig = AddPrintVertISaccLeg(Fig, Tit, iFig, MarkersInFig, AllMarkers, SpecMarkers, MarkerCode, IntSaccLabels, UseMattscolordefs);
    else
        Fig = AddPrintNormLeg(Fig, iFig, MarkersInFig, AllMarkers, SpecMarkers, MarkerCode, UseMattscolordefs);    
    end
    
    Fig = CheckLegend(Fig, iFig, MarkersInFig);
    
    %set printing parameters
    orient landscape 
    
  %  printdlg
        
end


%close all
