function [Fig] = sessPSTHParams(Sess, CondParams, AnalParams)
%
%   Fig = sessPSTHParams(Sess,CondParams,AnalParams)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS = N-dimensional data structure defining groupings for each PSTH 
%       CONDPARAMS(N).Task    =   Cell array of strings. Each row in the cell 
%               array is a new figure, with each cell containing 
%               a task to include for that figure.
%               'DelReachFix'
%               'DelSaccadeTouch'
%               'DelReachSaccade'
%       CONDPARAMS.sort = {N}{2} cell.  N sort criteria
%                               For each sort criterion sort is a 1,2 cell
%                                   sort{}{1} = String. Sort criterion name.
%                                       Names are fields in Trials or
%                                       calcNAME functions.
%                                   sort{}{2} = [1,1] or [1,2] Scalar.  
%                               Sort criterion values
%           Example:  To select trials with a delay period from 1-1.5s:
%                     CONDPARAMS.sort{1}{1} = 'Delay'
%                     CONDPARAMS.sort{1}{2} = [1e3,1500];
%       CONDPARAMS.Name = String.  Name for each PSTH for labels on graph
%
%   ANALPARAMS = Data structure for analysis parameters
%       ANALPARAMS.Fields   =   String/Cell array.  Alignment field and latency field
%                   Defaults to 'TargsOn'.  
%                   Example:  {'TargsOn','Go'} plots rasters sorted by 
%                   the time between 'Go' and 'TargsOn'.
%       ANALPARAMS.bn      =   Vector.  Analysis interval in ms 
%                   Defaults to [-1e3,2e3]
%       ANALPARAMS.sm      =   Scalar.  Smoothing parameter in ms
%                   Defaults to 40

%  Old Inputs:
%   TASK    =   Cell array of strings. Each row in the cell 
%               array is a new figure, with each cell containing 
%               a task to include for that figure.
%               'DelReachFix'
%               'DelSaccadeTouch'
%               'DelReachSaccade'
%               


%
%   NUMBER  =   Field Number to align events to for LookReach.
%                   Defaults to 1 
%          NOTE- this doesn't currently work in this version 
%                   for Free 3T when number is not one
%
%   DIRS    =   2D Array or Cell array of row vectors 
%                   for directions to include in each figure
%                   Defaults to all directions present
%   figITs  =   Cell array of row vectors with IntTargs to 
%                       include in each figure.
%                   Input a zero for each non-Int-sacc task before 
%                       the IntSacc task to be included on each figure.
%                   Defaults to creating a figure for each pair 
%                       of int targets in the data
%

global MONKEYDIR MONKEYNAME PSTHTASKLIST experiment


set(0,'DefaultTextVerticalAlignment','bottom','DefaultTextFontUnits','normalized') % Used to be MattsTextDefaults
number  = 1;
dirs = [];
figITs = [];
% 
% for iParams = 1:length(CondParams)
% if isfield(CondParams(iParams),'Task')
%     Task = CondParams.Task;
% else
%     Task = {'DelReachSaccade'};
% end
% end
if isfield(AnalParams,'Fields');
    Fields = AnalParams.Fields;
else
    Fields = 'TargsOn';
end
if isfield(AnalParams,'bn');
    bn = AnalParams.bn;
else
    bn = [-1e3,2e3];
end
if isfield(AnalParams,'sm');
    sm = AnalParams.sm;
else
    sm = 40;
end

Sys = Sess{3}{1}
Ch = Sess{4}(1)
Cl = Sess{5}(1)
PossibleTasks = PSTHTASKLIST;
if(exist([MONKEYDIR '/' Sess{1} '/' Sess{2}{1} '/rec' Sess{2}{1} '.experiment.mat'],'file'))
    load([MONKEYDIR '/' Sess{1} '/' Sess{2}{1} '/rec' Sess{2}{1} '.experiment.mat']);
end

Trials = sessTrials(Sess);
TwoTRewardMagTaskCode = 2;
ForcedChoiceTaskCode = 1;
%Trials = Trials([Trials.Choice] ~= TwoTRewardMagTaskCode);

% 
numfigs = 1;
% 
% %disp(['Dirs is: ' num2str(dirs{1})])
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
%disp(['Now dirs is: ' num2str(dirs{1})])

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

for iParams=1:length(CondParams)
    disp(['Now working on ' CondParams(iParams).Task])
    TrialsTmp = Params2Trials(Trials,CondParams(iParams));
    if isempty(TrialsTmp)
        error(['We have no Trials after CondParams selection'])
    end
    %    %
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
    
    Raw(iParams).Trials = TrialsTmp;
    tempn = 1;
    
    if(exist([MONKEYDIR '/' Sess{1} '/' Sess{2}{1} '/rec' Sess{2}{1} '.experiment.mat'],'file'))
        Raw(iParams).Spike = trialSpike(Raw(iParams).Trials, Sys, Ch, Cl, Field, bn, tempn);
        Raw(iParams).E = trialLPEye(Raw(iParams).Trials, Field, bn, tempn);
    else %Backwards compatiblity with pre acquire data on rig 1
        Raw(iParams).Spike = trialSpike(Raw(iParams).Trials, Sys, Ch, Cl, Field, bn, tempn);
        Raw(iPArams).E = trialLPEye(Raw(iParams).Trials, Field, bn, tempn);
    end
    %     if ~isempty(CondParams)
    %         eval(['Raw(iTask).Interval = calc' CondParams(iTask).IntervalName '(TrialsTmp);']);
    %     end
    if length(Raw(iParams).Trials) == 1 %need to reshape matrix for tasks with one trial
        Raw(iParams).E = reshape(Raw(iParams).E, 1, size(Raw(iParams).E,1), size(Raw(iParams).E,2));
    end
    
    Raw(iParams).numfigs = 0;
    if isempty(Raw(iParams).Trials)
        disp(['No Trials for ' CondParams(iParams).Task]);
    else
        disp([num2str(length(Raw(iParams).Trials)) ' Trials for ' CondParams(iParams).Task ])
        Raw(iParams).Target = getTarget(Raw(iParams).Trials);
        Raw(iParams).IntTarg = 0;%getIntTarg(Raw(iTask).Trials)';
        Raw(iParams).ITs = unique(Raw(iParams).IntTarg);
        Raw(iParams).ITs = 0;
        Raw(iParams).numfigs = Raw(iParams).numfigs+1;
        Raw(iParams).fig(1).ITs = 0;
        Raw(iParams).IntTarg = zeros(size(Raw(iParams).Target,1),1);
    end
end
Raw

disp(['Setting numplots, tasks, and ITs for each Fig'])
addedfigs = 0;
for iFig = 1:numfigs
    Fig(iFig+addedfigs).Task = {};
    Fig(iFig+addedfigs).TaskRef = [];
    Fig(iFig+addedfigs).numplots = 0;
    Fig(iFig+addedfigs).ITs = [];
    for iParams = 1:length(CondParams)
        %             TaskRef =find(strcmp(AllTasks,Task{iFig,iTask}));
        TaskRef = iParams;
        NewFigs = Raw(TaskRef).numfigs - 1;
        for iFigToAdd = 1:Raw(TaskRef).numfigs
            if iFigToAdd > 1  %Then a new figure should be initialized
                Fig(iFig+addedfigs+iFigToAdd-1).Task = {};
                Fig(iFig+addedfigs+iFigToAdd-1).numplots = 0;
                Fig(iFig+addedfigs+iFigToAdd-1).ITs = [];
            end
            for temp = 1:length(Raw(TaskRef).fig(iFigToAdd).ITs)
                Fig(iFig+addedfigs+iFigToAdd-1).Task{end+1} = CondParams(iParams).Task{1};
                Fig(iFig+addedfigs+iFigToAdd-1).TaskRef(end+1) = TaskRef;
            end
            Fig(iFig+addedfigs+iFigToAdd-1).numplots=Fig(iFig+addedfigs+iFigToAdd-1).numplots + length(Raw(TaskRef).fig(iFigToAdd).ITs);
            Fig(iFig+addedfigs+iFigToAdd-1).ITs=[Fig(iFig+addedfigs+iFigToAdd-1).ITs Raw(TaskRef).fig(iFigToAdd).ITs];
        end
        addedfigs = addedfigs + NewFigs;
        numfigs = numfigs + NewFigs;
    end
end

disp(['Assigning directions to figure'])
if nargin >= 7 && ~isempty(dirs{1}) %Assigning first cell in dirs to [] is like not inputting directions
    if size(dirs,1) ~= numfigs
        error(['Input directions should have one cell for each fig. Number of input cells is ' num2str(length(dirs)) ' and number of figures is: ' num2str(numfigs)])
    end
end

for iFig = 1:numfigs
    if nargin < 7 || isempty(dirs{1})
        Fig(iFig).dirs = [];
        FigTasks = unique(Fig(iFig).Task);
        for iTask = 1:length(FigTasks)
            tempn = 1;
            %TaskRef = find(strcmp(AllTasks,FigTasks{iTask}));
            TaskRef = iTask;
            tempdirs = unique(Raw(TaskRef).Target);
            Fig(iFig).dirs = unique([Fig(iFig).dirs tempdirs(tempdirs ~= 0)]);
            %disp(['Dirs present for ' AllTasks{TaskRef} ': ' num2str(Fig(iFig).dirs)])
        end
    else
        Fig(iFig).dirs = dirs{iFig};
    end
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
        Fig(iFig).Name{iplot} = CondParams(iplot).Task;
        TaskRef = Fig(iFig).TaskRef(iplot);
        CurIT = Fig(iFig).ITs(iplot);
        Fig(iFig).PSTHplot(iplot).PSTH = zeros(length(Fig(iFig).dirs),numtsteps);
       
        tempn = 1;
        
        for iDr = 1:length(Fig(iFig).dirs)
            CurDir = Fig(iFig).dirs(iDr);
            ind = find(Raw(TaskRef).Target == CurDir);% & Raw(TaskRef).IntTarg==CurIT);
            SelInd = [1:length(ind)];
            if ~isempty(ind)
                Fig(iFig).PSTHplot(iplot).PSTH(iDr,:) = psth(Raw(TaskRef).Spike(ind(SelInd)),bn,sm);
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
%             if ~isempty(CondParams)
%                 SelInd = CondSelIndices(Raw(TaskRef).Interval(ind), CondParams(TaskRef).IntervalDuration);
%             else
                SelInd = [1:length(ind)];
%             end
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
                    titlestr = [' ' num2str(CurNumras) ' ' CondParams(TaskRef).Name ' Trials;'];
                
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
for iParams = 1:length(CondParams)
    Fig(iFig).Name{iParams} = CondParams(1,iParams).Name;
end
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
