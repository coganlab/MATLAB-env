function varargout = Main(varargin)
% MAIN Application M-file for Main.fig
%    FIG = MAIN launch Parent_GUI GUI.
%    MAIN('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 12-Dec-2008 11:42:57

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The Acquire GUI which treis to encompass the functionality of all other
% GUIS that have run on the three rigs in the Pesaran Lab. 
%
% Add notes on the main functionality and variables
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global experiment
global Buffer Rec DT SAMPLING TrialData
global DEBUG TASKCELL
global MAXCOND
global MONKEYRECDIR MONKEYDIR
global MONKEYNAME
global HISTEXIST LFPEXIST
global MONKEY MT1 TASKLIST TARGET 
global DEPTH
global NUMELECTRODES NUMRAST
global NUMTASKTYPE
global ACQUISITION_SYSTEM;
global RECORDING_INITIALISED;
global electrode_type microdrive_type

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Before this initialisation routines that make the generalised code below work for
% each animal, acquisition system, microdrive and experiment type are run.
% These initialisation scripts also configur the hadware.
%
% If changes or additions are made to the definition files, these edits
% must be documented on the Pesaran lab wiki.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
microdrive_definition_file;
electrode_definition_file;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Note: From this point on, all code must be common for all rigs. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NUMELECTRODES = 0;
for i = 1:length(experiment.hardware.acquisition)
    NUMELECTRODES = NUMELECTRODES + experiment.hardware.acquisition(i).num_channels;
end

SAMPLING = experiment.hardware.acquisition(1).samplingrate;

%%%%%%%%%%%%%%%%%%%%
% What does DT stand for???? - YW
DT = SAMPLING./1e3;

MONKEYDIR = experiment.software.base_path;
MONKEYRECDIR =[experiment.recording.base_path '/' experiment.recording.day];

Rec.NumTrials = zeros(1,length(experiment.acquire.recording.task.type_names));

ACQUISITION_SYSTEM = 1;
NUMTASKTYPE = 10;
NUMRAST = 10;
MAXCOND = 14;  %  Maximum trial condition number
DEBUG = 0;  % Set to 1 to stop Node communication
% TASKLIST = {'FreeGaze','LookReach','Reach','Saccade','SOA'};
% TASKCELL = {'Sensors','Touch','Fixate','Touch and Fixate',...
%     'Suppress Reach','Suppress Reach and Fixate','Suppress Saccade',...
%     'Suppress Saccade and Touch','Suppress Reach and Saccade',...
%     'Delayed Reach','Delayed Reach and Fixate','Delayed Saccade',...
%     'Delayed Saccade and Touch','Delayed Reach and Saccade',...
%     'Memory Reach','Memory Reach and Fixate','Memory Saccade',...
%     'Memory Saccade and Touch','Memory Reach and Saccade',...
%     'Delayed Reach then Saccade','Delayed Saccade then Reach',...
%     'Stimulus Onset Asynchrony','Memory Stimulus Onset Asynchrony',...
%     'Race Reach','Race Saccade','Race Reach and Saccade',...
%     'Eye Calibration','Color Discrimination','Color Discrimination Proximate',...
%     'Delay Race Reach','Delay Race Saccade','Delay Race Reach and Saccade',...
%     'Memory Race Reach','Memory Race Saccade','Memory Race Reach and Saccade',...
%     'Immediate Double Step','PostSacc Double Step','PeriReach Double Step',...
%     'PostReach Double Step','Saccade Double Step','Immediate Saccade Double Step'...
%     'Memory PeriReach Double Step'};


RECORDING_INITIALISED = 0;

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

    set(fig,'Name','Main Control Panel');
    %/**********************************/
    %eval('jug_doublemt');
    set(handles.edDirectory,'String',MONKEYDIR);    
    set(handles.edRecDir,'String',MONKEYRECDIR);
    %  Rec is a data structure containing the recording parameters
    Rec = InitRec;
    
    TARGET = zeros(2,NUMELECTRODES);
    LFPEXIST = zeros(2,NUMELECTRODES);

%     InitDir(handles); Completed ininit_recording_defn
    InitLabview(handles);
%     handles = InitField(handles);
%     handles = InitSpikeField(handles);
%     handles = InitSpike(handles);
%     handles = InitStim(handles);
%     handles = InitHist(handles);
    handles = InitMain(handles);
  
    %  TrialData is a data structure containing the trial event data
    TrialData = InitTrialData(100);
    set(handles.tbStartLooping1,'UserData',TrialData);

    if nargout > 0
		varargout{1} = fig;
	end

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

    try
        if (nargout)
            [varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
        else
            feval(varargin{:}); % FEVAL switchyard
        end
    catch
        disp(lasterr);
    end
end
% --------------------------------------------------------------------
function varargout = pbStartUp(h, eventdata, handles, varargin)

    global Buffer experiment
    
    disp('Initialise Buffers');
    Buffer = InitBuffer;
    %[tcpsocket,tcpread,tcpwrite] = acquire_microdrive_initialize;
    
    RecordingTypeValue = get(handles.popType,'Value');
    RecordingTypeString = get(handles.popType,'String');
    RecordingType = RecordingTypeString{RecordingTypeValue};
    if strcmp(RecordingType,'Recording')
        for i = 1:length(experiment.hardware.microdrive)
            for j = 1:length(experiment.hardware.microdrive(i).electrodes)
                figure_name = ['Electrode ' experiment.hardware.microdrive(i).electrodes(j).label];
                disp(['Starting Electrode Panel ' figure_name ])
                experiment.hardware.microdrive(i).electrodes(j).electrode_panel.figure_handle = openfig('ElectrodePanel','new')
                figure_handle = experiment.hardware.microdrive(i).electrodes(j).electrode_panel.figure_handle;
                set(figure_handle,'Name',figure_name);
                set(figure_handle,'DoubleBuffer','On');
                set(figure_handle,'Renderer','OpenGL');
                set(figure_handle,'HandleVisibility','on');
                experiment.hardware.microdrive(i).electrodes(j).electrode_panel.figure_handle = figure_handle;
              
                disp('Generate Electrode Panel handles and set the properties')
                experiment.hardware.microdrive(i).electrodes(j).electrode_panel.gui_handle = guihandles(figure_handle);
                guidata(experiment.hardware.microdrive(i).electrodes(j).electrode_panel.figure_handle, experiment.hardware.microdrive(i).electrodes(j).electrode_panel.gui_handle);
                %set(handles.frControl,'UserData',Control);
                tmp_handle = experiment.hardware.microdrive(i).electrodes(j).electrode_panel.gui_handle;
                Title = [experiment.hardware.microdrive(i).electrodes(j).label];
                set(tmp_handle.stTitle,'String',Title);
                set(tmp_handle.puChannel,'String',{'Raw','Mu','Lfp'});
                
                if(experiment.software.microdrive(i).control.available == 0)
                    set(tmp_handle.Electrode_Microdrive_Controls,'visible', 'off')
                    set(tmp_handle.Electrode_Automatic,'Visible','off')
                end
                experiment.hardware.microdrive(i).electrodes(j).electrode_panel.gui_handle = tmp_handle;
                %set(handles.frControl,'UserData',Control);
                set(gcf,'Units','Pixels');
                Pos = [466*(j-1),(i-1)*496,450,436];
                set(gcf,'Position',Pos);
            end
        end
    end
disp('Ending StartUp')
set(handles.pbStartUp,'Visible','off')

%-------------------------------------------------------------------------
    function varargout = tbStartLooping1_Callback(h, eventdata, handles, varargin)

        
        global Buffer TARGET Rec DT SAMPLING MONKEYDIR CONTROLTASKLIST CONTROLCONDLIST Interval 
        global DEBUG NUMELECTRODES
        global SYSTEM MONKEYRECDIR
        global HISTEXIST LFPEXIST GUITASKLIST
        global RestartFlag
        global experiment
        
        RestartFlag=0;
        
        CODE.StartOn = 1;
        CODE.Success = 7;
      
        TIMELIMIT = 50*60;  %  50 minutes
        SaturationTime = zeros(1,NUMELECTRODES);
        oldRaw = zeros(NUMELECTRODES,42);

        if get(h,'Value') == 1  %  If Value

            NewTrial = 0;  
            Loop = 0;
            Interval.StartTime = acquire_get_time_stamp(experiment.hardware.acquisition(1).type);
            CurrentTrial = acquire_get_trial(experiment.hardware.acquisition(1).type);

            Interval.StopTime = 0;
            Interval.Length = str2double(get(handles.edInterval,'String'))*1e3;
            set(handles.edInterval,'Style','Text');
            set(handles.tbStartLooping1,'String','Stop Looping');
            disp('Start Looping')
            while(get(h,'Value'))   %  While value
                Loop = Loop+1;

                 TD = get(handles.tbStartLooping1,'UserData');
%                 Electrode = get(handles.frElectrode,'UserData');
%                 Control = get(handles.frControl,'UserData');
%                 Hist = get(handles.frHist,'UserData');
%                 Spike = get(handles.frSpike,'UserData');
%                 Stim = get(handles.frStim,'UserData');
%                 Field = get(handles.frField,'UserData');
%                 SpikeField = get(handles.frSpikeField,'UserData');


                RecordingTypeValue = get(handles.popType,'Value');
                RecordingTypeString = get(handles.popType,'String');
                RecordingType = RecordingTypeString{RecordingTypeValue};
                if strcmp(RecordingType,'Recording')
                    disp('Logging here')
                    Logging(handles);
                    disp('Done logging here')
                elseif strcmp(RecordingType,'Behavior')
                end

                if get(handles.tbStartRecording,'Value')==1
                    disp('Recording');
                    RECORDING = 1;
                    time = etime(clock,Rec.StartTime);
                    mins = floor(rem(time,3600)./60);
                    secs = floor(time-60*mins);
                    TimeString = sprintf('%d.%d',mins,secs);
                    set(handles.stTime,'String',TimeString);
                    RecNum = Rec.prenum;           
                    Date =  [datestr(date,11),datestr(date,5),datestr(date,7)];
                    File = dir([MONKEYRECDIR '/' Date '/' RecNum '/rec' RecNum '.dat']);

                  %  FileSizeString = [num2str(round(File.bytes./1024./1024)) ' MB'];
                  %  set(handles.stFileSize,'String',FileSizeString);
                    if time > TIMELIMIT
                        disp('File size too large.  Restart recording')
                        set(handles.tbStartRecording,'Value',0);
                        RestartFlag = 1;
                    end
                else 
                    if RestartFlag
                        set(handles.tbStartRecording,'Value',1);
                        RestartFlag = 0;
                        handles = myRestartRecording(handles);
                        RECORDING = 1;
                    else
                        RECORDING = 0;
                    end
                end
                drawnow
                LagString = num2str((acquire_get_time_stamp(experiment.hardware.acquisition(1).type)-...
                    Interval.StartTime-Interval.Length)./1e3);
                set(handles.stLag,'String',[LagString 's']);
                disp(['We are lagging by ' LagString ' secs'])
                
                myWaitTime(experiment.hardware.acquisition(1).type,Interval.StartTime+Interval.Length);
                Interval.StopTime = acquire_get_time_stamp(experiment.hardware.acquisition(1).type);
                drawnow;
                SpikeBuffer = 1e3*str2double(get(handles.edSpikeBuffer,'String'));
                if strcmp(RecordingType,'Recording')
                    acquisitionid = experiment.hardware.microdrive(1).electrodes(3).acquisitionid;
                    channelid =  experiment.hardware.microdrive(1).electrodes(3).channelid;

                    Raw = acquire_get_electrode_raw_interval(experiment.hardware.acquisition(1).type, acquisitionid, channelid, Interval.StartTime,Interval.StopTime);
                    Mu = acquire_get_electrode_mu_interval(experiment.hardware.acquisition(1).type, acquisitionid, channelid, Interval.StartTime,Interval.StopTime,SpikeBuffer);


                    UpdateRawBuffer(Raw);
                    UpdateMuBuffer(Mu);

                    tmp = [oldRaw,Raw(:,1:end-42)];
                    Mutmp = Mu(:,end-size(Raw,2)+1:end);
                    Lfp = tmp(:,1:DT:end) - Mutmp(:,1:DT:end);
                    %Lfp = Raw(:,1:DT:end) - Mu(:,1:DT:end);
                    oldRaw = Raw(:,end-41:end);
%                     for iCh = 1:size(Raw,1);
%                         FieldName = ['stGain' num2str(iCh)];
%                         if length(find(Raw(iCh,:)<1-2048 | Raw(iCh,:)>4094-2048))
%                             set(handles.(FieldName),'BackGroundColor','r');
%                             SaturationTime(iCh) = Interval.StartTime;
%                         elseif Interval.StartTime-SaturationTime(iCh) > 5e3
%                             set(handles.(FieldName),'BackgroundColor',[.702,.702,.702]);
%                         end
%                     end

                    Eye = acquire_get_behavior_eye(experiment.hardware.acquisition(1).type, Interval.StartTime,Interval.StopTime);

                    UpdateLfpBuffer(Lfp);
                    drawnow
                    LfpInd = [find(LFPEXIST(1,:)), SYSTEM(1).NumElectrodes+find(LFPEXIST(2,:))];
                    drawnow
                else
                    Raw = [];  Mu = [];
                end
                Buffer.State
                %%%%%%
                %%% hese values should be changed to globals with a
                %%% descrition of why the buffer size was chosen
                %%%%%%

                State = acquire_get_behavior_state(experiment.hardware.acquisition(1).type);
                State = State(:,find(State(3,:)>=Interval.StartTime & State(3,:)<Interval.StopTime));
                UpdateStateBuffer(State);
                 

                %
                %   Stim code
                %         Stim = getstim(200);
                %         Stimind = find(Stim(2,:)>Interval.StartTime & ...
                %             Stim(2,:)<Interval.StopTime+1);
                %         if length(Stimind)
                %             Stim = Stim(:,Stimind);
                %             disp(['Updating Stim buffer with ' num2str(length(Stimind)) ' stims *******************************'])
                %             UpdateStimBuffer(Stim);
                %         end
                Buffer.Time = Interval.StopTime;
                drawnow;
                
                
                
                if strcmp(RecordingType,'Recording')
                    for i = 1:length(experiment.hardware.microdrive)
                        for j = 1:length(experiment.hardware.microdrive(i).electrodes)
                            disp(['Microdrive ' num2str(i) '.  Electrode ' num2str(j)]);
                            SpikeCh = (i-1)*length(experiment.hardware.microdrive(i).electrodes) + j;
                            
                            Control_Handles = Control.Handles{MT,Num};

                            Channel = get(Control_Handles.puChannel,'Value');
                            Time = str2double(get(Control_Handles.edTime,'String'));
                            Range = str2double(get(Control_Handles.edRange,'String'));
                            Thresh = str2double(get(Control_Handles.edThreshold,'String'));
                            K = str2double(get(Control_Handles.edClusters,'String'));
                            %                     if length(Stim.Figures{Drive,Num})
                            %                         disp('Processing Stim data');
                            %                         Stim_Handles = Stim.Handles{Drive,Num};
                            %                         ProcStim(handles, Drive, Num, Interval);
                            %                         DisplayString = get(Stim_Handles.popDisplay,'String');
                            %                         DisplayValue = get(Stim_Handles.popDisplay,'Value');
                            %                         Display = DisplayString{DisplayValue};
                            %                         switch Display
                            %                         case 'Stim All'
                            %                             disp('Stim All Display');
                            %                             UpdateStimAllDisplay(Stim_Handles, Drive, Num);
                            %                             disp('Done updating display');
                            %                         case 'Stim Trial'
                            %                             disp('Stim Trial Display');
                            %                         end
                            %                     end
                            if get(Control_Handles.tbSort,'Value')  %  If  Sort
                                Sort = get(Control_Handles.tbSort,'UserData');
                                StanDev = Sort.SD; PC = Sort.PC; Centers = Sort.Centers;
                                Sort.Mean
                                [sp,sptimes] = spikeextract(Mu(SpikeCh,:)-Sort.Mean, Thresh*StanDev);
                                drawnow
                                spwave = sp;
                                %  Convert spike times to circular buffer times
                                sptimes = round(sptimes)+Interval.StopTime-SpikeBuffer;

                                if size(sp,1) > 20  %  If spikes
                                    fet = spwave*PC;
                                    [Centers,options,post] = kmeans(fet,K,Centers);
                                    spid = zeros(1,length(sptimes));
                                    for c = 1:K
                                        spid(1,find(post(:,c)>0)) = c;
                                    end
                                    [dum,cind] = sort(sqrt(sum(Centers'.^2)));
                                    Centers = Centers(cind,:);
                                    Sort.Centers = Centers;
                                    set(Control_Handles.edClusters,'UserData',Sort);
                                    MDist = UpdatePCPlot(Control_Handles,fet,post,K,Centers);
                                    %                     UpdateSpPlot(Control_Handles,spwave,spid);
                                    drawnow
                                else
                                    spid = ones(1,length(sptimes));
                                    MDist = zeros(1,2);
                                end             %  End if spikes
                                spind = find(sptimes > Interval.StartTime);
                                SpTimes = sptimes(spind)';
                                SpId = spid(spind);
                                disp('Assigning Sp');
                                Sp = zeros(length(SpTimes),2);
                                if size(Sp,1) > 0  %  If Sp
                                    Sp(:,1) = SpTimes';  Sp(:,2) = SpId';
                                    %  Put spike times in matlab buffer with respect to C buffer time
                                    UpdateSpTimesBuffer(Sp,SpikeCh);
                                    disp('Check if spike figure');
                                    if length(Spike.Figures{MT,Num})
                                        disp(['Processing STA data for ' num2str(MT) ' and ' num2str(Num)]);
                                        ProcSTA(handles, MT, Num, Interval, SpTimes, Raw);
                                        Spike_Handles = Spike.Handles{MT,Num};
                                        DisplayString = get(Spike_Handles.popDisplay,'String');
                                        DisplayValue = get(Spike_Handles.popDisplay,'Value');
                                        Display = DisplayString{DisplayValue};
                                        switch Display
                                            case 'STA All'
                                                disp('STA All Display');
                                                UpdateSTAAllDisplay(Spike_Handles, MT, Num);
                                            case 'STA Trial'
                                                disp('STA Trial Display');
                                        end
                                    end
                                    drawnow
                                end         %  End if Sp

                                drawnow
                            else
                                MDist = zeros(1,2);
                            end             %  End if sort
                            set(Control_Handles.edClusters,'UserData',MDist);
                            Time = str2double(get(Control_Handles.edTime,'String'));
                            switch Channel  %  Switch channel
                                case 1  % Raw
                                    UpdatePlot(Control_Handles,Raw(SpikeCh,1:DT*Time),'Raw',Time,Range);
                                    disp('Updating Raw')
                                case 2  % Mu
                                    UpdatePlot(Control_Handles,Mu(SpikeCh,1:DT*Time),'Mu',Time,Range);
                                    disp('Updating MU')
                                case 3  % Lfp
                                    UpdatePlot(Control_Handles,Lfp(SpikeCh,1:Time),'Lfp',Time,Range);
                                    disp('Updating Lfp')
                            end             %  End switch channel
                            %  UpdateElectrode(Drive, Num, Serial,
                            %  Control_Handles)  %  This is for automatic control
                            drawnow;
                        end    
                    end         
                end

                disp('Checking for successful trial');
                Buffer.State(2,:)
                TrialSuccess = Buffer.State(1,find(Buffer.State(2,:)==CODE.Success));
                TimeSuccess = Buffer.State(3,find(Buffer.State(2,:)==CODE.Success));
                NTrials = 0;
                if TrialSuccess
                    NewTrials = TrialSuccess(find(TrialSuccess > CurrentTrial ...
                        & TimeSuccess-500<Buffer.Time));
                    NewTrials = sort(NewTrials);
                    NTrials = length(NewTrials);
                else
                    NTrials = 0;
                end
                disp([num2str(NTrials) ' successful trial(s)']);

                if NTrials  %  If NTrials
                    for CurrentTrial = NewTrials(1):NewTrials(end)       %  For Trials.  Start trial loop to update histograms
                        disp(['Successful trial.  Number ' num2str(CurrentTrial)]);
                        %disp('Getting successful trial events');
                        evs = Buffer.State(:,find(Buffer.State(1,:)==CurrentTrial));
                        [dum,evs_ind] = sort(evs(3,:));
                        evs = evs(:,evs_ind);
                        evs'
                        disp('Assigning StartOn')
                        Ind_StartOn = find(evs(2,:)==CODE.StartOn);
                        StartOn = evs(3,Ind_StartOn);
                        Tasks = get(handles.popTaskController,'String');
                        Task = Tasks{get(handles.popTaskController,'Value')};
                        TD.currentTrial = TD.currentTrial + 1;
                        if TD.currentTrial > TD.bufferSize; TD.currentTrial = 1; end
                        %SpecBuffer = get(handles.frSpecBuffer,'UserData');
                        TD = getTaskCodes(evs,TD,Ind_StartOn,Task);
                        TaskType = 0;
                        TD.TaskCode(TD.currentTrial);
                        CurrentCond = TD.Target(TD.currentTrial);
                        disp('Assigning CurrentTask')
                        [CurrentTask, TaskType] = assignCurrentTask(TD);
                        
                        if RECORDING
                            disp('Assigning trial counter')
                            size(Rec.NumTrials)
                            TaskType
                            CurrentTask
                            for i = 1:length(TaskType)
                                if(TaskType < 10)
                                    Rec.NumTrials(TaskType(i)) = Rec.NumTrials(TaskType(i)) + 1
                                end

                                switch TaskType(i)
                                    case 1
                                        set(handles.rec_count_out_1,'String',num2str(Rec.NumTrials(TaskType(i))));
                                    case 2
                                        set(handles.rec_count_out_2,'String',num2str(Rec.NumTrials(TaskType(i))));
                                    case 3
                                        set(handles.rec_count_out_3,'String',num2str(Rec.NumTrials(TaskType(i))));
                                    case 4
                                        set(handles.rec_count_out_4,'String',num2str(Rec.NumTrials(TaskType(i))));
                                    case 5
                                        set(handles.Rec_Panel,'String',num2str(Rec.NumTrials(TaskType(i))));
                                    case 6
                                        set(handles.Rec_Panel,'String',num2str(Rec.NumTrials(TaskType(i))));
                                    case 7
                                        set(handles.rec_count_out_6,'String',num2str(Rec.NumTrials(TaskType(i))));
                                    case 8
                                        set(handles.rec_count_out_7,'String',num2str(Rec.NumTrials(TaskType(i))));
                                    case 9
                                        set(handles.rec_count_out_8,'String',num2str(Rec.NumTrials(TaskType(i))));
                                    case 10
                                end
                            end
                        end
                        Task
                        TD = getStateCodes(evs,TD,Ind_StartOn,Task,CurrentTask);
                        End = TD.End(TD.currentTrial);
                            if ismember(CurrentTask,GUITASKLIST)  & ismember(CurrentCond,CONTROLCONDLIST)

                                Tapers = [str2double(get(handles.edN,'String')),str2double(get(handles.edW,'String'))];
                                Nwin = str2double(get(handles.edN,'String'))*1e3;  %  Nwin is in ms
                                dn = str2num(get(handles.edDn,'String'));
                                fk = str2num(get(handles.edFk,'String'));
                                bn = [str2num(get(handles.edStart,'String')),str2num(get(handles.edStop,'String'))];
                                Tuning = str2num(get(handles.edTuning,'String'));
                                Win = ((Tuning-bn(1))./dn)+1;
                                FieldString = get(handles.popAlignField,'String');
                                FieldValue = get(handles.popAlignField,'Value');
                                FieldName = FieldString{FieldValue};
                                myStart = StartOn + TD.(FieldName)(TD.currentTrial) + bn(1) - Nwin./2;
                                myStop = StartOn + TD.(FieldName)(TD.currentTrial) + bn(2) + Nwin./2;
                                myLfp = myGetLfpInt(myStart,myStop);
                                whos myLfp
                                nt = size(myLfp,2);% dn = 100; fk=100;
                                nwin = floor((nt-Nwin)./dn);           % calculate the number of windows
                                K = floor(2*Tapers(1)*Tapers(2)-1);
                                nf = max(256, 2*2^nextpow2(Nwin+1));
                                nfk = floor(fk./1e3.*nf);
                                X_Lfp = zeros(size(myLfp,1),K,nwin,nfk)+ complex(0,1)*zeros(size(myLfp,1),K,nwin,nfk);
                                if length(LfpInd)
                                    disp('Processing Spec Buffer')
                                    X_Lfp(LfpInd,:,:,:)=projField(myLfp(LfpInd,:),Tapers,bn,dn./1e3,fk); % [Ch,K,T,F]
                                    SpecBuffer.X_Lfp(SpecBuffer.CurrentTr,LfpInd,:,:) = abs(X_Lfp(LfpInd,:,Win,:));
                                    SpecBuffer.Cond(SpecBuffer.CurrentTr) = CurrentCond;
                                    SpecBuffer.Task{SpecBuffer.CurrentTr} = CurrentTask;
                                    SpecBuffer.CurrentTr = SpecBuffer.CurrentTr + 1;
                                    SpecBuffer.NumTrials = SpecBuffer.NumTrials + 1;
                                    if SpecBuffer.CurrentTr > SpecBuffer.Length; SpecBuffer.CurrentTr = 1; end
                                end
%                                 for MT1 = 1:2    %  For MT1
%                                     for Num1 = 1:SYSTEM(MT1).NumElectrodes  %  For Num1
%                                         for MT2 = 1:2  %  For MT2
%                                             for Num2 = 1:SYSTEM(MT2).NumElectrodes  % For Num2
%                                                 if length(Field.Figures{MT1,Num1,MT2,Num2})  %  If Field
%                                                     disp(['Processing Field data for MT ' num2str(MT1) ...
%                                                         ' and ' num2str(Num1) ' and MT ' num2str(MT2) ' and ' num2str(Num2)]);
%                                                     ProcField(handles, MT1, Num1, MT2, Num2, ...
%                                                         X_Lfp, CurrentTask, CurrentCond, SpecBuffer.CurrentTr-1);
%                                                 end   %  End if Field
%                                                 drawnow
%                                             end  %  End for Num2
%                                         end   %  End for MT2
%                                     end    %  End for Num1
%                                 end  %  End for MT1
%                             end
                            for i = 1:length(experiment.hardware.microdrive)
                                for j = 1:length(experiment.hardware.microdrive(i).electrodes)
                                        SpikeCh = (i-1)*length(experiment.hardware.microdrive(i).electrodes) + j;
                                        Electrode_Panel_Handle = experiment.hardware.microdrive(i).electrodes(j).electrode_panel.gui_handle;
                                        for Cell = 1:2  %  For Cell
                                            histogram_handle = experiment.hardware.microdrive(i).electrodes(j).histogram_panel.gui_handle;
                                            Hist = experiment.hardware.microdrive(i).electrodes(j).histogram_panel;
                                            if length(histogram_handle) && get(Electrode_Panel_Handle.tbSort,'Value')  %  If Hist
                                                disp(['Getting Spike trial data for drive ' num2str(MT1) ...
                                                    ' electrode ' num2str(Num1) ' cell ' num2str(Cell)]);
                                                 Get spike times from matlab buffer aligned to trial start
                                                SpTimesTrial = myGetSpInt(SpikeCh,StartOn,End) - StartOn;
                                                histogram_handle = Hist.gui_handle;
                                                Hist_Data = Hist.Data(MT1,Num1,Cell).RasterData;
                                                Hist_Data = UpdateRasterData(Hist_Data,SpTimesTrial,TD);
                                                Hist.Data(MT1,Num1,Cell).RasterData = Hist_Data;
                                                UpdateRasters(histogram_handles,SpTimesTrial,TD);
                                            end                                     %  End if Hist
                                        end           
%                                         for MT2 = 1:2    
%                                             if SYSTEM(MT2).MT      
%                                                 for Num2 = 1:SYSTEM(MT2).NumElectrodes  % For Num2
%                                                     if length(SpikeField.Figures{MT1,Num1,MT2,Num2})  % if SpikeField
%                                                         disp(['SpikeField data for ' num2str(MT1) ' and ' num2str(Num1) ...
%                                                             ' and ' num2str(MT2) ' and ' ]);
%                                                         mySpike = myGetSpInt(SpikeCh,myStart,myStop);
%                                                         mySpike = mySpike-myStart;
%                                                         mySpikeTS = zeros(1,myStop-myStart);
%                                                         mySpikeTS(mySpike) = 1;
%                                                         X_Spike = projSpike(mySpikeTS,Tapers,bn,0.05,100);
%                                                         ProcSpikeField(handles, MT1, Num1, MT2, Num2, ...
%                                                             X_Spike, X_Lfp, CurrentTask, CurrentCond);
%                                                         UpdateSpikeFieldDisplay(SpikeField_Handles, MT1, Num1, ...
%                                                             MT2, Num2);
%                                                     end           
%                                                     drawnow
%                                                 end             
%                                             end                    
%                                         end   
                                        drawnow;
                                    end     
                                end             
                            end
%                             set(handles.frSpecBuffer,'UserData',SpecBuffer);
%                             set(handles.frHist,'UserData',Hist);
                            set(handles.tbStartLooping1,'UserData',TD);
                    end                 %  End for trials
                end                     %  End if trials
                disp('End if successful trials');
                drawnow;
                Interval.StartTime = Interval.StopTime;
                drawnow
            end         %  End while Value
        else
            disp('Stop Looping')
            set(handles.edInterval,'Style','edit');
            set(handles.tbStartLooping1,'String','Start Looping');
        end             %  End if Value

%---------------------------------------------------------------------------
function varargout = tbStartRecording(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.pushbutton1.
global experiment
global SYSTEM MONKEYNAME Rec SAMPLING NUMELECTRODES
global NUMTASKTYPE ACQUISITION_SYSTEM
%Control = get(handles.frControl,'UserData');
%tcpread = Control.TCPRead;
%tcpwrite = Control.TCPWrite;
if (get(h,'Value') == get(h,'Max'))
    disp('Starting recording');
    set(h,'String','STOP');
   
    %  Increment recording number
    experiment.recording.number = experiment.recording.number + 1;
    set(handles.stRecNum,'String',['Recording: ' num2str(experiment.recording.number)]);
    %  Get filenames 
    directory = get(handles.edRecDir,'String');
    prenum = myPrenum(experiment.recording.number);
    Rec.prenum = prenum;
    if ~isdir([directory '/' prenum])
        disp([directory '/' prenum ' does not exist']);
        unix(['mkdir ' directory '/' prenum]);
    else
        disp([directory '/' prenum ' does exist']);
    end
    
    Rec.Filename = [directory '/' prenum '/rec'  prenum '.dat'];
    Rec.Paramsname = [directory '/' prenum '/rec'  prenum '.Rec.mat'];
    Rec.LogName = [directory '/' prenum '/rec'  prenum '.electrodelog.txt'];
    data_directory = [directory '/' prenum ];
    record_file = ['rec' prenum];
    Rec.StartTime = clock;
    if ACQUISITION_SYSTEM == 0
        for iGain = 1:NUMELECTRODES
            eval(['hh = handles.edGain' num2str(iGain)]);
            set(hh,'Style','text');
            Rec.Gain(iGain) = str2double(get(hh,'String'));
        end
    end
        
        Rec.Monkey = MONKEYNAME;
        Rec.Fs = SAMPLING;
        Rec.Ch = zeros(1,2);
        for iMT = 1:2
            Rec.Ch(iMT) = SYSTEM(iMT).NumElectrodes;
        end

        Type_tmp = get(handles.popType,'String');
        Rec.Type = Type_tmp{get(handles.popType,'Value')};
        disp(['Recording type is ' Rec.Type]);

        Chamber_tmp = get(handles.popMT1,'String');
        Chamber_tmp{get(handles.popMT1,'Value')}
        Rec.MT1 = Chamber_tmp{get(handles.popMT1,'Value')}
        Chamber_tmp = get(handles.popMT2,'String');
        Rec.MT2 = Chamber_tmp{get(handles.popMT2,'Value')}
        StimChamber_tmp = get(handles.popStimMT,'String');
        Rec.StimChamber = StimChamber_tmp{get(handles.popStimMT,'Value')};
        StimElectrode_tmp = get(handles.popStimElectrode,'String');
        Rec.StimElectrode = StimElectrode_tmp{get(handles.popStimElectrode,'Value')};
        Polarity_tmp = get(handles.popPolarity,'String');
        Rec.StimPolarity = Polarity_tmp{get(handles.popPolarity,'Value')};
        System_tmp = get(handles.popSystem1,'String');
        Rec.System1 = System_tmp{get(handles.popSystem1,'Value')};
        System_tmp = get(handles.popSystem2,'String');
        Rec.System2 = System_tmp{get(handles.popSystem2,'Value')};
        Tasks = get(handles.popTaskController,'String');
        Rec.Task = Tasks{get(handles.popTaskController,'Value')};
        Environment = get(handles.popEnvironment,'String');
        Rec.Environment = Environment{get(handles.popEnvironment,'Value')};
        Rec.TestResistor = str2double(get(handles.edTestResistor,'String'));
        Test_tmp = get(handles.popTestGain,'String');
        Rec.TestGain = str2double(Test_tmp{get(handles.popTestGain,'Value')});
        
        if ~isdir([directory '/' prenum])
            unix(['mkdir ' directory '/' prenum]);
            disp([directory '/' prenum ' does not exist']);
        else
            disp([directory '/' prenum ' does exist']);
        end

        Rec.Filename = [directory '/' prenum '/rec'  prenum '.dat'];

        Rec.Paramsname = [directory '/' prenum '/rec'  prenum '.Rec.mat'];
        Rec.LogName = [directory '/' prenum '/rec'  prenum '.electrodelog.txt'];

        Rec.NumTrials = zeros(1,NUMTASKTYPE);
        set(handles.rec_count_out_3,'String','0');
        set(handles.rec_count_out_4,'String','0');
        set(handles.rec_count_out_1,'String','0');
        set(handles.rec_count_out_2,'String','0');
        set(handles.rec_count_out_8,'String','0');
        set(handles.rec_count_out_6,'String','0');
        set(handles.rec_count_out_9,'String','0');
        set(handles.rec_count_out_7,'String','0');
    if ACQUISITION_SYSTEM == 0
        %  Get recording position
        Rec.X1 =  str2double(get(handles.edX1,'String'));
        Rec.Y1 =  str2double(get(handles.edY1,'String'));
        Rec.Pitch1 =  str2double(get(handles.edPitch1,'String'));
        Rec.Yaw1 =  str2double(get(handles.edYaw1,'String'));
        Rec.X2 =  str2double(get(handles.edX2,'String'));
        Rec.Y2 =  str2double(get(handles.edY2,'String'));
        Rec.Pitch2 =  str2double(get(handles.edPitch2,'String'));
        Rec.Yaw2 =  str2double(get(handles.edYaw2,'String'));
        Control = get(handles.frControl,'UserData');
    end
        acquire_start_recording(experiment.hardware.acquisition(1).type,data_directory,record_file)
    
        Time = etime(clock,Rec.StartTime);
        %  Save information to params file
        eval(sprintf(['save ' Rec.Paramsname ' Rec']));
        unix(['chmod 664 ' Rec.Paramsname]);
        unix(['chgrp 500 ' Rec.Paramsname]);
    if(0)
        disp(['Opening Log File: ' Rec.LogName]);
        Rec.Logfid= fopen(Rec.LogName,'w');
        pos = '';
        for MT = 1:2
            if SYSTEM(1).MT
                for Num = 1:SYSTEM(MT).NumElectrodes
                    p = num2str(aoGetPos3(tcpwrite,tcpread,MT,Num));
                    pos = [pos ' ' p];
                    Control_Handles = Control.Handles{MT,Num};
                    set(Control_Handles.stPosition,'String',p);
                end
            end
        end
        fprintf(Rec.Logfid,'%d %s\n',Time,pos);
    end
else
    disp('Stopping recording');
    set(h,'String','START');
    Rec.Duration = etime(clock,Rec.StartTime);
    
    for iGain = 1:NUMELECTRODES
        eval(['hh = handles.edGain' num2str(iGain)]);
        set(hh,'Style','edit');
    end
    %  Save information to params file
    save(Rec.Paramsname,'Rec');
    % Stop recording
    acquire_stop_recording(experiment.hardware.acquisition(1).type, Rec.Filename);
  %  fclose(Rec.Logfid);
end

%----------------------------------------------------------------------
function varargout = figure1_DeleteFcn(h, eventdata, handles, varargin)

% global MONKEYDIR SYSTEM
% 
% Control = get(handles.frControl,'UserData');
% 
% for MT = 1:2
%     if SYSTEM(MT).MT
%         disp(['Closing drive ' num2str(MT)]);
%         fclose(Control.Serial{MT});
%         for Num = 1:SYSTEM(MT).NumElectrodes
%             %  Close control figure
%             Control = get(handles.frControl,'UserData');
%             Fig_handle = Control.Figures{MT,Num};
%             close(Fig_handle);  
%         end
%     end
% end
% 
% disp('Changing recording directory file permissions')
% Rec = get(handles.tbStartRecording,'UserData');
% Directory = get(handles.edDirectory,'String');
% unix(['chown -R 500:500 ' Directory]);
% Day = Directory(end-5:end);
% recs = dayrecs(Day);
% if length(recs)
%     olddir = pwd;
%     for iRec = 1:length(recs)
%         disp('Changing recording directory')
%         cd([MONKEYDIR '/' Day '/' recs{iRec}])
%         unix('chmod 664 *');
%     end
%     cd(olddir);
% end
% 


%--------------------------------------------------------------------
function varargout = figure1_CreateFcn(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = Logging(handles)
%
%  varargout = Logging(handles)
%
global SYSTEM TARGET DEPTH Rec


disp('Still Logging');
%Control = get(handles.frControl,'UserData');
%Rec = get(handles.tbStartRecording,'UserData');
if get(handles.tbStartRecording,'Value')==1
    %/******************************/
    %Time = etime(clock,Rec.StartTime);
    Time = acquire_get_time_stamp(experiment.hardware.acquisition(1).type)/3e4;
end
pos = '';
%tcpread = Control.TCPRead;
% Check any incoming Alpha Omega messages to update electrode depths
%DEPTH = aoUpdatePos(tcpread,DEPTH)

% MotorOffset = 0;
% for MT = 1:2
%     if SYSTEM(MT).MT
%         for Num = 1:SYSTEM(MT).NumElectrodes
%             mot = MotorOffset + Num;
%             drawnow
%             Control_Handles = Control.Handles{MT,Num};
%             p = num2str(DEPTH(mot));
%             disp(['DEPTH ' p ' mt ' num2str(MT) ' e ' num2str(Num)]);
%             pos = [pos ' ' p];
%             set(Control_Handles.stPosition,'String',p);
%         end
%         MotorOffset = MotorOffset + 4;
%     end
% end
if get(handles.tbStartRecording,'Value')==1
    %No logging
   % fprintf(Rec.Logfid,'%d %s\n',Time,pos);
end
drawnow
disp('Leaving Logging')
% --------------------------------------------------------------------
function varargout = edInterval(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = pbSpikeStop_Callback(h, eventdata, handles, varargin)
global SYSTEM MONKEYDIR Buffer

MT = get(handles.popSpikeMT,'Value')
MTString = get(handles.popSpikeMT,'String');

MTName = MTString{MT};
Num = get(handles.popSpikeElectrode,'Value')
Cell = get(handles.popSpikeCell,'Value');

disp(['Stopping spike triggered-average GUI for cell ' ...
        num2str(Cell) ' on electrode ' ...
        num2str(Num) ' on MT ' num2str(MT)]);
Spike = get(handles.frSpike,'UserData');

close(Spike.Figures{MT,Num});
Spike.Figures{MT,Num} = [];
Spike.Handles{MT,Num} = [];
Spike.Data(MT,Num).Current = Spike.Data(MT,Num).Current - 1;

set(handles.frSpike,'UserData',Spike);
disp(['Done stopping spike triggered-average GUI for cell ' ...
        num2str(Cell) ' on electrode ' ...
        num2str(Num) ' on MT ' num2str(MT)])


% --------------------------------------------------------------------
function varargout = pbFieldFieldStop_Callback(h, eventdata, handles, varargin)
global SYSTEM MONKEYDIR Buffer CONTROLTASKLIST LFPEXIST MAXCOND GUITASKLIST

NUMTASKS = length(GUITASKLIST);  NUMCONDS = MAXCOND;

MT1 = get(handles.popFieldMT1,'Value');
MTString1 = get(handles.popFieldMT1,'String');
MT1Name = MTString1{MT1};
Num1 = get(handles.popFieldElectrode1,'Value');

MT2 = get(handles.popFieldMT2,'Value');
MTString2 = get(handles.popFieldMT2,'String');
MT2Name = MTString2{MT2};
Num2 = get(handles.popFieldElectrode2,'Value');

disp(['Stopping Field-Field GUI for electrode ' ...
        num2str(Num1) ' on MT ' num2str(MT1) ...
        ' and electrode ' num2str(Num2) ' on MT ' num2str(MT2)])
Field = get(handles.frField,'UserData');

close(Field.Figures{MT1,Num1,MT2,Num2});
Field.Figures{MT1,Num1,MT2,Num2} = [];
Field.Handles{MT1,Num1,MT2,Num2} = [];

Field.Data(MT1,Num1,MT2,Num2).Current = ...
    Field.Data(MT1,Num1,MT2,Num2).Current - 1;    
LFPEXIST(MT1,Num1) = LFPEXIST(MT1,Num1)-1;
LFPEXIST(MT2,Num2) = LFPEXIST(MT2,Num2)-1;

set(handles.frField,'UserData',Field);
disp(['Done stopping Field-Field GUI for electrode ' ...
        num2str(Num1) ' on MT ' num2str(MT1) ...
        ' and electrode ' num2str(Num2) ' on MT ' num2str(MT2)])

% --------------------------------------------------------------------
function varargout = pbSpikeFieldStop_Callback(h, eventdata, handles, varargin)
global SYSTEM MONKEYDIR Buffer TASKLIST LFPEXIST MAXCOND

NUMTASKS = length(TASKLIST);  NUMCONDS = MAXCOND;

MT1 = get(handles.popSFSpikeMT,'Value');
MTString1 = get(handles.popSFSpikeMT,'String');
MT1Name = MTString1{MT1};
Num1 = get(handles.popSFSpikeElectrode,'Value');

MT2 = get(handles.popSFFieldMT,'Value');
MTString2 = get(handles.popSFFieldMT,'String');
MT2Name = MTString2{MT2};
Num2 = get(handles.popSFFieldElectrode,'Value');

disp(['Stopping SpikeField GUI for electrode ' ...
        num2str(Num1) ' on MT ' num2str(MT1) ...
        ' and electrode ' num2str(Num2) ' on MT ' num2str(MT2)])
SpikeField = get(handles.frSpikeField,'UserData');

close(SpikeField.Figures{MT1,Num1,MT2,Num2});
SpikeField.Figures{MT1,Num1,MT2,Num2} = [];
SpikeField.Handles{MT1,Num1,MT2,Num2} = [];

SpikeField.Data(MT1,Num1,MT2,Num2).Current = ...
    SpikeField.Data(MT1,Num1,MT2,Num2).Current - 1;    
LFPEXIST(MT2,Num2) = LFPEXIST(MT2,Num2)-1;

set(handles.frSpikeField,'UserData',SpikeField);
disp(['Done stopping SpikeField GUI for electrode ' ...
        num2str(Num1) ' on MT ' num2str(MT1) ...
        ' and electrode ' num2str(Num2) ' on MT ' num2str(MT2)])

% --------------------------------------------------------------------
function varargout = pbSpikeStartUp(h, eventdata, handles, varargin)

global SYSTEM MONKEYDIR Buffer CHFLAG TASKLIST DT

MT = get(handles.popSpikeMT,'Value');
MTString = get(handles.popSpikeMT,'String');

MTName = MTString{MT};
Num = get(handles.popSpikeElectrode,'Value');
Cell = get(handles.popSpikeCell,'Value');

disp(['Starting spike triggered-average GUI for cell ' ...
        num2str(Cell) ' on electrode ' ...
        num2str(Num) ' on MT ' num2str(MT)])
% Control = get(handles.frControl,'UserData');

%  Start STAPanel GUI and set figure properties
Spike = get(handles.frSpike,'UserData');
Spike.Figures{MT,Num} = openfig('STAPanel');
Fig_handle = Spike.Figures{MT,Num};
FigureName = ['STA ' num2str(MT) ':' num2str(Num)];
set(Fig_handle,'Name',FigureName);
set(Fig_handle,'DoubleBuffer','On');
set(Fig_handle,'Renderer','OpenGL');
set(Fig_handle,'HandleVisibility','on');
set(Fig_handle,'Units','Pixels');
set(Fig_handle,'MenuBar','figure');
Spike.Figures{MT,Num} = Fig_handle;

disp('Generate Spike GUIs handles and set properties')
Spike.Handles{MT,Num} = guihandles(Spike.Figures{MT,Num});
guidata(Spike.Figures{MT,Num}, Spike.Handles{MT,Num});
Tmp_handle = Spike.Handles{MT,Num};

set(Tmp_handle.popTask,'String',[{'All'},TASKLIST]);
set(Tmp_handle.popTask,'Value',1);
set(Tmp_handle.popField,'String',{'Baseline','Delay','Movement'});
set(Tmp_handle.popField,'Value',2);
set(Tmp_handle.popDisplay,'String',{'STA All','STA Trial'});
set(Tmp_handle.popDisplay,'Value',1);
set(Tmp_handle.ckF1,'Value',1); set(Tmp_handle.ckF2,'Value',1); set(Tmp_handle.ckF3,'Value',1); 
set(Tmp_handle.ckP1,'Value',1); set(Tmp_handle.ckP2,'Value',1); set(Tmp_handle.ckP3,'Value',1); 
CHFLAG = ones(2,3);  set(Tmp_handle.frConfig,'UserData',CHFLAG);
set(Tmp_handle.stTitle,'String',['STA Viewer ' ...
        MTName ' ' num2str(MT) ':' num2str(Num)]);

Spike.Data(MT,Num).Current = Spike.Data(MT,Num).Current + 1;
set(Tmp_handle.stCurrent,'String',num2str(Spike.Data(MT,Num).Current));
Spike.Handles{MT,Num} = Tmp_handle;
Spike_Data.NSPIKE = 0;

T=200;
Spike_Data.TrigGRA.F = zeros(3,DT*T);
Spike_Data.TrigGRA.P = zeros(3,DT*T);
Spike_Data.TrigLRA.F = zeros(3,DT*T);
Spike_Data.TrigLRA.P = zeros(3,DT*T);
Spike_Data.POS = zeros(2,3);

set(Tmp_handle.frData,'UserData',Spike_Data);
set(handles.frSpike,'UserData',Spike);

disp(['Done starting spike triggered-average GUI for cell ' ...
        num2str(Cell) ' on electrode ' ...
        num2str(Num) ' on MT ' num2str(MT)])

% --------------------------------------------------------------------
function varargout = pbFieldFieldStartUp_Callback(h, eventdata, handles, varargin)

global SYSTEM MONKEYDIR Buffer CHFLAG CONTROLTASKLIST TARGET CHAMBER1 LFPEXIST MAXCOND GUITASKLIST

NUMTASKS = length(GUITASKLIST); NUMCONDS = MAXCOND;

MT1 = get(handles.popFieldMT1,'Value');
MT1String = get(handles.popFieldMT1,'String');
MT1Name = MT1String{MT1};
Num1 = get(handles.popFieldElectrode1,'Value');

MT2 = get(handles.popFieldMT2,'Value');
MT2String = get(handles.popFieldMT2,'String');
MT2Name = MT2String{MT2};
Num2 = get(handles.popFieldElectrode2,'Value');

Nwin = str2double(get(handles.edN,'String'))*1e3;  %  Nwin is in ms
dn = str2num(get(handles.edDn,'String'));
fk = str2num(get(handles.edFk,'String'));
bn = [str2num(get(handles.edStart,'String')),str2num(get(handles.edStop,'String'))];
nwin = floor((diff(bn))./dn);           % calculate the number of windows
nf = max(256, 2*2^nextpow2(Nwin+1));
nfk = floor(fk./1e3.*nf);

disp(['Starting Field-Field GUI for electrode ' ...
        num2str(Num1) ' on MT ' num2str(MT1) ...
        ' and electrode ' num2str(Num2) ' on MT ' num2str(MT2)])
% Control = get(handles.frControl,'UserData');

%  Start FieldPanel GUI and set figure properties
Field = get(handles.frField,'UserData');
Field.Figures{MT1,Num1,MT2,Num2} = openfig('FieldFieldPanel');
Fig_handle = Field.Figures{MT1,Num1,MT2,Num2};
FigureName = ['Field ' num2str(MT1) ':' num2str(Num1) ' and ' ...
        num2str(MT2) ':' num2str(Num2)];
set(Fig_handle,'Name',FigureName);
set(Fig_handle,'DoubleBuffer','On');
set(Fig_handle,'Renderer','OpenGL');
set(Fig_handle,'HandleVisibility','on');
set(Fig_handle,'Units','Pixels');
set(Fig_handle,'MenuBar','figure');
Field.Figures{MT1,Num1,MT2,Num2} = Fig_handle;

disp('Generate Field GUIs handles and set properties')
Field.Handles{MT1,Num1,MT2,Num2} = guihandles(Field.Figures{MT1,Num1,MT2,Num2});
guidata(Field.Figures{MT1,Num1,MT2,Num2}, Field.Handles{MT1,Num1,MT2,Num2});
Tmp_handle = Field.Handles{MT1,Num1,MT2,Num2};
disp('Set handles')
% InitSTA(Tmp_handle);
% set(Tmp_handle.popTask,'String',[{'All'},GUITASKLIST]);
% set(Tmp_handle.popTask,'Value',1);
% set(Tmp_handle.popTask,'Visible','on');
% set(Tmp_handle.popField,'String',{'Cue','Movement'});
% set(Tmp_handle.popField,'Value',2);
% set(Tmp_handle.popField,'Visible','on');
% 
% set(Tmp_handle.popConditions,'String',{'All','1','2','3','4','5','6','7','8'});
% set(Tmp_handle.popConditions,'Value',1);
% set(Tmp_handle.popConditions,'Visible','on');
% set(Tmp_handle.popDisplaySpec1,'String',{'TvF','TvD'});
% set(Tmp_handle.popDisplaySpec1,'Value',1);
% set(Tmp_handle.popDisplaySpec1,'Visible','on');
% set(Tmp_handle.popDisplaySpec2,'String',{'TvF','TvD'});
% set(Tmp_handle.popDisplaySpec2,'Value',1);
% set(Tmp_handle.popDisplaySpec2,'Visible','on');
% set(Tmp_handle.popDisplayCoh12,'String',{'TvF','TvD'});
% set(Tmp_handle.popDisplayCoh12,'Value',1);
% set(Tmp_handle.popDisplayCoh12,'Visible','on');
% get(Tmp_handle.popDisplayCoh12)
set(Tmp_handle.stTitle,'String',['Field-Field Viewer ' ...
        MT1Name ' ' num2str(MT1) ':' num2str(Num1) ' and ' ...
    MT2Name ' ' num2str(MT2) ':' num2str(Num2)]);
set(Tmp_handle.stSpec1Title,'String',[MT1Name ':' num2str(Num1) ' Spec']);
set(Tmp_handle.stSpec2Title,'String',[MT2Name ':' num2str(Num2) ' Spec']);
set(Tmp_handle.stCoh12Title,'String',[MT1Name ':' MT2Name ' Coherence']);
% 
% if strcmp(CHAMBER1(1),'P')
%     PMT = 1;     LMT = 2;
% elseif strcmp(CHAMBER1(1),'L')
%     LMT = 1;     PMT = 2;
% end
% 
% set(Tmp_handle.stPCD1,'String',num2str(TARGET(PMT,1)));
% set(Tmp_handle.stPCD2,'String',num2str(TARGET(PMT,2)));
% set(Tmp_handle.stPCD3,'String',num2str(TARGET(PMT,3)));
% set(Tmp_handle.stPCD4,'String',num2str(TARGET(PMT,4)));
% set(Tmp_handle.stLCD1,'String',num2str(TARGET(LMT,1)));
% set(Tmp_handle.stLCD2,'String',num2str(TARGET(LMT,2)));
% set(Tmp_handle.stLCD3,'String',num2str(TARGET(LMT,3)));
% set(Tmp_handle.stLCD4,'String',num2str(TARGET(LMT,4)));

disp('Allocating data to Field_Data')
Field.Data(MT1,Num1,MT2,Num2).Current 
Field.Data(MT1,Num1,MT2,Num2).Current = Field.Data(MT1,Num1,MT2,Num2).Current + 1;
LFPEXIST(MT1,Num1) = LFPEXIST(MT1,Num1)+1;
LFPEXIST(MT2,Num2) = LFPEXIST(MT2,Num2)+1;

set(Tmp_handle.stCurrent,'String',num2str(Field.Data(MT1,Num1,MT2,Num2).Current));
Field.Handles{MT1,Num1,MT2,Num2} = Tmp_handle;
Field_Data.POS = TARGET;
Field_Data.MT = [MT1,MT2];
Field_Data.Num = [Num1,Num2];
Field_Data.NumTrials = zeros(NUMTASKS,NUMCONDS);
Field_Data.TaskList = [];
Field_Data.CondList = [];
Field_Data.TrialList = [];
cdum = zeros(nwin,nfk)+complex(0,1).*zeros(nwin,nfk);
for iTask = 1:length(GUITASKLIST)
    eval(['Field_Data.' GUITASKLIST{iTask} '.All.Spec1 = zeros(nwin,nfk);']);
    eval(['Field_Data.' GUITASKLIST{iTask} '.All.Spec2 = zeros(nwin,nfk);']);
    eval(['Field_Data.' GUITASKLIST{iTask} '.All.CSpec = cdum;']);
    eval(['Field_Data.' GUITASKLIST{iTask} '.All.DOF = 0;']);
    eval(['Field_Data.' GUITASKLIST{iTask} '.All.N = 0;']);
    for iCond = 1:8
        eval(['Field_Data.' GUITASKLIST{iTask} '.Cond' num2str(iCond) '.Spec1 = zeros(nwin,nfk);']);
        eval(['Field_Data.' GUITASKLIST{iTask} '.Cond' num2str(iCond) '.Spec2 = zeros(nwin,nfk);']);
        eval(['Field_Data.' GUITASKLIST{iTask} '.Cond' num2str(iCond) '.CSpec = cdum;']);
        eval(['Field_Data.' GUITASKLIST{iTask} '.Cond' num2str(iCond) '.DOF = 0;']);
        eval(['Field_Data.' GUITASKLIST{iTask} '.Cond' num2str(iCond) '.N = 0;']);
    end
end
for iCond = 1:8
    eval(['Field_Data.All.Cond' num2str(iCond) '.Spec1 = zeros(nwin,nfk);']);
    eval(['Field_Data.All.Cond' num2str(iCond) '.Spec2 = zeros(nwin,nfk);']);
    eval(['Field_Data.All.Cond' num2str(iCond) '.CSpec = cdum;']);
    eval(['Field_Data.All.Cond' num2str(iCond) '.DOF = 0;']);
    eval(['Field_Data.All.Cond' num2str(iCond) '.N = 0;']);
end
Field_Data.All.All.Spec1 = zeros(nwin,nfk);
Field_Data.All.All.Spec2 = zeros(nwin,nfk);
Field_Data.All.All.CSpec = cdum;
Field_Data.All.All.DOF = 0;
Field_Data.All.All.N = 0;

% Field.Data(MT1,Num1,MT2,Num2)
axes(Tmp_handle.axSpec1);
Field_Data.Spec1Handle = imagesc(zeros(nwin,nfk)');
axis xy;  set(Tmp_handle.axSpec1,'CLim',[0,5])
axes(Tmp_handle.axSpec2);
Field_Data.Spec2Handle = imagesc(zeros(nwin,nfk)');
axis xy;  set(Tmp_handle.axSpec2,'CLim',[0,5])
axes(Tmp_handle.axCoh12);
Field_Data.Coh12Handle = imagesc(zeros(nwin,nfk)');
axis xy;  set(Tmp_handle.axCoh12,'CLim',[0,0.3])

Field_Data.ParentHandles = handles;
set(Tmp_handle.frData,'UserData',Field_Data);
set(handles.frField,'UserData',Field);

disp(['Done starting Field GUI for electrode ' ...
        num2str(Num1) ' on MT ' num2str(MT1) ...
        ' and electrode ' num2str(Num2) ' on MT ' num2str(MT2)])


% --------------------------------------------------------------------
function varargout = pbSpikeFieldStartUp_Callback(h, eventdata, handles, varargin)

global SYSTEM MONKEYDIR Buffer CHFLAG TASKLIST TARGET CHAMBER1 LFPEXIST MAXCOND GUITASKLIST

NUMTASKS = length(TASKLIST); NUMCONDS = MAXCOND;
NWIN = 30;

MT1 = get(handles.popSFSpikeMT,'Value');
MT1String = get(handles.popSFSpikeMT,'String');
MT1Name = MT1String{MT1};
Num1 = get(handles.popSFSpikeElectrode,'Value');

MT2 = get(handles.popSFFieldMT,'Value');
MT2String = get(handles.popSFFieldMT,'String');
MT2Name = MT2String{MT2};
Num2 = get(handles.popSFFieldElectrode,'Value');

disp(['Starting SpikeField GUI for electrode ' ...
        num2str(Num1) ' on MT ' num2str(MT1) ...
        ' and electrode ' num2str(Num2) ' on MT ' num2str(MT2)])
% Control = get(handles.frControl,'UserData');

%  Start SpikeFieldPanel GUI and set figure properties
SpikeField = get(handles.frSpikeField,'UserData');
SpikeField.Figures{MT1,Num1,MT2,Num2} = openfig('SpikeFieldPanel');
Fig_handle = SpikeField.Figures{MT1,Num1,MT2,Num2};
FigureName = ['SpikeField ' num2str(MT1) ':' num2str(Num1) ' and ' ...
        num2str(MT2) ':' num2str(Num2)];
set(Fig_handle,'Name',FigureName);
set(Fig_handle,'DoubleBuffer','On');
set(Fig_handle,'Renderer','OpenGL');
set(Fig_handle,'HandleVisibility','on');
set(Fig_handle,'Units','Pixels');
set(Fig_handle,'MenuBar','figure');
SpikeField.Figures{MT1,Num1,MT2,Num2} = Fig_handle;

disp('Generate SpikeField GUIs handles and set properties')
SpikeField.Handles{MT1,Num1,MT2,Num2} = guihandles(SpikeField.Figures{MT1,Num1,MT2,Num2});
guidata(SpikeField.Figures{MT1,Num1,MT2,Num2}, SpikeField.Handles{MT1,Num1,MT2,Num2});
Tmp_handle = SpikeField.Handles{MT1,Num1,MT2,Num2};
disp('Set handles')
% InitSTA(Tmp_handle);
set(Tmp_handle.popTask,'String',[{'All'},TASKLIST]);
set(Tmp_handle.popTask,'Value',1);
set(Tmp_handle.popField,'String',{'Cue','Movement'});
set(Tmp_handle.popField,'Value',2);
CondCell{1} = 'All';
for i = 1:MAXCOND
    CondCell{i+1} = num2str(i);
end
set(Tmp_handle.popConditions,'String',CondCell);
set(Tmp_handle.popConditions,'Value',1);
set(Tmp_handle.popDisplaySpec1,'String',{'TvF','TvD'});
set(Tmp_handle.popDisplaySpec1,'Value',1);

set(Tmp_handle.stTitle,'String',['SpikeField Viewer ' ...
        MT1Name ' ' num2str(MT1) ':' num2str(Num1) ' and ' ...
    MT2Name ' ' num2str(MT2) ':' num2str(Num2)]);
disp('Allocating data to Field_Data')
SpikeField.Data(MT1,Num1,MT2,Num2).Current = SpikeField.Data(MT1,Num1,MT2,Num2).Current + 1;
LFPEXIST(MT2,Num2) = LFPEXIST(MT2,Num2)+1;

set(Tmp_handle.stCurrent,'String',num2str(SpikeField.Data(MT1,Num1,MT2,Num2).Current));

if strcmp(CHAMBER1(1),'F')
    FMT = 1;     PDrive = 2;
elseif strcmp(CHAMBER1(1),'P')
    PDrive = 1;     FDrive = 2;
end

set(Tmp_handle.stPCD1,'String',num2str(TARGET(PDrive,1)));
set(Tmp_handle.stPCD2,'String',num2str(TARGET(PDrive,2)));
set(Tmp_handle.stPCD3,'String',num2str(TARGET(PDrive,3)));
set(Tmp_handle.stFCD1,'String',num2str(TARGET(FDrive,1)));
set(Tmp_handle.stFCD2,'String',num2str(TARGET(FDrive,2)));
set(Tmp_handle.stFCD3,'String',num2str(TARGET(FDrive,3)));

% InitSTAAllPlots(Tmp_handle);
SpikeField.Handles{MT1,Num1,MT2,Num2} = Tmp_handle;
SpikeField_Data.POS = TARGET;
SpikeField_Data.NumTrials = zeros(NUMTASKS,NUMCONDS);
SpikeField_Data.TaskList = [];
SpikeField_Data.CondList = [];
cdum = zeros(NWIN,102)+complex(0,1).*zeros(NWIN,102);
for iTask = 1:length(TASKLIST)
    eval(['SpikeField_Data.' TASKLIST{iTask} '.All.Spec1 = zeros(NWIN,102);']);
    eval(['SpikeField_Data.' TASKLIST{iTask} '.All.Spec2 = zeros(NWIN,102);']);
    eval(['SpikeField_Data.' TASKLIST{iTask} '.All.CSpec = cdum;']);
    eval(['SpikeField_Data.' TASKLIST{iTask} '.All.DOF = 0;']);
    eval(['SpikeField_Data.' TASKLIST{iTask} '.All.N = 0;']);
    for iCond = 1:8
        eval(['SpikeField_Data.' TASKLIST{iTask} '.Cond' num2str(iCond) '.Spec1 = zeros(NWIN,102);']);
        eval(['SpikeField_Data.' TASKLIST{iTask} '.Cond' num2str(iCond) '.Spec2 = zeros(NWIN,102);']);
        eval(['SpikeField_Data.' TASKLIST{iTask} '.Cond' num2str(iCond) '.CSpec = cdum;']);
        eval(['SpikeField_Data.' TASKLIST{iTask} '.Cond' num2str(iCond) '.DOF = 0;']);
        eval(['SpikeField_Data.' TASKLIST{iTask} '.Cond' num2str(iCond) '.N = 0;']);
    end
end
for iCond = 1:MAXCOND
    eval(['SpikeField_Data.All.Cond' num2str(iCond) '.Spec1 = zeros(NWIN,102);']);
    eval(['SpikeField_Data.All.Cond' num2str(iCond) '.Spec2 = zeros(NWIN,102);']);
    eval(['SpikeField_Data.All.Cond' num2str(iCond) '.CSpec = cdum;']);
    eval(['SpikeField_Data.All.Cond' num2str(iCond) '.DOF = 0;']);
    eval(['SpikeField_Data.All.Cond' num2str(iCond) '.N = 0;']);
end
SpikeField_Data.All.All.Spec1 = zeros(NWIN,102);
SpikeField_Data.All.All.Spec2 = zeros(NWIN,102);
SpikeField_Data.All.All.CSpec = cdum;
SpikeField_Data.All.All.DOF = 0;
SpikeField_Data.All.All.N = 0;

% SpikeField.Data(MT1,Num1,MT2,Num2)
axes(Tmp_handle.axSpec1);
SpikeField_Data.Spec1Handle = imagesc(zeros(NWIN,102)');
axis xy;  set(Tmp_handle.axSpec1,'CLim',[0,50])
axes(Tmp_handle.axSpec2);
SpikeField_Data.Spec2Handle = imagesc(zeros(NWIN,102)');
axis xy;  set(Tmp_handle.axSpec2,'CLim',[0,5])
axes(Tmp_handle.axCoh12);
SpikeField_Data.Coh12Handle = imagesc(zeros(NWIN,102)');
axis xy;  set(Tmp_handle.axCoh12,'CLim',[0,0.3])

set(Tmp_handle.frData,'UserData',SpikeField_Data);
set(handles.frSpikeField,'UserData',SpikeField);

disp(['Done starting SpikeField GUI for electrode ' ...
        num2str(Num1) ' on MT ' num2str(MT1) ...
        ' and electrode ' num2str(Num2) ' on MT ' num2str(MT2)])




% --------------------------------------------------------------------
function handles = RestartRecording(handles)

global SYSTEM MONKEY Rec SAMPLING NUMTASKTYPE

% Rec = get(handles.tbStartRecording,'UserData');
% disp(['Closing Log File: ' Rec.LogName]);
% fclose(Rec.Logfid);

%  Save information to params file
save(Rec.Paramsname,'Rec');
acquire_stop_recording(experiment.hardware.acquisition(1).type, Rec.Filename);
disp('recordings were stopped')

set(handles.stRecNum,'String',['Recording: ' num2str(experiment.recording.number)]);
%  Get filenames 
directory = get(handles.edRecDir,'String');
experiment.recording.number = experiment.recording.number+1;
prenum = myPrenum(experiment.recording.number);
Rec.prenum = prenum;
Rec.Gain = str2double(get(handles.edGain,'String'));
Rec.StartTime = clock;
Rec.Monkey = MONKEY;
Rec.Ch = [SYSTEM(1).NumElectrodes,SYSTEM(2).NumElectrodes];
Chamber_tmp = get(handles.popMT1,'String');
Rec.Chamber1 = Chamber_tmp{get(handles.popMT1,'Value')};
Rec.Chamber2 = get(handles.stChamber2,'String');
StimChamber_tmp = get(handles.popStimMT,'String');
Rec.StimChamber = StimChamber_tmp{get(handles.popStimMT,'Value')};
StimElectrode_tmp = get(handles.popStimElectrode,'String');
Rec.StimElectrode = StimElectrode_tmp{get(handles.popStimElectrode,'Value')};
Polarity_tmp = get(handles.popPolarity,'String');
Rec.StimPolarity = Polarity_tmp{get(handles.popPolarity,'Value')};
System_tmp = get(handles.popSystem1,'String');
Rec.System1 = System_tmp{get(handles.popSystem1,'Value')};
System_tmp = get(handles.popSystem2,'String');
Rec.System2 = System_tmp{get(handles.popSystem2,'Value')};
Tasks = get(handles.popTaskController,'String');
Rec.Task = Tasks{get(handles.popTaskController,'Value')};
Environment = get(handles.popEnvironment,'String');
Rec.Environment = Environment{get(handles.popEnvironment,'Value')};


Rec.NumTrials = zeros(1,NUMTASKTYPE);              
set(handles.rec_count_out_3,'String',0);
set(handles.rec_count_out_1,'String',0);
set(handles.rec_count_out_4,'String',0);
set(handles.rec_count_out_2,'String',0);
set(handles.rec_count_out_8,'String',0);

Rec.Fs = SAMPLING; 
    if ~isdir([directory '/' prenum])
        unix(['mkdir ' directory '/' prenum]);
        disp([directory '/' prenum ' does not exist']);
    else
        disp([directory '/' prenum ' does exist']);
    end


Rec.Filename = [directory '/' prenum '.dat'];
Rec.Paramsname = [directory '/' prenum '/rec' prenum '.Rec.mat'];
Rec.LogName = [directory '/' prenum '/rec' prenum '.electrodelog.txt'];

%  Get recording position
Rec.X1 =  str2double(get(handles.edX1,'String'));
Rec.Y1 =  str2double(get(handles.edY1,'String'));
Rec.X2 =  str2double(get(handles.edX2,'String'));
Rec.Y2 =  str2double(get(handles.edY2,'String'));

%  Save information to params file
save(Rec.Paramsname,'Rec');
unix(['chmod 664 ' Rec.Paramsname]);
unix(['chgrp 500 ' Rec.Paramsname]);

%  Start recording
data_directory = [directory '/' prenum ];
record_file = ['rec' prenum];
acquire_start_recording(experiment.hardware.acquisition(1).type, data_directory,record_file)

%  Start new log files
Time = etime(clock,Rec.StartTime);
% disp(['Opening Log File: ' Rec.LogName]);
% fid = fopen(Rec.LogName,'w');
% Rec.Logfid = fid;
% pos = '';
% Control = get(handles.frControl,'UserData');
% for MT = 1:2
%     if SYSTEM(MT).MT
%         if SYSTEM(MT).MT
%             for Num = 1:SYSTEM(MT).NumElectrodes
%                 el = 4*(MT-1) + Num;
%                 p = num2str(DEPTH(el));
%                 pos = [pos ' ' p];
%                 Control_Handles = Control.Handles{MT,Num};
%                 set(Control_Handles.stPosition,'String',p);
%             end
%         end
%     end
% end
% drawnow
% fprintf(Rec.Logfid,'%d %s\n',Time,pos);

% --------------------------------------------------------------------
function varargout = edGain_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = ckElectrode1_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = ckElectrode2_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = ckElectrode3_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = edSpikeBuffer_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = popTaskController_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = edX1_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = edDrive1_LM_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = ckElectrode2_1_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = ckElectrode2_2_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = ckElectrode2_3_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = edY2_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = edDrive2_ML_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = ckElectrode1_4_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = ckElectrode1_5_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = checkbox36_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = checkbox37_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = ckElectrode2_4_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = ckElectrode2_5_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = checkbox40_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = checkbox41_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = popSystem1_Callback(h, eventdata, handles, varargin)
% 
% Value = get(h,'Value');
% switch Value
% case 1  %  None
%     set(handles.ckElectrode1_1,'Visible','Off');
%     set(handles.ckElectrode1_2,'Visible','Off');
%     set(handles.ckElectrode1_3,'Visible','Off');
%     set(handles.ckElectrode1_4,'Visible','Off');
%     set(handles.ckElectrode1_5,'Visible','Off');
% case 2  %  3 Ch System
%     set(handles.ckElectrode1_1,'Visible','On');
%     set(handles.ckElectrode1_2,'Visible','On');
%     set(handles.ckElectrode1_3,'Visible','On');
%     set(handles.ckElectrode1_4,'Visible','Off');
%     set(handles.ckElectrode1_5,'Visible','Off');
% case 3  %  5 Ch System
%     set(handles.ckElectrode1_1,'Visible','On');
%     set(handles.ckElectrode1_2,'Visible','On');
%     set(handles.ckElectrode1_3,'Visible','On');
%     set(handles.ckElectrode1_4,'Visible','On');
%     set(handles.ckElectrode1_5,'Visible','On');
% case 4  %  12 Ch System
%     set(handles.ckElectrode1_1,'Visible','On');
%     set(handles.ckElectrode1_2,'Visible','On');
%     set(handles.ckElectrode1_3,'Visible','On');
%     set(handles.ckElectrode1_4,'Visible','Off');
%     set(handles.ckElectrode1_5,'Visible','Off');
% end

% --------------------------------------------------------------------
function varargout = popSystem2_Callback(h, eventdata, handles, varargin)
% 
% Value = get(h,'Value');
% switch Value
% case 1  %  None
%     set(handles.ckElectrode2_1,'Visible','Off');
%     set(handles.ckElectrode2_2,'Visible','Off');
%     set(handles.ckElectrode2_3,'Visible','Off');
%     set(handles.ckElectrode2_4,'Visible','Off');
%     set(handles.ckElectrode2_5,'Visible','Off');
% case 2  %  3 Ch System
%     set(handles.ckElectrode2_1,'Visible','On');
%     set(handles.ckElectrode2_2,'Visible','On');
%     set(handles.ckElectrode2_3,'Visible','On');
%     set(handles.ckElectrode2_4,'Visible','Off');
%     set(handles.ckElectrode2_5,'Visible','Off');
% case 3  %  5 Ch System
%     set(handles.ckElectrode2_1,'Visible','On');
%     set(handles.ckElectrode2_2,'Visible','On');
%     set(handles.ckElectrode2_3,'Visible','On');
%     set(handles.ckElectrode2_4,'Visible','On');
%     set(handles.ckElectrode2_5,'Visible','On');
% case 4  %  12 Ch System
%     set(handles.ckElectrode2_1,'Visible','On');
%     set(handles.ckElectrode2_2,'Visible','On');
%     set(handles.ckElectrode2_3,'Visible','On');
%     set(handles.ckElectrode2_4,'Visible','Off');
%     set(handles.ckElectrode2_5,'Visible','Off');
% end



% --------------------------------------------------------------------
function varargout = popMT1_Callback(h, eventdata, handles, varargin)
    
Value = get(h,'Value');
M = get(h,'String');
MTString = M{Value};
updateMT(handles,'popFieldMT1',1,MTString);
updateMT(handles,'popFieldMT2',1,MTString);
updateMT(handles,'popSFSpikeMT',1,MTString);
updateMT(handles,'popSFFieldMT',1,MTString);
updateMT(handles,'popHistMT',1,MTString);
updateMT(handles,'popSpikeMT',1,MTString);
updateMT(handles,'popStimMT',1,MTString);

% --------------------------------------------------------------------
function varargout = popMT2_Callback(h, eventdata, handles, varargin)
    
Value = get(h,'Value');
M = get(h,'String');
MTString = M{Value};
updateMT(handles,'popFieldMT1',2,MTString);
updateMT(handles,'popFieldMT2',2,MTString);
updateMT(handles,'popSFSpikeMT',2,MTString);
updateMT(handles,'popSFFieldMT',2,MTString);
updateMT(handles,'popHistMT',2,MTString);
updateMT(handles,'popSpikeMT',2,MTString);
updateMT(handles,'popStimMT',2,MTString);

% --------------------------------------------------------------------
function updateMT(handles,Tag,value,MTString)

eval(['S = get(handles.' Tag ',''String'');']);
S{value}=MTString;
eval(['set(handles.' Tag ',''String'',S);']);

% --------------------------------------------------------------------
function varargout = stChamber2_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = StartElectrode(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = popElectrodes1_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = popElectrodes2_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = pbClearAll(h, eventdata, handles, varargin)

% 
% global HISTEXIST
% 
% for Drive = 1:2
%     for Num = 1:4
%         eval(['Value = get(handles.ckElectrode' num2str(Drive) '_' num2str(Num) ',''Value'');']);
% 
%         if Value
%             if HISTEXIST(Drive,Num)
% %                 disp('Histogram panel is open.');
%                 Histos = get(handles.frElectrode,'UserData');
%                 Histos_handles = Histos.Handles{Drive,Num};
% 
%                 global MAXCOND
%                 disp('Entering pbClear')
%                 for dr = 1:MAXCOND
%                     strHname = ['Histos_handles.axHish' num2str(dr)];
%                     eval(['h = ' strHname ';']);
%                     AH = get(h,'UserData');
%                     for i=1:10
%                         TrialSpikes = zeros(6,1);
%                         set(AH.obRast(i),'Xdata',0,'YData',0,'UserData',TrialSpikes);
%                     end
%                     set(AH.obRastFr,'XData',0,'YData',0);
%                     AH.currentTr = 0;
%                     set(h,'UserData',AH);
%                     eval([strHname ' = h;']);
%                     drawnow
%                 end
%                 disp('Leaving pbClear')
%             end
%         end
%     end
% end

% --------------------------------------------------------------------
function varargout = popStimMT_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = popStimElectrode_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = popEnvironment_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = popSpikeMT_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = popSpikeElectrode_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = popSpikeCell_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = pbStimStartup_Callback(h, eventdata, handles, varargin)


global SYSTEM MONKEYDIR Buffer CHFLAG CHAMBER1 TARGET DT

Drive = get(handles.popStimMT,'Value');
DriveString = get(handles.popStimMT,'String');

DriveName = DriveString{Drive};
Num = get(handles.popStimElectrode,'Value');

disp(['Starting spike triggered-average GUI for electrode ' ...
        num2str(Num) ' on drive ' num2str(Drive)])
% Control = get(handles.frControl,'UserData');

%  Start STAPanel GUI and set figure properties
Stim = get(handles.frStim,'UserData');
Stim.Figures{Drive,Num} = openfig('StimPanel');
Fig_handle = Stim.Figures{Drive,Num};
FigureName = ['Stim ' num2str(Drive) ':' num2str(Num)];
set(Fig_handle,'Name',FigureName);
set(Fig_handle,'DoubleBuffer','On');
set(Fig_handle,'Renderer','OpenGL');
set(Fig_handle,'HandleVisibility','on');
set(Fig_handle,'Units','Pixels');
set(Fig_handle,'MenuBar','figure');
Stim.Figures{Drive,Num} = Fig_handle;

%  Generate Spike GUIs handles and set properties
Stim.Handles{Drive,Num} = guihandles(Stim.Figures{Drive,Num});
guidata(Stim.Figures{Drive,Num}, Stim.Handles{Drive,Num});
Tmp_handle = Stim.Handles{Drive,Num};
set(Tmp_handle.popTask,'String',{'All','Fix1T','LR1T','Sacc',...
        'Free3T','IntSacc','ReachRF','LRRF','SaccRF'});
set(Tmp_handle.popTask,'Value',1);
set(Tmp_handle.popField,'String',{'Baseline','Delay','Movement'});
set(Tmp_handle.popField,'Value',2);
set(Tmp_handle.popDisplay,'String',{'Stim All','Stim Trial','Coherency'});
set(Tmp_handle.popDisplay,'Value',1);
set(Tmp_handle.popType,'String',{'Stim Volt','Stim Pulse'});
set(Tmp_handle.popType,'Value',1);
PolarityString = get(handles.popPolarity,'String');
PolarityValue = get(handles.popPolarity,'Value');
Polarity = PolarityString{PolarityValue};
set(Tmp_handle.stPolarity,'String',Polarity);

% InitSTA(Tmp_handle);
set(Tmp_handle.ck1,'Value',1); set(Tmp_handle.ck2,'Value',1); set(Tmp_handle.ck3,'Value',1); 
CHFLAG = ones(1,3);  set(Tmp_handle.frConfig,'UserData',CHFLAG);
set(Tmp_handle.stTitle,'String',['Stimulation Viewer ' DriveName ' ' num2str(Drive) ':' num2str(Num)]);

if strcmp(CHAMBER1(1),'F')
    FDrive = 1;     PDrive = 2;
elseif strcmp(CHAMBER1(1),'P')
    PDrive = 1;     FDrive = 2;
end

set(Tmp_handle.stPCD1,'String',num2str(TARGET(PDrive,1)));
set(Tmp_handle.stPCD2,'String',num2str(TARGET(PDrive,2)));
set(Tmp_handle.stPCD3,'String',num2str(TARGET(PDrive,3)));
set(Tmp_handle.stFCD1,'String',num2str(TARGET(FDrive,1)));
set(Tmp_handle.stFCD2,'String',num2str(TARGET(FDrive,2)));
set(Tmp_handle.stFCD3,'String',num2str(TARGET(FDrive,3)));


T = 400;
time = ([1:DT*T]-DT/2*T)./DT;

axes(Tmp_handle.axG); 
for Num = 1:3
    Obh(Num) = line(time,zeros(1,length(time)));
    set(Obh(Num),'Color',mycolors(Num));
end
line(time,zeros(1,length(time)));
M = str2double(get(Tmp_handle.edRangeG,'String'));
N = str2double(get(Tmp_handle.edTimeG,'String'));
axis([-N N -M M]);
set(Tmp_handle.axG,'UserData',Obh);

axes(Tmp_handle.axL); 
for Num = 1:3
    Obh(Num) = line(time,zeros(1,length(time)));
    set(Obh(Num),'Color',mycolors(Num));
end
line(time,zeros(1,length(time)));
M = str2double(get(Tmp_handle.edRangeL,'String'));
N = str2double(get(Tmp_handle.edTimeL,'String'));
axis([-N N -M M]);
set(Tmp_handle.axL,'UserData',Obh);

Stim.Data(Drive,Num).Current = Stim.Data(Drive,Num).Current + 1;
set(Tmp_handle.stCurrent,'String',num2str(Stim.Data(Drive,Num).Current));
Stim.Handles{Drive,Num} = Tmp_handle;
Stim_Data.NSTIM = 0;
Stim_Data.StimPulse = zeros(1,DT*T);
Stim_Data.StimVolt = zeros(1,DT*T);
Stim_Data.TrigG = zeros(3,DT*T);
Stim_Data.TrigL = zeros(3,DT*T);
Stim_Data.POS = zeros(2,3);
set(Tmp_handle.frData,'UserData',Stim_Data);
set(handles.frStim,'UserData',Stim);

%set(Tmp_handle.frParent_handles,'UserData',handles);

disp(['Done starting stim triggered-average GUI for electrode ' ...
        num2str(Num) ' on drive ' num2str(Drive)])

% --------------------------------------------------------------------
function varargout = pbSpikeStartUp_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = pbStimStop_Callback(h, eventdata, handles, varargin)

global SYSTEM MONKEYDIR Buffer

MT = get(handles.popStimMT,'Value')
MTString = get(handles.popStimMT,'String');
MTName = MTString{MT};
Num = get(handles.popStimElectrode,'Value')
disp(['Stopping stim triggered-average GUI for electrode ' ...
        num2str(Num) ' on MT ' num2str(MT)]);
Stim = get(handles.frStim,'UserData');
close(Stim.Figures{MT,Num});
Stim.Figures{MT,Num} = [];
Stim.Handles{MT,Num} = [];
Stim.Data(MT,Num).Current = Stim.Data(MT,Num).Current - 1;
set(handles.frStim,'UserData',Stim);
disp(['Done stopping stimulation triggered-average GUI for electrode ' ...
        num2str(Num) ' on MT ' num2str(MT)])

% --------------------------------------------------------------------
function varargout = edTestResistor_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = edit18_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = popType_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = popFieldChamber_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = popFieldElectrode_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = popFieldMT2_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = popFieldElectrode2_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = edN_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = edW_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = popPolar_Callback(h, eventdata, handles, varargin)
% --- Executes on selection change in popHistMT.
function popHistMT_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function popHistMT_CreateFcn(hObject, eventdata, handles)
% --- Executes on selection change in popHistElectrode.
function popHistElectrode_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function popHistElectrode_CreateFcn(hObject, eventdata, handles)
% --- Executes on selection change in popupmenu28.
function popupmenu28_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function popupmenu28_CreateFcn(hObject, eventdata, handles)
% --- Executes on selection change in popHistCell.
function popHistCell_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function popHistCell_CreateFcn(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function popSpikeCell_CreateFcn(hObject, eventdata, handles)

% --- Executes on button press in pbHistStop.
function pbHistStop_Callback(hObject, eventdata, handles)

global SYSTEM MONKEYDIR Buffer

MT = get(handles.popHistMT,'Value');
MTString = get(handles.popHistMT,'String');
MTName = MTString{MT};
Num = get(handles.popHistElectrode,'Value');
Cl = get(handles.popHistCell,'Value');

disp(['Stopping histogram GUI for cell ' num2str(Cl) ' on electrode ' ...
        num2str(Num) ' on MT ' num2str(MT)])

Hist = get(handles.frHist,'UserData');
close(Hist.Figures{MT,Num,Cl});
Hist.Figures{MT,Num,Cl} = [];
Hist.Handles{MT,Num,Cl} = [];
Hist.Data(MT,Num,Cl).Current = Hist.Data(MT,Num,Cl).Current - 1;
set(handles.frHist,'UserData',Hist);
disp(['Done stopping histogram GUI for cell ' num2str(Cl) ' on electrode ' ...
        num2str(Num) ' on MT ' num2str(MT)])

% --- Executes during object creation, after setting all properties.
function popMT2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popMT2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edPitch1_Callback(hObject, eventdata, handles)
% hObject    handle to edPitch1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edPitch1 as text
%        str2double(get(hObject,'String')) returns contents of edPitch1 as a double


% --- Executes during object creation, after setting all properties.
function edPitch1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edPitch1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edYaw1_Callback(hObject, eventdata, handles)
% hObject    handle to edYaw1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edYaw1 as text
%        str2double(get(hObject,'String')) returns contents of edYaw1 as a double


% --- Executes during object creation, after setting all properties.
function edYaw1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edYaw1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edPitch2_Callback(hObject, eventdata, handles)
% hObject    handle to edPitch2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edPitch2 as text
%        str2double(get(hObject,'String')) returns contents of edPitch2 as a double


% --- Executes during object creation, after setting all properties.
function edPitch2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edPitch2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edYaw2_Callback(hObject, eventdata, handles)
% hObject    handle to edYaw2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edYaw2 as text
%        str2double(get(hObject,'String')) returns contents of edYaw2 as a double


% --- Executes during object creation, after setting all properties.
function edYaw2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edYaw2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edX2_Callback(hObject, eventdata, handles)

% --- Executes on selection change in popSFSpikeMT.
function popSFSpikeMT_Callback(hObject, eventdata, handles)
% hObject    handle to popSFSpikeMT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popSFSpikeMT contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popSFSpikeMT


% --- Executes on selection change in popSFFieldMT.
function popSFFieldMT_Callback(hObject, eventdata, handles)
% hObject    handle to popSFFieldMT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popSFFieldMT contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popSFFieldMT


% --- Executes on selection change in popFieldMT1.
function popFieldMT1_Callback(hObject, eventdata, handles)
% hObject    handle to popFieldMT1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popFieldMT1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popFieldMT1


%------------------------------------------------------------------------
function handles = myRestartRecording(handles)
        
global SYSTEM MONKEYNAME Rec SAMPLING NUMELECTRODES
global NUMTASKTYPE

disp('Entering myRestartRecording');
h = handles.tbStartRecording;
Control = get(handles.frControl,'UserData');
%tcpread = Control.TCPRead;
%tcpwrite = Control.TCPWrite;
if (get(h,'Value') == get(h,'Max'))
    disp('Starting recording');
    set(h,'String','STOP')
%     Rec = get(handles.tbStartRecording,'UserData');
   
    %  Increment recording number
    experiment.recording.number = experiment.recording.number + 1;
    set(handles.stRecNum,'String',['Recording: ' num2str(experiment.recording.number)]);
    %  Get filenames 
    directory = get(handles.edRecDir,'String');
    prenum = myPrenum(experiment.recording.number);
    Rec.prenum = prenum;
    for iGain = 1:NUMELECTRODES
        eval(['hh = handles.edGain' num2str(iGain)]);
        set(hh,'Style','text');
        Rec.Gain(iGain) = str2double(get(hh,'String'));
    end
    Rec.StartTime = clock;
    Rec.Monkey = MONKEYNAME;
    Rec.Fs = SAMPLING; 
    Rec.Ch = zeros(1,2);
    for iMT = 1:2
        Rec.Ch(iMT) = SYSTEM(iMT).NumElectrodes;
    end
    
    Type_tmp = get(handles.popType,'String');
    Rec.Type = Type_tmp{get(handles.popType,'Value')};
    
    Chamber_tmp = get(handles.popMT1,'String');
    Rec.MT1 = Chamber_tmp{get(handles.popMT1,'Value')};
    Chamber_tmp = get(handles.popMT2,'String');
    Rec.MT2 = Chamber_tmp{get(handles.popMT2,'Value')};
    StimChamber_tmp = get(handles.popStimMT,'String');
    Rec.StimChamber = StimChamber_tmp{get(handles.popStimMT,'Value')};
    StimElectrode_tmp = get(handles.popStimElectrode,'String');
    Rec.StimElectrode = StimElectrode_tmp{get(handles.popStimElectrode,'Value')};
    Polarity_tmp = get(handles.popPolarity,'String');
    Rec.StimPolarity = Polarity_tmp{get(handles.popPolarity,'Value')};
    System_tmp = get(handles.popSystem1,'String');
    Rec.System1 = System_tmp{get(handles.popSystem1,'Value')};
    System_tmp = get(handles.popSystem2,'String');
    Rec.System2 = System_tmp{get(handles.popSystem2,'Value')};
    Tasks = get(handles.popTaskController,'String');
    Rec.Task = Tasks{get(handles.popTaskController,'Value')};
    Environment = get(handles.popEnvironment,'String');
    Rec.Environment = Environment{get(handles.popEnvironment,'Value')};
    Rec.TestResistor = str2double(get(handles.edTestResistor,'String'));
    Test_tmp = get(handles.popTestGain,'String');
    Rec.TestGain = str2double(Test_tmp{get(handles.popTestGain,'Value')});

    if ~isdir([directory '/' prenum])
        unix(['mkdir ' directory '/' prenum]);
        disp([directory '/' prenum ' does not exist']);
    else
        disp([directory '/' prenum ' does exist']);
    end
    Rec.Filename = [directory '/' prenum '/rec'  prenum '.dat'];

    Rec.Paramsname = [directory '/' prenum '/rec'  prenum '.Rec.mat'];
    Rec.LogName = [directory '/' prenum '/rec'  prenum '.electrodelog.txt'];
    Rec.NumTrials = zeros(1,NUMTASKTYPE);
    set(handles.rec_count_out_3,'String','0');
    set(handles.rec_count_out_4,'String','0');
    set(handles.rec_count_out_1,'String','0');
    set(handles.rec_count_out_2,'String','0'); 
    set(handles.rec_count_out_8,'String','0'); 
    
    %  Get recording position
    Rec.X1 =  str2double(get(handles.edX1,'String'));
    Rec.Y1 =  str2double(get(handles.edY1,'String'));
    Rec.Pitch1 =  str2double(get(handles.edPitch1,'String'));
    Rec.Yaw1 =  str2double(get(handles.edYaw1,'String'));
    Rec.X2 =  str2double(get(handles.edX2,'String'));
    Rec.Y2 =  str2double(get(handles.edY2,'String'));
    Rec.Pitch2 =  str2double(get(handles.edPitch2,'String'));
    Rec.Yaw2 =  str2double(get(handles.edYaw2,'String'));
    Control = get(handles.frControl,'UserData');

    %  Start recording
    data_directory = [directory '/' prenum ];
    record_file = ['rec' prenum];
    acquire_start_recording(experiment.hardware.acquisition(1).type, data_directory,record_file)
    Time = etime(clock,Rec.StartTime);
    %  Save information to params file
    eval(sprintf(['save ' Rec.Paramsname ' Rec']));
    unix(['chmod 664 ' Rec.Paramsname]);
%     unix(['chgrp 500 ' Rec.Paramsname]);
    
    
%     disp(['Opening Log File: ' Rec.LogName]);
%     Rec.Logfid= fopen(Rec.LogName,'w');
%     pos = '';
%     for MT = 1:2
%         if SYSTEM(1).MT
%             for Num = 1:SYSTEM(MT).NumElectrodes
%                 p = num2str(aoGetPos3(tcpwrite,tcpread,MT,Num));
%                 pos = [pos ' ' p];               
%                 Control_Handles = Control.Handles{MT,Num};
%                 set(Control_Handles.stPosition,'String',p);
%             end
%         end
%     end
%     fprintf(Rec.Logfid,'%d %s\n',Time,pos);
else
    disp('Stopping recording');
    set(h,'String','START');
    Rec.Duration = etime(clock,Rec.StartTime);
    
    for iGain = 1:NUMELECTRODES
        eval(['hh = handles.edGain' num2str(iGain)]);
        set(hh,'Style','edit');
    end
    %  Save information to params file
    save(Rec.Paramsname,'Rec');
    % Stop recording
   acquire_stop_recording(experiment.hardware.acquisition(1).type, Rec.Filename)
%     fclose(Rec.Logfid);
end

disp('Leaving myRestartRecording');

function edGain1_Callback(hObject, eventdata, handles)
% hObject    handle to edGain1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edGain1 as text
%        str2double(get(hObject,'String')) returns contents of edGain1 as a double


% --- Executes during object creation, after setting all properties.
function edGain1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edGain1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edGain2_Callback(hObject, eventdata, handles)
% hObject    handle to edGain2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edGain2 as text
%        str2double(get(hObject,'String')) returns contents of edGain2 as a double


% --- Executes during object creation, after setting all properties.
function edGain2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edGain2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edGain3_Callback(hObject, eventdata, handles)
% hObject    handle to edGain3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edGain3 as text
%        str2double(get(hObject,'String')) returns contents of edGain3 as a double


% --- Executes during object creation, after setting all properties.
function edGain3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edGain3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edGain4_Callback(hObject, eventdata, handles)
% hObject    handle to edGain4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edGain4 as text
%        str2double(get(hObject,'String')) returns contents of edGain4 as a double


% --- Executes during object creation, after setting all properties.
function edGain4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edGain4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edSpecBufferLength_Callback(hObject, eventdata, handles)
% hObject    handle to edSpecBufferLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edSpecBufferLength as text
%        str2double(get(hObject,'String')) returns contents of edSpecBufferLength as a double


% --- Executes during object creation, after setting all properties.
function edSpecBufferLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edSpecBufferLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edDn_Callback(hObject, eventdata, handles)
% hObject    handle to edDn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edDn as text
%        str2double(get(hObject,'String')) returns contents of edDn as a double


% --- Executes during object creation, after setting all properties.
function edDn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edDn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edFk_Callback(hObject, eventdata, handles)
% hObject    handle to edFk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edFk as text
%        str2double(get(hObject,'String')) returns contents of edFk as a double


% --- Executes during object creation, after setting all properties.
function edFk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edFk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edTuning_Callback(hObject, eventdata, handles)
% hObject    handle to edTuning (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edTuning as text
%        str2double(get(hObject,'String')) returns contents of edTuning as a double


% --- Executes during object creation, after setting all properties.
function edTuning_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edTuning (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edStart_Callback(hObject, eventdata, handles)
% hObject    handle to edStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edStart as text
%        str2double(get(hObject,'String')) returns contents of edStart as a double


% --- Executes during object creation, after setting all properties.
function edStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edStop_Callback(hObject, eventdata, handles)
% hObject    handle to edStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edStop as text
%        str2double(get(hObject,'String')) returns contents of edStop as a double


% --- Executes during object creation, after setting all properties.
function edStop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popAlignField.
function popAlignField_Callback(hObject, eventdata, handles)
% hObject    handle to popAlignField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popAlignField contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popAlignField


% --- Executes during object creation, after setting all properties.
function popAlignField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popAlignField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit37_Callback(hObject, eventdata, handles)
% hObject    handle to edGain4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edGain4 as text
%        str2double(get(hObject,'String')) returns contents of edGain4 as a double


% --- Executes during object creation, after setting all properties.
function edit37_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edGain4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edGain7_Callback(hObject, eventdata, handles)
% hObject    handle to edGain7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edGain7 as text
%        str2double(get(hObject,'String')) returns contents of edGain7 as a double


% --- Executes during object creation, after setting all properties.
function edGain7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edGain7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edGain8_Callback(hObject, eventdata, handles)
% hObject    handle to edGain8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edGain8 as text
%        str2double(get(hObject,'String')) returns contents of edGain8 as a double


% --- Executes during object creation, after setting all properties.
function edGain8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edGain8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edGain6_Callback(hObject, eventdata, handles)
% hObject    handle to edGain6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edGain6 as text
%        str2double(get(hObject,'String')) returns contents of edGain6 as a double


% --- Executes during object creation, after setting all properties.
function edGain6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edGain6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edGain5_Callback(hObject, eventdata, handles)
% hObject    handle to edGain5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edGain5 as text
%        str2double(get(hObject,'String')) returns contents of edGain5 as a double


% --- Executes during object creation, after setting all properties.
function edGain5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edGain5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbResetTime.
function pbResetTime_Callback(hObject, eventdata, handles)
% hObject    handle to pbResetTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global Interval

Interval.StartTime = acquire_get_time_stamp(experiment.hardware.acquisition(1).type);
Delay = str2num(get(handles.edInterval,'String'));
Interval.StopTime = Interval.StartTime + Delay;



function edRecDir_Callback(hObject, eventdata, handles)
% hObject    handle to edRecDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edRecDir as text
%        str2double(get(hObject,'String')) returns contents of edRecDir as a double


% --- Executes during object creation, after setting all properties.
function edRecDir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edRecDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% % --- Executes on button press in tbStartLooping.
% function tbStartLooping_Callback(hObject, eventdata, handles)
% hObject    handle to tbStartLooping (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tbStartLooping



function edInterval_Callback(hObject, eventdata, handles)
% hObject    handle to edInterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edInterval as text
%        str2double(get(hObject,'String')) returns contents of edInterval as a double


% --- Executes during object creation, after setting all properties.
function edInterval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edInterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit44_Callback(hObject, eventdata, handles)
% hObject    handle to edSpikeBuffer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edSpikeBuffer as text
%        str2double(get(hObject,'String')) returns contents of edSpikeBuffer as a double


% --- Executes during object creation, after setting all properties.
function edSpikeBuffer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edSpikeBuffer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function SubGUIS_Callback(hObject, eventdata, handles)
% hObject    handle to SubGUIS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Histograms_Callback(hObject, eventdata, handles)
% hObject    handle to Histograms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global SYSTEM MONKEYDIR Buffer CHFLAG CHAMBER1 TARGET DT TASKCELL experiment
prompt = {['Enter Microdrive Number: (1-' num2str(length(experiment.hardware.microdrive)) ')'],...
    ['Enter Electrode Number: (1-' num2str(length(experiment.hardware.microdrive(1).electrodes)) ')'],...
    'Enter cell number:'};
dlg_title = 'Settings for histogram panel';
num_lines = 1;
answer = inputdlg(prompt,dlg_title,num_lines);
microdrive_number = str2num(answer{1});
electrode_number = str2num(answer{2});
cell_number = str2num(answer{3});

if(microdrive_number > length(experiment.hardware.microdrive))
    disp('Microdrive selected does not exist');
    return
elseif(electrode_number > length(experiment.hardware.microdrive(1).electrodes))
    disp('Electrode selected does not exist');

    return
end
    
disp(['Starting histogram GUI for cell ' num2str(cell_number) ' on electrode ' ...
        num2str(electrode_number) ' on MT ' num2str(microdrive_number)])

%  Start Hist GUI and set figure properties
% = get(handles.frHist,'UserData');
experiment.hardware.microdrive(microdrive_number).electrodes(electrode_number).histogram.figure_handle = openfig('HistogramPanel');

Fig_handle = experiment.hardware.microdrive(microdrive_number).electrodes(electrode_number).histogram.figure_handle;

FigureName = ['Hist ' num2str(microdrive_number) ':' num2str(electrode_number) ':' num2str(cell_number)];
set(Fig_handle,'Name',FigureName);
set(Fig_handle,'DoubleBuffer','On');
set(Fig_handle,'Renderer','OpenGL');
set(Fig_handle,'HandleVisibility','on');
set(Fig_handle,'Units','Pixels');
set(Fig_handle,'MenuBar','figure');
experiment.hardware.microdrive(microdrive_number).electrodes(electrode_number).histogram.figure_handle = Fig_handle;

%  Generate Hist GUIs handles and set properties
experiment.hardware.microdrive(microdrive_number).electrodes(electrode_number).histogram.gui_handle = guihandles(Fig_handle);

guidata(experiment.hardware.microdrive(microdrive_number).electrodes(electrode_number).histogram.gui_handle,...
    experiment.hardware.microdrive(microdrive_number).electrodes(electrode_number).histogram.figure_handle);
Tmp_handle = experiment.hardware.microdrive(microdrive_number).electrodes(electrode_number).histogram.gui_handle;

set(Tmp_handle.puAlign,'String',...
    {'StartAq','TargsOn','Go','TargAq','SaccGo','SaccAq','Cue2On'});
set(Tmp_handle.puSetting,'String',{'Vis','Reach'});
set(Tmp_handle.puAlign,'Value',4);
set(Tmp_handle.popTask,'String',TASKCELL);
set(Tmp_handle.popTask,'Value',14);
set(Tmp_handle.edStarting,'String',-2000);
set(Tmp_handle.edEnding,'String',500);
set(Tmp_handle.frIdentity,'UserData',[microdrive_number,electrode_number,cell_number]);

Hist = experiment.hardware.microdrive(microdrive_number).electrodes(electrode_number).histogram;

Hist.Data(microdrive_number,electrode_number,cell_number).Current = Hist.Data(microdrive_number,electrode_number,cell_number).Current + 1;
Hist.Data(microdrive_number,electrode_number,cell_number).Current;
Hist.Data(microdrive_number,electrode_number,cell_number).RasterData = InitRasterData;
set(Tmp_handle.stCurrent,'String',num2str(Hist.Data(microdrive_number,electrode_number,cell_number).Current));
set(Tmp_handle.stTitle,'String',['Hist MT ' num2str(microdrive_number) ': Ch ' ...
    num2str(electrode_number) ':Cell ' num2str(cell_number)])
Hist.Handles{microdrive_number,electrode_number,cell_number} = Tmp_handle;
InitRasters(Tmp_handle);
Hist.Handles{microdrive_number,electrode_number,cell_number} = Tmp_handle;
set(handles.frHist,'UserData',Hist);
set(Tmp_handle.frParent_handles,'UserData',handles);
disp(['Done starting histogram GUI for cell ' num2str(cell_number) ' on electrode ' ...
        num2str(electrode_number) ' on MT ' num2str(microdrive_number)])

% --------------------------------------------------------------------
function LFP_Spectrum_Callback(hObject, eventdata, handles)
% hObject    handle to LFP_Spectrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)fig = openfig('FieldPanel.fig','reuse');

global SYSTEM MONKEYDIR Buffer CHFLAG CHAMBER1 TARGET DT TASKCELL experiment

prompt = {['Enter First Microdrive Number: (1-' num2str(length(experiment.hardware.microdrive)) ')'],...
    ['Enter First Electrode Number: (1-' num2str(length(experiment.hardware.microdrive(1).electrodes)) ')'],...
    ['Enter Second Microdrive Number: (1-' num2str(length(experiment.hardware.microdrive)) ')'],...
    ['Enter Second Electrode Number: (1-' num2str(length(experiment.hardware.microdrive(1).electrodes)) ')']};
dlg_title = 'Settings for histogram panel';
num_lines = 1;
answer = inputdlg(prompt,dlg_title,num_lines);
microdrive_number1 = str2num(answer{1});
electrode_number1 = str2num(answer{2});
microdrive_number2 = str2num(answer{3});
electrode_number2 = str2num(answer{4});

if(microdrive_number1 > length(experiment.hardware.microdrive) || microdrive_number2 > length(experiment.hardware.microdrive))
    disp('Microdrive selected does not exist');
    return
elseif(electrode_number1 > length(experiment.hardware.microdrive(1).electrodes) || electrode_number2 > length(experiment.hardware.microdrive(1).electrodes))
    disp('Electrode selected does not exist');

    return
end

LFP_fig = openfig('FieldPanel.fig','reuse');

Nwin = str2double(get(handles.edN,'String'))*1e3;  %  Nwin is in ms
dn = str2num(get(handles.edDn,'String'));
fk = str2num(get(handles.edFk,'String'));
bn = [str2num(get(handles.edStart,'String')),str2num(get(handles.edStop,'String'))];
nwin = floor((diff(bn))./dn);           % calculate the number of windows
nf = max(256, 2*2^nextpow2(Nwin+1));
nfk = floor(fk./1e3.*nf);

disp(['Starting Field-Field GUI for electrode ' ...
        num2str(Num1) ' on MT ' num2str(MT1) ...
        ' and electrode ' num2str(Num2) ' on MT ' num2str(MT2)])
% Control = get(handles.frControl,'UserData');

%  Start FieldPanel GUI and set figure properties
Field = get(handles.frField,'UserData');
Field.Figures{MT1,Num1,MT2,Num2} = openfig('FieldFieldPanel');
Fig_handle = Field.Figures{MT1,Num1,MT2,Num2};
FigureName = ['Field ' num2str(MT1) ':' num2str(Num1) ' and ' ...
        num2str(MT2) ':' num2str(Num2)];
set(Fig_handle,'Name',FigureName);
set(Fig_handle,'DoubleBuffer','On');
set(Fig_handle,'Renderer','OpenGL');
set(Fig_handle,'HandleVisibility','on');
set(Fig_handle,'Units','Pixels');
set(Fig_handle,'MenuBar','figure');
Field.Figures{MT1,Num1,MT2,Num2} = Fig_handle;

disp('Generate Field GUIs handles and set properties')
Field.Handles{MT1,Num1,MT2,Num2} = guihandles(Field.Figures{MT1,Num1,MT2,Num2});
guidata(Field.Figures{MT1,Num1,MT2,Num2}, Field.Handles{MT1,Num1,MT2,Num2});
Tmp_handle = Field.Handles{MT1,Num1,MT2,Num2};
disp('Set handles')
% InitSTA(Tmp_handle);
% set(Tmp_handle.popTask,'String',[{'All'},GUITASKLIST]);
% set(Tmp_handle.popTask,'Value',1);
% set(Tmp_handle.popTask,'Visible','on');
% set(Tmp_handle.popField,'String',{'Cue','Movement'});
% set(Tmp_handle.popField,'Value',2);
% set(Tmp_handle.popField,'Visible','on');
% 
% set(Tmp_handle.popConditions,'String',{'All','1','2','3','4','5','6','7','8'});
% set(Tmp_handle.popConditions,'Value',1);
% set(Tmp_handle.popConditions,'Visible','on');
% set(Tmp_handle.popDisplaySpec1,'String',{'TvF','TvD'});
% set(Tmp_handle.popDisplaySpec1,'Value',1);
% set(Tmp_handle.popDisplaySpec1,'Visible','on');
% set(Tmp_handle.popDisplaySpec2,'String',{'TvF','TvD'});
% set(Tmp_handle.popDisplaySpec2,'Value',1);
% set(Tmp_handle.popDisplaySpec2,'Visible','on');
% set(Tmp_handle.popDisplayCoh12,'String',{'TvF','TvD'});
% set(Tmp_handle.popDisplayCoh12,'Value',1);
% set(Tmp_handle.popDisplayCoh12,'Visible','on');
% get(Tmp_handle.popDisplayCoh12)
set(Tmp_handle.stTitle,'String',['Field-Field Viewer ' ...
        MT1Name ' ' num2str(MT1) ':' num2str(Num1) ' and ' ...
    MT2Name ' ' num2str(MT2) ':' num2str(Num2)]);
set(Tmp_handle.stSpec1Title,'String',[MT1Name ':' num2str(Num1) ' Spec']);
set(Tmp_handle.stSpec2Title,'String',[MT2Name ':' num2str(Num2) ' Spec']);
set(Tmp_handle.stCoh12Title,'String',[MT1Name ':' MT2Name ' Coherence']);
% 
% if strcmp(CHAMBER1(1),'P')
%     PMT = 1;     LMT = 2;
% elseif strcmp(CHAMBER1(1),'L')
%     LMT = 1;     PMT = 2;
% end
% 
% set(Tmp_handle.stPCD1,'String',num2str(TARGET(PMT,1)));
% set(Tmp_handle.stPCD2,'String',num2str(TARGET(PMT,2)));
% set(Tmp_handle.stPCD3,'String',num2str(TARGET(PMT,3)));
% set(Tmp_handle.stPCD4,'String',num2str(TARGET(PMT,4)));
% set(Tmp_handle.stLCD1,'String',num2str(TARGET(LMT,1)));
% set(Tmp_handle.stLCD2,'String',num2str(TARGET(LMT,2)));
% set(Tmp_handle.stLCD3,'String',num2str(TARGET(LMT,3)));
% set(Tmp_handle.stLCD4,'String',num2str(TARGET(LMT,4)));

disp('Allocating data to Field_Data')
Field.Data(MT1,Num1,MT2,Num2).Current 
Field.Data(MT1,Num1,MT2,Num2).Current = Field.Data(MT1,Num1,MT2,Num2).Current + 1;
LFPEXIST(MT1,Num1) = LFPEXIST(MT1,Num1)+1;
LFPEXIST(MT2,Num2) = LFPEXIST(MT2,Num2)+1;

set(Tmp_handle.stCurrent,'String',num2str(Field.Data(MT1,Num1,MT2,Num2).Current));
Field.Handles{MT1,Num1,MT2,Num2} = Tmp_handle;
Field_Data.POS = TARGET;
Field_Data.MT = [MT1,MT2];
Field_Data.Num = [Num1,Num2];
Field_Data.NumTrials = zeros(NUMTASKS,NUMCONDS);
Field_Data.TaskList = [];
Field_Data.CondList = [];
Field_Data.TrialList = [];
cdum = zeros(nwin,nfk)+complex(0,1).*zeros(nwin,nfk);
for iTask = 1:length(GUITASKLIST)
    eval(['Field_Data.' GUITASKLIST{iTask} '.All.Spec1 = zeros(nwin,nfk);']);
    eval(['Field_Data.' GUITASKLIST{iTask} '.All.Spec2 = zeros(nwin,nfk);']);
    eval(['Field_Data.' GUITASKLIST{iTask} '.All.CSpec = cdum;']);
    eval(['Field_Data.' GUITASKLIST{iTask} '.All.DOF = 0;']);
    eval(['Field_Data.' GUITASKLIST{iTask} '.All.N = 0;']);
    for iCond = 1:8
        eval(['Field_Data.' GUITASKLIST{iTask} '.Cond' num2str(iCond) '.Spec1 = zeros(nwin,nfk);']);
        eval(['Field_Data.' GUITASKLIST{iTask} '.Cond' num2str(iCond) '.Spec2 = zeros(nwin,nfk);']);
        eval(['Field_Data.' GUITASKLIST{iTask} '.Cond' num2str(iCond) '.CSpec = cdum;']);
        eval(['Field_Data.' GUITASKLIST{iTask} '.Cond' num2str(iCond) '.DOF = 0;']);
        eval(['Field_Data.' GUITASKLIST{iTask} '.Cond' num2str(iCond) '.N = 0;']);
    end
end
for iCond = 1:8
    eval(['Field_Data.All.Cond' num2str(iCond) '.Spec1 = zeros(nwin,nfk);']);
    eval(['Field_Data.All.Cond' num2str(iCond) '.Spec2 = zeros(nwin,nfk);']);
    eval(['Field_Data.All.Cond' num2str(iCond) '.CSpec = cdum;']);
    eval(['Field_Data.All.Cond' num2str(iCond) '.DOF = 0;']);
    eval(['Field_Data.All.Cond' num2str(iCond) '.N = 0;']);
end
Field_Data.All.All.Spec1 = zeros(nwin,nfk);
Field_Data.All.All.Spec2 = zeros(nwin,nfk);
Field_Data.All.All.CSpec = cdum;
Field_Data.All.All.DOF = 0;
Field_Data.All.All.N = 0;

% Field.Data(MT1,Num1,MT2,Num2)
axes(Tmp_handle.axSpec1);
Field_Data.Spec1Handle = imagesc(zeros(nwin,nfk)');
axis xy;  set(Tmp_handle.axSpec1,'CLim',[0,5])
axes(Tmp_handle.axSpec2);
Field_Data.Spec2Handle = imagesc(zeros(nwin,nfk)');
axis xy;  set(Tmp_handle.axSpec2,'CLim',[0,5])
axes(Tmp_handle.axCoh12);
Field_Data.Coh12Handle = imagesc(zeros(nwin,nfk)');
axis xy;  set(Tmp_handle.axCoh12,'CLim',[0,0.3])

Field_Data.ParentHandles = handles;
set(Tmp_handle.frData,'UserData',Field_Data);
set(handles.frField,'UserData',Field);

disp(['Done starting Field GUI for electrode ' ...
        num2str(Num1) ' on MT ' num2str(MT1) ...
        ' and electrode ' num2str(Num2) ' on MT ' num2str(MT2)])




% --------------------------------------------------------------------
function Untitled_6_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Microdrive_Tab1.
function Microdrive_Tab1_Callback(hObject, eventdata, handles)
% hObject    handle to Microdrive_Tab1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Pitch_Tab_Panel1,'Visible','on');
set(handles.Pitch_Tab_Panel2,'Visible','off');
set(handles.Pitch_Tab_Panel3,'Visible','off');
set(handles.Pitch_Tab_Panel4,'Visible','off');

% --- Executes on button press in Microdrive_Tab2.
function Microdrive_Tab2_Callback(hObject, eventdata, handles)
% hObject    handle to Microdrive_Tab2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Pitch_Tab_Panel1,'Visible','off');
set(handles.Pitch_Tab_Panel2,'Visible','on');
set(handles.Pitch_Tab_Panel3,'Visible','off');
set(handles.Pitch_Tab_Panel4,'Visible','off');

% --- Executes on button press in Microdrive_Tab3.
function Microdrive_Tab3_Callback(hObject, eventdata, handles)
% hObject    handle to Microdrive_Tab3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Pitch_Tab_Panel1,'Visible','off');
set(handles.Pitch_Tab_Panel2,'Visible','off');
set(handles.Pitch_Tab_Panel3,'Visible','on');
set(handles.Pitch_Tab_Panel4,'Visible','off');

% --- Executes on button press in Microdrive_Tab4.
function Microdrive_Tab4_Callback(hObject, eventdata, handles)
% hObject    handle to Microdrive_Tab4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Pitch_Tab_Panel1,'Visible','off');
set(handles.Pitch_Tab_Panel2,'Visible','off');
set(handles.Pitch_Tab_Panel3,'Visible','off');
set(handles.Pitch_Tab_Panel4,'Visible','on');

% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Microdrive_Tab5.
function Microdrive_Tab5_Callback(hObject, eventdata, handles)
% hObject    handle to Microdrive_Tab5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Microdrive_Tab6.
function Microdrive_Tanb6_Callback(hObject, eventdata, handles)
% hObject    handle to Microdrive_Tab6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edy1_Callback(hObject, eventdata, handles)
% hObject    handle to edy1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edy1 as text
%        str2double(get(hObject,'String')) returns contents of edy1 as a double


% --- Executes during object creation, after setting all properties.
function edy1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edy1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edx1_Callback(hObject, eventdata, handles)
% hObject    handle to edx1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edx1 as text
%        str2double(get(hObject,'String')) returns contents of edx1 as a double


% --- Executes during object creation, after setting all properties.
function edx1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edx1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit47_Callback(hObject, eventdata, handles)
% hObject    handle to edYaw1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edYaw1 as text
%        str2double(get(hObject,'String')) returns contents of edYaw1 as a double


% --- Executes during object creation, after setting all properties.
function edit47_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edYaw1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit48_Callback(hObject, eventdata, handles)
% hObject    handle to edPitch1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edPitch1 as text
%        str2double(get(hObject,'String')) returns contents of edPitch1 as a double


% --- Executes during object creation, after setting all properties.
function edit48_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edPitch1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit49_Callback(hObject, eventdata, handles)
% hObject    handle to edit49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit49 as text
%        str2double(get(hObject,'String')) returns contents of edit49 as a double


% --- Executes during object creation, after setting all properties.
function edit49_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit50_Callback(hObject, eventdata, handles)
% hObject    handle to edit50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit50 as text
%        str2double(get(hObject,'String')) returns contents of edit50 as a double


% --- Executes during object creation, after setting all properties.
function edit50_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit51_Callback(hObject, eventdata, handles)
% hObject    handle to edit51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit51 as text
%        str2double(get(hObject,'String')) returns contents of edit51 as a double


% --- Executes during object creation, after setting all properties.
function edit51_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit52_Callback(hObject, eventdata, handles)
% hObject    handle to edit52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit52 as text
%        str2double(get(hObject,'String')) returns contents of edit52 as a double


% --- Executes during object creation, after setting all properties.
function edit52_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit53_Callback(hObject, eventdata, handles)
% hObject    handle to edit53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit53 as text
%        str2double(get(hObject,'String')) returns contents of edit53 as a double


% --- Executes during object creation, after setting all properties.
function edit53_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit54_Callback(hObject, eventdata, handles)
% hObject    handle to edit54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit54 as text
%        str2double(get(hObject,'String')) returns contents of edit54 as a double


% --- Executes during object creation, after setting all properties.
function edit54_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit55_Callback(hObject, eventdata, handles)
% hObject    handle to edit55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit55 as text
%        str2double(get(hObject,'String')) returns contents of edit55 as a double


% --- Executes during object creation, after setting all properties.
function edit55_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit56_Callback(hObject, eventdata, handles)
% hObject    handle to edit56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit56 as text
%        str2double(get(hObject,'String')) returns contents of edit56 as a double


% --- Executes during object creation, after setting all properties.
function edit56_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Microdrive_Tab6.
function Microdrive_Tab6_Callback(hObject, eventdata, handles)
% hObject    handle to Microdrive_Tab6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton45.
function pushbutton45_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton46.
function pushbutton46_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton47.
function pushbutton47_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton48.
function pushbutton48_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton49.
function pushbutton49_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton50.
function pushbutton50_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit57_Callback(hObject, eventdata, handles)
% hObject    handle to edit57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit57 as text
%        str2double(get(hObject,'String')) returns contents of edit57 as a double


% --- Executes during object creation, after setting all properties.
function edit57_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit58_Callback(hObject, eventdata, handles)
% hObject    handle to edit58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit58 as text
%        str2double(get(hObject,'String')) returns contents of edit58 as a double


% --- Executes during object creation, after setting all properties.
function edit58_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit59_Callback(hObject, eventdata, handles)
% hObject    handle to edit59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit59 as text
%        str2double(get(hObject,'String')) returns contents of edit59 as a double


% --- Executes during object creation, after setting all properties.
function edit59_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit60_Callback(hObject, eventdata, handles)
% hObject    handle to edit60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit60 as text
%        str2double(get(hObject,'String')) returns contents of edit60 as a double


% --- Executes during object creation, after setting all properties.
function edit60_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit61_Callback(hObject, eventdata, handles)
% hObject    handle to edit61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit61 as text
%        str2double(get(hObject,'String')) returns contents of edit61 as a double


% --- Executes during object creation, after setting all properties.
function edit61_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit62_Callback(hObject, eventdata, handles)
% hObject    handle to edit62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit62 as text
%        str2double(get(hObject,'String')) returns contents of edit62 as a double


% --- Executes during object creation, after setting all properties.
function edit62_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit63_Callback(hObject, eventdata, handles)
% hObject    handle to edit63 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit63 as text
%        str2double(get(hObject,'String')) returns contents of edit63 as a double


% --- Executes during object creation, after setting all properties.
function edit63_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit63 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit64_Callback(hObject, eventdata, handles)
% hObject    handle to edit64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit64 as text
%        str2double(get(hObject,'String')) returns contents of edit64 as a double


% --- Executes during object creation, after setting all properties.
function edit64_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit65_Callback(hObject, eventdata, handles)
% hObject    handle to edit65 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit65 as text
%        str2double(get(hObject,'String')) returns contents of edit65 as a double


% --- Executes during object creation, after setting all properties.
function edit65_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit65 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit66_Callback(hObject, eventdata, handles)
% hObject    handle to edit66 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit66 as text
%        str2double(get(hObject,'String')) returns contents of edit66 as a double


% --- Executes during object creation, after setting all properties.
function edit66_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit66 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit67_Callback(hObject, eventdata, handles)
% hObject    handle to edit67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit67 as text
%        str2double(get(hObject,'String')) returns contents of edit67 as a double


% --- Executes during object creation, after setting all properties.
function edit67_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit68_Callback(hObject, eventdata, handles)
% hObject    handle to edit68 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit68 as text
%        str2double(get(hObject,'String')) returns contents of edit68 as a double


% --- Executes during object creation, after setting all properties.
function edit68_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit68 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit69_Callback(hObject, eventdata, handles)
% hObject    handle to edit69 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit69 as text
%        str2double(get(hObject,'String')) returns contents of edit69 as a double


% --- Executes during object creation, after setting all properties.
function edit69_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit69 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit70_Callback(hObject, eventdata, handles)
% hObject    handle to edit70 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit70 as text
%        str2double(get(hObject,'String')) returns contents of edit70 as a double


% --- Executes during object creation, after setting all properties.
function edit70_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit70 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit71_Callback(hObject, eventdata, handles)
% hObject    handle to edit71 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit71 as text
%        str2double(get(hObject,'String')) returns contents of edit71 as a double


% --- Executes during object creation, after setting all properties.
function edit71_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit71 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit72_Callback(hObject, eventdata, handles)
% hObject    handle to edit72 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit72 as text
%        str2double(get(hObject,'String')) returns contents of edit72 as a double


% --- Executes during object creation, after setting all properties.
function edit72_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit72 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit73_Callback(hObject, eventdata, handles)
% hObject    handle to edit73 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit73 as text
%        str2double(get(hObject,'String')) returns contents of edit73 as a double


% --- Executes during object creation, after setting all properties.
function edit73_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit73 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit74_Callback(hObject, eventdata, handles)
% hObject    handle to edit74 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit74 as text
%        str2double(get(hObject,'String')) returns contents of edit74 as a double


% --- Executes during object creation, after setting all properties.
function edit74_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit74 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit75_Callback(hObject, eventdata, handles)
% hObject    handle to edit75 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit75 as text
%        str2double(get(hObject,'String')) returns contents of edit75 as a double


% --- Executes during object creation, after setting all properties.
function edit75_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit75 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit76_Callback(hObject, eventdata, handles)
% hObject    handle to edit76 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit76 as text
%        str2double(get(hObject,'String')) returns contents of edit76 as a double


% --- Executes during object creation, after setting all properties.
function edit76_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit76 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit77_Callback(hObject, eventdata, handles)
% hObject    handle to edit77 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit77 as text
%        str2double(get(hObject,'String')) returns contents of edit77 as a double


% --- Executes during object creation, after setting all properties.
function edit77_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit77 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit78_Callback(hObject, eventdata, handles)
% hObject    handle to edit78 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit78 as text
%        str2double(get(hObject,'String')) returns contents of edit78 as a double


% --- Executes during object creation, after setting all properties.
function edit78_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit78 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit79_Callback(hObject, eventdata, handles)
% hObject    handle to edit79 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit79 as text
%        str2double(get(hObject,'String')) returns contents of edit79 as a double


% --- Executes during object creation, after setting all properties.
function edit79_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit79 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit80_Callback(hObject, eventdata, handles)
% hObject    handle to edit80 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit80 as text
%        str2double(get(hObject,'String')) returns contents of edit80 as a double


% --- Executes during object creation, after setting all properties.
function edit80_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit80 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit81_Callback(hObject, eventdata, handles)
% hObject    handle to edit81 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit81 as text
%        str2double(get(hObject,'String')) returns contents of edit81 as a double


% --- Executes during object creation, after setting all properties.
function edit81_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit81 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit82_Callback(hObject, eventdata, handles)
% hObject    handle to edit82 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit82 as text
%        str2double(get(hObject,'String')) returns contents of edit82 as a double


% --- Executes during object creation, after setting all properties.
function edit82_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit82 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit83_Callback(hObject, eventdata, handles)
% hObject    handle to edit83 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit83 as text
%        str2double(get(hObject,'String')) returns contents of edit83 as a double


% --- Executes during object creation, after setting all properties.
function edit83_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit83 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit84_Callback(hObject, eventdata, handles)
% hObject    handle to edit84 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit84 as text
%        str2double(get(hObject,'String')) returns contents of edit84 as a double


% --- Executes during object creation, after setting all properties.
function edit84_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit84 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit85_Callback(hObject, eventdata, handles)
% hObject    handle to edit85 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit85 as text
%        str2double(get(hObject,'String')) returns contents of edit85 as a double


% --- Executes during object creation, after setting all properties.
function edit85_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit85 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit86_Callback(hObject, eventdata, handles)
% hObject    handle to edit86 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit86 as text
%        str2double(get(hObject,'String')) returns contents of edit86 as a double


% --- Executes during object creation, after setting all properties.
function edit86_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit86 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit87_Callback(hObject, eventdata, handles)
% hObject    handle to edit87 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit87 as text
%        str2double(get(hObject,'String')) returns contents of edit87 as a double


% --- Executes during object creation, after setting all properties.
function edit87_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit87 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit88_Callback(hObject, eventdata, handles)
% hObject    handle to edit88 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit88 as text
%        str2double(get(hObject,'String')) returns contents of edit88 as a double


% --- Executes during object creation, after setting all properties.
function edit88_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit88 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit89_Callback(hObject, eventdata, handles)
% hObject    handle to edit89 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit89 as text
%        str2double(get(hObject,'String')) returns contents of edit89 as a double


% --- Executes during object creation, after setting all properties.
function edit89_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit89 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit90_Callback(hObject, eventdata, handles)
% hObject    handle to edit90 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit90 as text
%        str2double(get(hObject,'String')) returns contents of edit90 as a double


% --- Executes during object creation, after setting all properties.
function edit90_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit90 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit91_Callback(hObject, eventdata, handles)
% hObject    handle to edit91 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit91 as text
%        str2double(get(hObject,'String')) returns contents of edit91 as a double


% --- Executes during object creation, after setting all properties.
function edit91_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit91 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit92_Callback(hObject, eventdata, handles)
% hObject    handle to edit92 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit92 as text
%        str2double(get(hObject,'String')) returns contents of edit92 as a double


% --- Executes during object creation, after setting all properties.
function edit92_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit92 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit93_Callback(hObject, eventdata, handles)
% hObject    handle to edit93 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit93 as text
%        str2double(get(hObject,'String')) returns contents of edit93 as a double


% --- Executes during object creation, after setting all properties.
function edit93_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit93 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit94_Callback(hObject, eventdata, handles)
% hObject    handle to edit94 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit94 as text
%        str2double(get(hObject,'String')) returns contents of edit94 as a double


% --- Executes during object creation, after setting all properties.
function edit94_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit94 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton51.
function pushbutton51_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton52.
function pushbutton52_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit95_Callback(hObject, eventdata, handles)
% hObject    handle to edit95 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit95 as text
%        str2double(get(hObject,'String')) returns contents of edit95 as a double


% --- Executes during object creation, after setting all properties.
function edit95_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit95 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit132_Callback(hObject, eventdata, handles)
% hObject    handle to edit132 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit132 as text
%        str2double(get(hObject,'String')) returns contents of edit132 as a double


% --- Executes during object creation, after setting all properties.
function edit132_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit132 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function electrode_group_Callback(hObject, eventdata, handles)
% hObject    handle to electrode_group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of electrode_group as text
%        str2double(get(hObject,'String')) returns contents of electrode_group as a double
global experiment
contents = get(handles.microdrive_number,'String') ;
microdrive_number_selected = str2num(contents{get(handles.microdrive_number,'Value')})
contents = get(handles.electrode_number,'String') ;
electrode_number_selected = str2num(contents{get(handles.electrode_number,'Value')})
experiment.hardware.microdrive(microdrive_number_selected).electrodes(electrode_number_selected).motorgroupid= str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function electrode_group_CreateFcn(hObject, eventdata, handles)
% hObject    handle to electrode_group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function electrode_channel_Callback(hObject, eventdata, handles)
% hObject    handle to electrode_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDAT_

% Hints: get(hObject,'String') returns contents of electrode_channel as text
%        str2double(get(hObject,'String')) returns contents of electrode_channel as a double

global experiment
contents = get(handles.microdrive_number,'String') ;
microdrive_number_selected = str2num(contents{get(handles.microdrive_number,'Value')})
contents = get(handles.electrode_number,'String') ;
electrode_number_selected = str2num(contents{get(handles.electrode_number,'Value')})
experiment.hardware.microdrive(microdrive_number_selected).electrodes(electrode_number_selected).channelid = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function electrode_channel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to electrode_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit135_Callback(hObject, eventdata, handles)
% hObject    handle to edit135 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit135 as text
%        str2double(get(hObject,'String')) returns contents of edit135 as a double


% --- Executes during object creation, after setting all properties.
function edit135_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit135 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit136_Callback(hObject, eventdata, handles)
% hObject    handle to edit136 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit136 as text
%        str2double(get(hObject,'String')) returns contents of edit136 as a double


% --- Executes during object creation, after setting all properties.
function edit136_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit136 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit137_Callback(hObject, eventdata, handles)
% hObject    handle to edit137 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit137 as text
%        str2double(get(hObject,'String')) returns contents of edit137 as a double


% --- Executes during object creation, after setting all properties.
function edit137_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit137 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit126_Callback(hObject, eventdata, handles)
% hObject    handle to edit126 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit126 as text
%        str2double(get(hObject,'String')) returns contents of edit126 as a double


% --- Executes during object creation, after setting all properties.
function edit126_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit126 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit127_Callback(hObject, eventdata, handles)
% hObject    handle to edit127 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit127 as text
%        str2double(get(hObject,'String')) returns contents of edit127 as a double


% --- Executes during object creation, after setting all properties.
function edit127_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit127 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit128_Callback(hObject, eventdata, handles)
% hObject    handle to edit128 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit128 as text
%        str2double(get(hObject,'String')) returns contents of edit128 as a double


% --- Executes during object creation, after setting all properties.
function edit128_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit128 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit129_Callback(hObject, eventdata, handles)
% hObject    handle to edit129 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit129 as text
%        str2double(get(hObject,'String')) returns contents of edit129 as a double


% --- Executes during object creation, after setting all properties.
function edit129_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit129 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit130_Callback(hObject, eventdata, handles)
% hObject    handle to edit130 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit130 as text
%        str2double(get(hObject,'String')) returns contents of edit130 as a double


% --- Executes during object creation, after setting all properties.
function edit130_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit130 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit131_Callback(hObject, eventdata, handles)
% hObject    handle to edit131 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit131 as text
%        str2double(get(hObject,'String')) returns contents of edit131 as a double


% --- Executes during object creation, after setting all properties.
function edit131_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit131 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit174_Callback(hObject, eventdata, handles)
% hObject    handle to edit174 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit174 as text
%        str2double(get(hObject,'String')) returns contents of edit174 as a double


% --- Executes during object creation, after setting all properties.
function edit174_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit174 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit175_Callback(hObject, eventdata, handles)
% hObject    handle to edit175 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit175 as text
%        str2double(get(hObject,'String')) returns contents of edit175 as a double


% --- Executes during object creation, after setting all properties.
function edit175_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit175 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit176_Callback(hObject, eventdata, handles)
% hObject    handle to edit176 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit176 as text
%        str2double(get(hObject,'String')) returns contents of edit176 as a double


% --- Executes during object creation, after setting all properties.
function edit176_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit176 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit177_Callback(hObject, eventdata, handles)
% hObject    handle to edit177 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit177 as text
%        str2double(get(hObject,'String')) returns contents of edit177 as a double


% --- Executes during object creation, after setting all properties.
function edit177_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit177 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit178_Callback(hObject, eventdata, handles)
% hObject    handle to edit178 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit178 as text
%        str2double(get(hObject,'String')) returns contents of edit178 as a double


% --- Executes during object creation, after setting all properties.
function edit178_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit178 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit179_Callback(hObject, eventdata, handles)
% hObject    handle to edit179 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit179 as text
%        str2double(get(hObject,'String')) returns contents of edit179 as a double


% --- Executes during object creation, after setting all properties.
function edit179_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit179 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit120_Callback(hObject, eventdata, handles)
% hObject    handle to edit120 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit120 as text
%        str2double(get(hObject,'String')) returns contents of edit120 as a double


% --- Executes during object creation, after setting all properties.
function edit120_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit120 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit121_Callback(hObject, eventdata, handles)
% hObject    handle to edit121 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit121 as text
%        str2double(get(hObject,'String')) returns contents of edit121 as a double


% --- Executes during object creation, after setting all properties.
function edit121_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit121 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit122_Callback(hObject, eventdata, handles)
% hObject    handle to edit122 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit122 as text
%        str2double(get(hObject,'String')) returns contents of edit122 as a double


% --- Executes during object creation, after setting all properties.
function edit122_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit122 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit123_Callback(hObject, eventdata, handles)
% hObject    handle to edit123 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit123 as text
%        str2double(get(hObject,'String')) returns contents of edit123 as a double


% --- Executes during object creation, after setting all properties.
function edit123_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit123 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit124_Callback(hObject, eventdata, handles)
% hObject    handle to edit124 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit124 as text
%        str2double(get(hObject,'String')) returns contents of edit124 as a double


% --- Executes during object creation, after setting all properties.
function edit124_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit124 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit125_Callback(hObject, eventdata, handles)
% hObject    handle to edit125 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit125 as text
%        str2double(get(hObject,'String')) returns contents of edit125 as a double


% --- Executes during object creation, after setting all properties.
function edit125_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit125 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit168_Callback(hObject, eventdata, handles)
% hObject    handle to edit168 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit168 as text
%        str2double(get(hObject,'String')) returns contents of edit168 as a double


% --- Executes during object creation, after setting all properties.
function edit168_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit168 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit169_Callback(hObject, eventdata, handles)
% hObject    handle to edit169 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit169 as text
%        str2double(get(hObject,'String')) returns contents of edit169 as a double


% --- Executes during object creation, after setting all properties.
function edit169_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit169 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit170_Callback(hObject, eventdata, handles)
% hObject    handle to edit170 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit170 as text
%        str2double(get(hObject,'String')) returns contents of edit170 as a double


% --- Executes during object creation, after setting all properties.
function edit170_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit170 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit171_Callback(hObject, eventdata, handles)
% hObject    handle to edit171 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit171 as text
%        str2double(get(hObject,'String')) returns contents of edit171 as a double


% --- Executes during object creation, after setting all properties.
function edit171_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit171 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit172_Callback(hObject, eventdata, handles)
% hObject    handle to edit172 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit172 as text
%        str2double(get(hObject,'String')) returns contents of edit172 as a double


% --- Executes during object creation, after setting all properties.
function edit172_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit172 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit173_Callback(hObject, eventdata, handles)
% hObject    handle to edit173 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit173 as text
%        str2double(get(hObject,'String')) returns contents of edit173 as a double


% --- Executes during object creation, after setting all properties.
function edit173_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit173 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit114_Callback(hObject, eventdata, handles)
% hObject    handle to edit114 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit114 as text
%        str2double(get(hObject,'String')) returns contents of edit114 as a double


% --- Executes during object creation, after setting all properties.
function edit114_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit114 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit115_Callback(hObject, eventdata, handles)
% hObject    handle to edit115 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit115 as text
%        str2double(get(hObject,'String')) returns contents of edit115 as a double


% --- Executes during object creation, after setting all properties.
function edit115_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit115 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit116_Callback(hObject, eventdata, handles)
% hObject    handle to edit116 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit116 as text
%        str2double(get(hObject,'String')) returns contents of edit116 as a double


% --- Executes during object creation, after setting all properties.
function edit116_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit116 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit117_Callback(hObject, eventdata, handles)
% hObject    handle to edit117 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit117 as text
%        str2double(get(hObject,'String')) returns contents of edit117 as a double


% --- Executes during object creation, after setting all properties.
function edit117_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit117 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit118_Callback(hObject, eventdata, handles)
% hObject    handle to edit118 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit118 as text
%        str2double(get(hObject,'String')) returns contents of edit118 as a double


% --- Executes during object creation, after setting all properties.
function edit118_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit118 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit119_Callback(hObject, eventdata, handles)
% hObject    handle to edit119 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit119 as text
%        str2double(get(hObject,'String')) returns contents of edit119 as a double


% --- Executes during object creation, after setting all properties.
function edit119_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit119 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit162_Callback(hObject, eventdata, handles)
% hObject    handle to edit162 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit162 as text
%        str2double(get(hObject,'String')) returns contents of edit162 as a double


% --- Executes during object creation, after setting all properties.
function edit162_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit162 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit163_Callback(hObject, eventdata, handles)
% hObject    handle to edit163 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit163 as text
%        str2double(get(hObject,'String')) returns contents of edit163 as a double


% --- Executes during object creation, after setting all properties.
function edit163_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit163 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit164_Callback(hObject, eventdata, handles)
% hObject    handle to edit164 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit164 as text
%        str2double(get(hObject,'String')) returns contents of edit164 as a double


% --- Executes during object creation, after setting all properties.
function edit164_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit164 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit165_Callback(hObject, eventdata, handles)
% hObject    handle to edit165 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit165 as text
%        str2double(get(hObject,'String')) returns contents of edit165 as a double


% --- Executes during object creation, after setting all properties.
function edit165_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit165 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit166_Callback(hObject, eventdata, handles)
% hObject    handle to edit166 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit166 as text
%        str2double(get(hObject,'String')) returns contents of edit166 as a double


% --- Executes during object creation, after setting all properties.
function edit166_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit166 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit167_Callback(hObject, eventdata, handles)
% hObject    handle to edit167 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit167 as text
%        str2double(get(hObject,'String')) returns contents of edit167 as a double


% --- Executes during object creation, after setting all properties.
function edit167_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit167 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit108_Callback(hObject, eventdata, handles)
% hObject    handle to edit108 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit108 as text
%        str2double(get(hObject,'String')) returns contents of edit108 as a double


% --- Executes during object creation, after setting all properties.
function edit108_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit108 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit109_Callback(hObject, eventdata, handles)
% hObject    handle to edit109 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit109 as text
%        str2double(get(hObject,'String')) returns contents of edit109 as a double


% --- Executes during object creation, after setting all properties.
function edit109_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit109 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit110_Callback(hObject, eventdata, handles)
% hObject    handle to edit110 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit110 as text
%        str2double(get(hObject,'String')) returns contents of edit110 as a double


% --- Executes during object creation, after setting all properties.
function edit110_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit110 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit111_Callback(hObject, eventdata, handles)
% hObject    handle to edit111 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit111 as text
%        str2double(get(hObject,'String')) returns contents of edit111 as a double


% --- Executes during object creation, after setting all properties.
function edit111_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit111 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit112_Callback(hObject, eventdata, handles)
% hObject    handle to edit112 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit112 as text
%        str2double(get(hObject,'String')) returns contents of edit112 as a double


% --- Executes during object creation, after setting all properties.
function edit112_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit112 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit113_Callback(hObject, eventdata, handles)
% hObject    handle to edit113 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit113 as text
%        str2double(get(hObject,'String')) returns contents of edit113 as a double


% --- Executes during object creation, after setting all properties.
function edit113_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit113 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit156_Callback(hObject, eventdata, handles)
% hObject    handle to edit156 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit156 as text
%        str2double(get(hObject,'String')) returns contents of edit156 as a double


% --- Executes during object creation, after setting all properties.
function edit156_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit156 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit157_Callback(hObject, eventdata, handles)
% hObject    handle to edit157 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit157 as text
%        str2double(get(hObject,'String')) returns contents of edit157 as a double


% --- Executes during object creation, after setting all properties.
function edit157_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit157 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit158_Callback(hObject, eventdata, handles)
% hObject    handle to edit158 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit158 as text
%        str2double(get(hObject,'String')) returns contents of edit158 as a double


% --- Executes during object creation, after setting all properties.
function edit158_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit158 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit159_Callback(hObject, eventdata, handles)
% hObject    handle to edit159 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit159 as text
%        str2double(get(hObject,'String')) returns contents of edit159 as a double


% --- Executes during object creation, after setting all properties.
function edit159_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit159 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit160_Callback(hObject, eventdata, handles)
% hObject    handle to edit160 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit160 as text
%        str2double(get(hObject,'String')) returns contents of edit160 as a double


% --- Executes during object creation, after setting all properties.
function edit160_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit160 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit161_Callback(hObject, eventdata, handles)
% hObject    handle to edit161 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit161 as text
%        str2double(get(hObject,'String')) returns contents of edit161 as a double


% --- Executes during object creation, after setting all properties.
function edit161_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit161 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function electrode_motorid_Callback(hObject, eventdata, handles)
% hObject    handle to electrode_motorid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of electrode_motorid as text
%        str2double(get(hObject,'String')) returns contents of electrode_motorid as a double
global experiment

contents = get(handles.microdrive_number,'String') ;
microdrive_number_selected = str2num(contents{get(handles.microdrive_number,'Value')})
contents = get(handles.electrode_number,'String') ;
electrode_number_selected = str2num(contents{get(handles.electrode_number,'Value')})
experiment.hardware.microdrive(microdrive_number_selected).electrodes(electrode_number_selected).motorid = str2double(get(hObject,'String'));
experiment.hardware.microdrive(1).electrodes(1).motorid
% --- Executes during object creation, after setting all properties.
function electrode_motorid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to electrode_motorid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit103_Callback(hObject, eventdata, handles)
% hObject    handle to edit103 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit103 as text
%        str2double(get(hObject,'String')) returns contents of edit103 as a double


% --- Executes during object creation, after setting all properties.
function edit103_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit103 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit104_Callback(hObject, eventdata, handles)
% hObject    handle to edit104 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit104 as text
%        str2double(get(hObject,'String')) returns contents of edit104 as a double


% --- Executes during object creation, after setting all properties.
function edit104_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit104 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit105_Callback(hObject, eventdata, handles)
% hObject    handle to edit105 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit105 as text
%        str2double(get(hObject,'String')) returns contents of edit105 as a double


% --- Executes during object creation, after setting all properties.
function edit105_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit105 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function electrode_label_Callback(hObject, eventdata, handles)
% hObject    handle to electrode_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of electrode_label as text
%        str2double(get(hObject,'String')) returns contents of electrode_label as a double

global experiment
contents = get(handles.microdrive_number,'String') ;
microdrive_number_selected = str2num(contents{get(handles.microdrive_number,'Value')})
contents = get(handles.electrode_number,'String') ;
electrode_number_selected = str2num(contents{get(handles.electrode_number,'Value')})
experiment.hardware.microdrive(microdrive_number_selected).electrodes(electrode_number_selected).label = get(hObject,'String');


% --- Executes during object creation, after setting all properties.
function electrode_label_CreateFcn(hObject, eventdata, handles)
% hObject    handle to electrode_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function electrode_acquisitionid_Callback(hObject, eventdata, handles)
% hObject    handle to electrode_acquisitionid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of electrode_acquisitionid as text
%        str2double(get(hObject,'String')) returns contents of electrode_acquisitionid as a double
global experiment
contents = get(handles.microdrive_number,'String') ;
microdrive_number_selected = str2num(contents{get(handles.microdrive_number,'Value')})
contents = get(handles.electrode_number,'String') ;
electrode_number_selected = str2num(contents{get(handles.electrode_number,'Value')})
experiment.hardware.microdrive(microdrive_number_selected).electrodes(electrode_number_selected).acquisitionid = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function electrode_acquisitionid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to electrode_acquisitionid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit150_Callback(hObject, eventdata, handles)
% hObject    handle to edit150 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit150 as text
%        str2double(get(hObject,'String')) returns contents of edit150 as a double


% --- Executes during object creation, after setting all properties.
function edit150_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit150 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit151_Callback(hObject, eventdata, handles)
% hObject    handle to edit151 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit151 as text
%        str2double(get(hObject,'String')) returns contents of edit151 as a double


% --- Executes during object creation, after setting all properties.
function edit151_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit151 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit152_Callback(hObject, eventdata, handles)
% hObject    handle to edit152 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit152 as text
%        str2double(get(hObject,'String')) returns contents of edit152 as a double


% --- Executes during object creation, after setting all properties.
function edit152_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit152 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit153_Callback(hObject, eventdata, handles)
% hObject    handle to edit153 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit153 as text
%        str2double(get(hObject,'String')) returns contents of edit153 as a double


% --- Executes during object creation, after setting all properties.
function edit153_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit153 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit154_Callback(hObject, eventdata, handles)
% hObject    handle to edit154 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit154 as text
%        str2double(get(hObject,'String')) returns contents of edit154 as a double


% --- Executes during object creation, after setting all properties.
function edit154_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit154 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit155_Callback(hObject, eventdata, handles)
% hObject    handle to edit155 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit155 as text
%        str2double(get(hObject,'String')) returns contents of edit155 as a double


% --- Executes during object creation, after setting all properties.
function edit155_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit155 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function microdrive_x_Callback(hObject, eventdata, handles)
% hObject    handle to microdrive_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of microdrive_x as text
%        str2double(get(hObject,'String')) returns contents of microdrive_x as a double

global experiment 

contents = get(handles.microdrive_number,'String') ;
microdrive_number_selected = str2num(contents{get(handles.microdrive_number,'Value')})
experiment.hardware.microdrive(microdrive_number_selected).coordinate.x = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function microdrive_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to microdrive_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function microdrive_y_Callback(hObject, eventdata, handles)
% hObject    handle to microdrive_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of microdrive_y as text
%        str2double(get(hObject,'String')) returns contents of microdrive_y as a double
global experiment 

contents = get(handles.microdrive_number,'String') ;
microdrive_number_selected = str2num(contents{get(handles.microdrive_number,'Value')})
experiment.hardware.microdrive(microdrive_number_selected).coordinate.y = str2double(get(hObject,'String'));
% --- Executes during object creation, after setting all properties.
function microdrive_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to microdrive_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function microdrive_yaw_Callback(hObject, eventdata, handles)
% hObject    handle to microdrive_yaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of microdrive_yaw as text
%        str2double(get(hObject,'String')) returns contents of microdrive_yaw as a double
global experiment 

contents = get(handles.microdrive_number,'String') ;
microdrive_number_selected = str2num(contents{get(handles.microdrive_number,'Value')})
experiment.hardware.microdrive(microdrive_number_selected).coordinate.yaw = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function microdrive_yaw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to microdrive_yaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function microdrive_pitch_Callback(hObject, eventdata, handles)
% hObject    handle to microdrive_pitch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of microdrive_pitch as text
%        str2double(get(hObject,'String')) returns contents of microdrive_pitch as a double

global experiment 

contents = get(handles.microdrive_number,'String') ;
microdrive_number_selected = str2num(contents{get(handles.microdrive_number,'Value')})
experiment.hardware.microdrive(microdrive_number_selected).coordinate.pitch = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function microdrive_pitch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to microdrive_pitch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton53.
function pushbutton53_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton54.
function pushbutton54_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton55.
function pushbutton55_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton56.
function pushbutton56_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton57.
function pushbutton57_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton58.
function pushbutton58_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton59.
function pushbutton59_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function microdrive_NNNNNNNNNNN_Callback(hObject, eventdata, handles)
% hObject    handle to microdrive_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of microdrive_name as text
%        str2double(get(hObject,'String')) returns contents of microdrive_name as a double
global experiment 

contents = get(handles.microdrive_number,'String') ;
microdrive_number_selected = str2num(contents{get(handles.microdrive_number,'Value')})
experiment.hardware.microdrive(microdrive_number_selected).name = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function microdrive_NNNNNNNNNNN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to microdrive_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit101_Callback(hObject, eventdata, handles)
% hObject    handle to edit101 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit101 as text
%        str2double(get(hObject,'String')) returns contents of edit101 as a double


% --- Executes during object creation, after setting all properties.
function edit101_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit101 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit144_Callback(hObject, eventdata, handles)
% hObject    handle to edit144 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit144 as text
%        str2double(get(hObject,'String')) returns contents of edit144 as a double


% --- Executes during object creation, after setting all properties.
function edit144_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit144 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit145_Callback(hObject, eventdata, handles)
% hObject    handle to edit145 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit145 as text
%        str2double(get(hObject,'String')) returns contents of edit145 as a double


% --- Executes during object creation, after setting all properties.
function edit145_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit145 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit146_Callback(hObject, eventdata, handles)
% hObject    handle to edit146 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit146 as text
%        str2double(get(hObject,'String')) returns contents of edit146 as a double


% --- Executes during object creation, after setting all properties.
function edit146_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit146 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit147_Callback(hObject, eventdata, handles)
% hObject    handle to edit147 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit147 as text
%        str2double(get(hObject,'String')) returns contents of edit147 as a double


% --- Executes during object creation, after setting all properties.
function edit147_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit147 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit148_Callback(hObject, eventdata, handles)
% hObject    handle to edit148 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit148 as text
%        str2double(get(hObject,'String')) returns contents of edit148 as a double


% --- Executes during object creation, after setting all properties.
function edit148_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit148 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit149_Callback(hObject, eventdata, handles)
% hObject    handle to edit149 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit149 as text
%        str2double(get(hObject,'String')) returns contents of edit149 as a double


% --- Executes during object creation, after setting all properties.
function edit149_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit149 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit138_Callback(hObject, eventdata, handles)
% hObject    handle to edit138 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit138 as text
%        str2double(get(hObject,'String')) returns contents of edit138 as a double


% --- Executes during object creation, after setting all properties.
function edit138_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit138 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit139_Callback(hObject, eventdata, handles)
% hObject    handle to edit139 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit139 as text
%        str2double(get(hObject,'String')) returns contents of edit139 as a double


% --- Executes during object creation, after setting all properties.
function edit139_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit139 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit140_Callback(hObject, eventdata, handles)
% hObject    handle to edit140 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit140 as text
%        str2double(get(hObject,'String')) returns contents of edit140 as a double


% --- Executes during object creation, after setting all properties.
function edit140_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit140 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit141_Callback(hObject, eventdata, handles)
% hObject    handle to edit141 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit141 as text
%        str2double(get(hObject,'String')) returns contents of edit141 as a double


% --- Executes during object creation, after setting all properties.
function edit141_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit141 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton60.
function pushbutton60_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton61.
function pushbutton61_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton62.
function pushbutton62_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton63.
function pushbutton63_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton63 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton64.
function pushbutton64_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton65.
function pushbutton65_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton65 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton66.
function pushbutton66_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton66 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit142_Callback(hObject, eventdata, handles)
% hObject    handle to edit142 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit142 as text
%        str2double(get(hObject,'String')) returns contents of edit142 as a double


% --- Executes during object creation, after setting all properties.
function edit142_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit142 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit143_Callback(hObject, eventdata, handles)
% hObject    handle to edit143 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit143 as text
%        str2double(get(hObject,'String')) returns contents of edit143 as a double


% --- Executes during object creation, after setting all properties.
function edit143_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit143 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit216_Callback(hObject, eventdata, handles)
% hObject    handle to edit216 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit216 as text
%        str2double(get(hObject,'String')) returns contents of edit216 as a double


% --- Executes during object creation, after setting all properties.
function edit216_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit216 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit217_Callback(hObject, eventdata, handles)
% hObject    handle to edit217 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit217 as text
%        str2double(get(hObject,'String')) returns contents of edit217 as a double


% --- Executes during object creation, after setting all properties.
function edit217_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit217 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit218_Callback(hObject, eventdata, handles)
% hObject    handle to edit218 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit218 as text
%        str2double(get(hObject,'String')) returns contents of edit218 as a double


% --- Executes during object creation, after setting all properties.
function edit218_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit218 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit219_Callback(hObject, eventdata, handles)
% hObject    handle to edit219 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit219 as text
%        str2double(get(hObject,'String')) returns contents of edit219 as a double


% --- Executes during object creation, after setting all properties.
function edit219_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit219 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit220_Callback(hObject, eventdata, handles)
% hObject    handle to edit220 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit220 as text
%        str2double(get(hObject,'String')) returns contents of edit220 as a double


% --- Executes during object creation, after setting all properties.
function edit220_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit220 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit221_Callback(hObject, eventdata, handles)
% hObject    handle to edit221 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit221 as text
%        str2double(get(hObject,'String')) returns contents of edit221 as a double


% --- Executes during object creation, after setting all properties.
function edit221_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit221 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit258_Callback(hObject, eventdata, handles)
% hObject    handle to edit258 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit258 as text
%        str2double(get(hObject,'String')) returns contents of edit258 as a double


% --- Executes during object creation, after setting all properties.
function edit258_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit258 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit259_Callback(hObject, eventdata, handles)
% hObject    handle to edit259 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit259 as text
%        str2double(get(hObject,'String')) returns contents of edit259 as a double


% --- Executes during object creation, after setting all properties.
function edit259_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit259 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit260_Callback(hObject, eventdata, handles)
% hObject    handle to edit260 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit260 as text
%        str2double(get(hObject,'String')) returns contents of edit260 as a double


% --- Executes during object creation, after setting all properties.
function edit260_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit260 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit261_Callback(hObject, eventdata, handles)
% hObject    handle to edit261 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit261 as text
%        str2double(get(hObject,'String')) returns contents of edit261 as a double


% --- Executes during object creation, after setting all properties.
function edit261_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit261 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit262_Callback(hObject, eventdata, handles)
% hObject    handle to edit262 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit262 as text
%        str2double(get(hObject,'String')) returns contents of edit262 as a double


% --- Executes during object creation, after setting all properties.
function edit262_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit262 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit263_Callback(hObject, eventdata, handles)
% hObject    handle to edit263 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit263 as text
%        str2double(get(hObject,'String')) returns contents of edit263 as a double


% --- Executes during object creation, after setting all properties.
function edit263_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit263 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit342_Callback(hObject, eventdata, handles)
% hObject    handle to edit342 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit342 as text
%        str2double(get(hObject,'String')) returns contents of edit342 as a double


% --- Executes during object creation, after setting all properties.
function edit342_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit342 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit343_Callback(hObject, eventdata, handles)
% hObject    handle to edit343 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit343 as text
%        str2double(get(hObject,'String')) returns contents of edit343 as a double


% --- Executes during object creation, after setting all properties.
function edit343_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit343 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit344_Callback(hObject, eventdata, handles)
% hObject    handle to edit344 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit344 as text
%        str2double(get(hObject,'String')) returns contents of edit344 as a double


% --- Executes during object creation, after setting all properties.
function edit344_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit344 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit345_Callback(hObject, eventdata, handles)
% hObject    handle to edit345 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit345 as text
%        str2double(get(hObject,'String')) returns contents of edit345 as a double


% --- Executes during object creation, after setting all properties.
function edit345_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit345 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit346_Callback(hObject, eventdata, handles)
% hObject    handle to edit346 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit346 as text
%        str2double(get(hObject,'String')) returns contents of edit346 as a double


% --- Executes during object creation, after setting all properties.
function edit346_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit346 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit347_Callback(hObject, eventdata, handles)
% hObject    handle to edit347 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit347 as text
%        str2double(get(hObject,'String')) returns contents of edit347 as a double


% --- Executes during object creation, after setting all properties.
function edit347_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit347 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit210_Callback(hObject, eventdata, handles)
% hObject    handle to edit210 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit210 as text
%        str2double(get(hObject,'String')) returns contents of edit210 as a double


% --- Executes during object creation, after setting all properties.
function edit210_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit210 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit211_Callback(hObject, eventdata, handles)
% hObject    handle to edit211 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit211 as text
%        str2double(get(hObject,'String')) returns contents of edit211 as a double


% --- Executes during object creation, after setting all properties.
function edit211_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit211 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit212_Callback(hObject, eventdata, handles)
% hObject    handle to edit212 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit212 as text
%        str2double(get(hObject,'String')) returns contents of edit212 as a double


% --- Executes during object creation, after setting all properties.
function edit212_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit212 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit213_Callback(hObject, eventdata, handles)
% hObject    handle to edit213 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit213 as text
%        str2double(get(hObject,'String')) returns contents of edit213 as a double


% --- Executes during object creation, after setting all properties.
function edit213_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit213 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit214_Callback(hObject, eventdata, handles)
% hObject    handle to edit214 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit214 as text
%        str2double(get(hObject,'String')) returns contents of edit214 as a double


% --- Executes during object creation, after setting all properties.
function edit214_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit214 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit215_Callback(hObject, eventdata, handles)
% hObject    handle to edit215 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit215 as text
%        str2double(get(hObject,'String')) returns contents of edit215 as a double


% --- Executes during object creation, after setting all properties.
function edit215_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit215 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit252_Callback(hObject, eventdata, handles)
% hObject    handle to edit252 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit252 as text
%        str2double(get(hObject,'String')) returns contents of edit252 as a double


% --- Executes during object creation, after setting all properties.
function edit252_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit252 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit253_Callback(hObject, eventdata, handles)
% hObject    handle to edit253 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit253 as text
%        str2double(get(hObject,'String')) returns contents of edit253 as a double


% --- Executes during object creation, after setting all properties.
function edit253_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit253 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit254_Callback(hObject, eventdata, handles)
% hObject    handle to edit254 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit254 as text
%        str2double(get(hObject,'String')) returns contents of edit254 as a double


% --- Executes during object creation, after setting all properties.
function edit254_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit254 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit255_Callback(hObject, eventdata, handles)
% hObject    handle to edit255 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit255 as text
%        str2double(get(hObject,'String')) returns contents of edit255 as a double


% --- Executes during object creation, after setting all properties.
function edit255_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit255 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit256_Callback(hObject, eventdata, handles)
% hObject    handle to edit256 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit256 as text
%        str2double(get(hObject,'String')) returns contents of edit256 as a double


% --- Executes during object creation, after setting all properties.
function edit256_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit256 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit257_Callback(hObject, eventdata, handles)
% hObject    handle to edit257 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit257 as text
%        str2double(get(hObject,'String')) returns contents of edit257 as a double


% --- Executes during object creation, after setting all properties.
function edit257_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit257 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit336_Callback(hObject, eventdata, handles)
% hObject    handle to edit336 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit336 as text
%        str2double(get(hObject,'String')) returns contents of edit336 as a double


% --- Executes during object creation, after setting all properties.
function edit336_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit336 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit337_Callback(hObject, eventdata, handles)
% hObject    handle to edit337 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit337 as text
%        str2double(get(hObject,'String')) returns contents of edit337 as a double


% --- Executes during object creation, after setting all properties.
function edit337_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit337 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit338_Callback(hObject, eventdata, handles)
% hObject    handle to edit338 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit338 as text
%        str2double(get(hObject,'String')) returns contents of edit338 as a double


% --- Executes during object creation, after setting all properties.
function edit338_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit338 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit339_Callback(hObject, eventdata, handles)
% hObject    handle to edit339 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit339 as text
%        str2double(get(hObject,'String')) returns contents of edit339 as a double


% --- Executes during object creation, after setting all properties.
function edit339_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit339 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit340_Callback(hObject, eventdata, handles)
% hObject    handle to edit340 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit340 as text
%        str2double(get(hObject,'String')) returns contents of edit340 as a double


% --- Executes during object creation, after setting all properties.
function edit340_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit340 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit341_Callback(hObject, eventdata, handles)
% hObject    handle to edit341 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit341 as text
%        str2double(get(hObject,'String')) returns contents of edit341 as a double


% --- Executes during object creation, after setting all properties.
function edit341_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit341 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit204_Callback(hObject, eventdata, handles)
% hObject    handle to edit204 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit204 as text
%        str2double(get(hObject,'String')) returns contents of edit204 as a double


% --- Executes during object creation, after setting all properties.
function edit204_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit204 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit205_Callback(hObject, eventdata, handles)
% hObject    handle to edit205 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit205 as text
%        str2double(get(hObject,'String')) returns contents of edit205 as a double


% --- Executes during object creation, after setting all properties.
function edit205_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit205 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit206_Callback(hObject, eventdata, handles)
% hObject    handle to edit206 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit206 as text
%        str2double(get(hObject,'String')) returns contents of edit206 as a double


% --- Executes during object creation, after setting all properties.
function edit206_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit206 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit207_Callback(hObject, eventdata, handles)
% hObject    handle to edit207 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit207 as text
%        str2double(get(hObject,'String')) returns contents of edit207 as a double


% --- Executes during object creation, after setting all properties.
function edit207_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit207 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit208_Callback(hObject, eventdata, handles)
% hObject    handle to edit208 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit208 as text
%        str2double(get(hObject,'String')) returns contents of edit208 as a double


% --- Executes during object creation, after setting all properties.
function edit208_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit208 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit209_Callback(hObject, eventdata, handles)
% hObject    handle to edit209 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit209 as text
%        str2double(get(hObject,'String')) returns contents of edit209 as a double


% --- Executes during object creation, after setting all properties.
function edit209_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit209 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit246_Callback(hObject, eventdata, handles)
% hObject    handle to edit246 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit246 as text
%        str2double(get(hObject,'String')) returns contents of edit246 as a double


% --- Executes during object creation, after setting all properties.
function edit246_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit246 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit247_Callback(hObject, eventdata, handles)
% hObject    handle to edit247 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit247 as text
%        str2double(get(hObject,'String')) returns contents of edit247 as a double


% --- Executes during object creation, after setting all properties.
function edit247_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit247 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit248_Callback(hObject, eventdata, handles)
% hObject    handle to edit248 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit248 as text
%        str2double(get(hObject,'String')) returns contents of edit248 as a double


% --- Executes during object creation, after setting all properties.
function edit248_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit248 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit249_Callback(hObject, eventdata, handles)
% hObject    handle to edit249 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit249 as text
%        str2double(get(hObject,'String')) returns contents of edit249 as a double


% --- Executes during object creation, after setting all properties.
function edit249_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit249 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit250_Callback(hObject, eventdata, handles)
% hObject    handle to edit250 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit250 as text
%        str2double(get(hObject,'String')) returns contents of edit250 as a double


% --- Executes during object creation, after setting all properties.
function edit250_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit250 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit251_Callback(hObject, eventdata, handles)
% hObject    handle to edit251 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit251 as text
%        str2double(get(hObject,'String')) returns contents of edit251 as a double


% --- Executes during object creation, after setting all properties.
function edit251_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit251 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit330_Callback(hObject, eventdata, handles)
% hObject    handle to edit330 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit330 as text
%        str2double(get(hObject,'String')) returns contents of edit330 as a double


% --- Executes during object creation, after setting all properties.
function edit330_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit330 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit331_Callback(hObject, eventdata, handles)
% hObject    handle to edit331 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit331 as text
%        str2double(get(hObject,'String')) returns contents of edit331 as a double


% --- Executes during object creation, after setting all properties.
function edit331_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit331 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit332_Callback(hObject, eventdata, handles)
% hObject    handle to edit332 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit332 as text
%        str2double(get(hObject,'String')) returns contents of edit332 as a double


% --- Executes during object creation, after setting all properties.
function edit332_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit332 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit333_Callback(hObject, eventdata, handles)
% hObject    handle to edit333 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit333 as text
%        str2double(get(hObject,'String')) returns contents of edit333 as a double


% --- Executes during object creation, after setting all properties.
function edit333_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit333 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit334_Callback(hObject, eventdata, handles)
% hObject    handle to edit334 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit334 as text
%        str2double(get(hObject,'String')) returns contents of edit334 as a double


% --- Executes during object creation, after setting all properties.
function edit334_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit334 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit335_Callback(hObject, eventdata, handles)
% hObject    handle to edit335 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit335 as text
%        str2double(get(hObject,'String')) returns contents of edit335 as a double


% --- Executes during object creation, after setting all properties.
function edit335_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit335 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit198_Callback(hObject, eventdata, handles)
% hObject    handle to edit198 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit198 as text
%        str2double(get(hObject,'String')) returns contents of edit198 as a double


% --- Executes during object creation, after setting all properties.
function edit198_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit198 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit199_Callback(hObject, eventdata, handles)
% hObject    handle to edit199 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit199 as text
%        str2double(get(hObject,'String')) returns contents of edit199 as a double


% --- Executes during object creation, after setting all properties.
function edit199_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit199 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit200_Callback(hObject, eventdata, handles)
% hObject    handle to edit200 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit200 as text
%        str2double(get(hObject,'String')) returns contents of edit200 as a double


% --- Executes during object creation, after setting all properties.
function edit200_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit200 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit201_Callback(hObject, eventdata, handles)
% hObject    handle to edit201 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit201 as text
%        str2double(get(hObject,'String')) returns contents of edit201 as a double


% --- Executes during object creation, after setting all properties.
function edit201_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit201 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit202_Callback(hObject, eventdata, handles)
% hObject    handle to edit202 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit202 as text
%        str2double(get(hObject,'String')) returns contents of edit202 as a double


% --- Executes during object creation, after setting all properties.
function edit202_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit202 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit203_Callback(hObject, eventdata, handles)
% hObject    handle to edit203 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit203 as text
%        str2double(get(hObject,'String')) returns contents of edit203 as a double


% --- Executes during object creation, after setting all properties.
function edit203_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit203 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit240_Callback(hObject, eventdata, handles)
% hObject    handle to edit240 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit240 as text
%        str2double(get(hObject,'String')) returns contents of edit240 as a double


% --- Executes during object creation, after setting all properties.
function edit240_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit240 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit241_Callback(hObject, eventdata, handles)
% hObject    handle to edit241 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit241 as text
%        str2double(get(hObject,'String')) returns contents of edit241 as a double


% --- Executes during object creation, after setting all properties.
function edit241_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit241 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit242_Callback(hObject, eventdata, handles)
% hObject    handle to edit242 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit242 as text
%        str2double(get(hObject,'String')) returns contents of edit242 as a double


% --- Executes during object creation, after setting all properties.
function edit242_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit242 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit243_Callback(hObject, eventdata, handles)
% hObject    handle to edit243 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit243 as text
%        str2double(get(hObject,'String')) returns contents of edit243 as a double


% --- Executes during object creation, after setting all properties.
function edit243_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit243 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit244_Callback(hObject, eventdata, handles)
% hObject    handle to edit244 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit244 as text
%        str2double(get(hObject,'String')) returns contents of edit244 as a double


% --- Executes during object creation, after setting all properties.
function edit244_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit244 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit245_Callback(hObject, eventdata, handles)
% hObject    handle to edit245 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit245 as text
%        str2double(get(hObject,'String')) returns contents of edit245 as a double


% --- Executes during object creation, after setting all properties.
function edit245_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit245 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit324_Callback(hObject, eventdata, handles)
% hObject    handle to edit324 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit324 as text
%        str2double(get(hObject,'String')) returns contents of edit324 as a double


% --- Executes during object creation, after setting all properties.
function edit324_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit324 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit325_Callback(hObject, eventdata, handles)
% hObject    handle to edit325 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit325 as text
%        str2double(get(hObject,'String')) returns contents of edit325 as a double


% --- Executes during object creation, after setting all properties.
function edit325_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit325 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit326_Callback(hObject, eventdata, handles)
% hObject    handle to edit326 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit326 as text
%        str2double(get(hObject,'String')) returns contents of edit326 as a double


% --- Executes during object creation, after setting all properties.
function edit326_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit326 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit327_Callback(hObject, eventdata, handles)
% hObject    handle to edit327 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit327 as text
%        str2double(get(hObject,'String')) returns contents of edit327 as a double


% --- Executes during object creation, after setting all properties.
function edit327_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit327 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit328_Callback(hObject, eventdata, handles)
% hObject    handle to edit328 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit328 as text
%        str2double(get(hObject,'String')) returns contents of edit328 as a double


% --- Executes during object creation, after setting all properties.
function edit328_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit328 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit329_Callback(hObject, eventdata, handles)
% hObject    handle to edit329 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit329 as text
%        str2double(get(hObject,'String')) returns contents of edit329 as a double


% --- Executes during object creation, after setting all properties.
function edit329_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit329 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit192_Callback(hObject, eventdata, handles)
% hObject    handle to edit192 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit192 as text
%        str2double(get(hObject,'String')) returns contents of edit192 as a double


% --- Executes during object creation, after setting all properties.
function edit192_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit192 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit193_Callback(hObject, eventdata, handles)
% hObject    handle to edit193 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit193 as text
%        str2double(get(hObject,'String')) returns contents of edit193 as a double


% --- Executes during object creation, after setting all properties.
function edit193_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit193 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit194_Callback(hObject, eventdata, handles)
% hObject    handle to edit194 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit194 as text
%        str2double(get(hObject,'String')) returns contents of edit194 as a double


% --- Executes during object creation, after setting all properties.
function edit194_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit194 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit195_Callback(hObject, eventdata, handles)
% hObject    handle to edit195 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit195 as text
%        str2double(get(hObject,'String')) returns contents of edit195 as a double


% --- Executes during object creation, after setting all properties.
function edit195_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit195 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit196_Callback(hObject, eventdata, handles)
% hObject    handle to edit196 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit196 as text
%        str2double(get(hObject,'String')) returns contents of edit196 as a double


% --- Executes during object creation, after setting all properties.
function edit196_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit196 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit197_Callback(hObject, eventdata, handles)
% hObject    handle to edit197 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit197 as text
%        str2double(get(hObject,'String')) returns contents of edit197 as a double


% --- Executes during object creation, after setting all properties.
function edit197_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit197 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit234_Callback(hObject, eventdata, handles)
% hObject    handle to edit234 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit234 as text
%        str2double(get(hObject,'String')) returns contents of edit234 as a double


% --- Executes during object creation, after setting all properties.
function edit234_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit234 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit235_Callback(hObject, eventdata, handles)
% hObject    handle to edit235 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit235 as text
%        str2double(get(hObject,'String')) returns contents of edit235 as a double


% --- Executes during object creation, after setting all properties.
function edit235_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit235 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit236_Callback(hObject, eventdata, handles)
% hObject    handle to edit236 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit236 as text
%        str2double(get(hObject,'String')) returns contents of edit236 as a double


% --- Executes during object creation, after setting all properties.
function edit236_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit236 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit237_Callback(hObject, eventdata, handles)
% hObject    handle to edit237 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit237 as text
%        str2double(get(hObject,'String')) returns contents of edit237 as a double


% --- Executes during object creation, after setting all properties.
function edit237_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit237 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit238_Callback(hObject, eventdata, handles)
% hObject    handle to edit238 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit238 as text
%        str2double(get(hObject,'String')) returns contents of edit238 as a double


% --- Executes during object creation, after setting all properties.
function edit238_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit238 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit239_Callback(hObject, eventdata, handles)
% hObject    handle to edit239 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit239 as text
%        str2double(get(hObject,'String')) returns contents of edit239 as a double


% --- Executes during object creation, after setting all properties.
function edit239_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit239 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit318_Callback(hObject, eventdata, handles)
% hObject    handle to edit318 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit318 as text
%        str2double(get(hObject,'String')) returns contents of edit318 as a double


% --- Executes during object creation, after setting all properties.
function edit318_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit318 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit319_Callback(hObject, eventdata, handles)
% hObject    handle to edit319 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit319 as text
%        str2double(get(hObject,'String')) returns contents of edit319 as a double


% --- Executes during object creation, after setting all properties.
function edit319_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit319 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit320_Callback(hObject, eventdata, handles)
% hObject    handle to edit320 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit320 as text
%        str2double(get(hObject,'String')) returns contents of edit320 as a double


% --- Executes during object creation, after setting all properties.
function edit320_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit320 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit321_Callback(hObject, eventdata, handles)
% hObject    handle to edit321 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit321 as text
%        str2double(get(hObject,'String')) returns contents of edit321 as a double


% --- Executes during object creation, after setting all properties.
function edit321_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit321 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit322_Callback(hObject, eventdata, handles)
% hObject    handle to edit322 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit322 as text
%        str2double(get(hObject,'String')) returns contents of edit322 as a double


% --- Executes during object creation, after setting all properties.
function edit322_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit322 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit323_Callback(hObject, eventdata, handles)
% hObject    handle to edit323 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit323 as text
%        str2double(get(hObject,'String')) returns contents of edit323 as a double


% --- Executes during object creation, after setting all properties.
function edit323_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit323 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit186_Callback(hObject, eventdata, handles)
% hObject    handle to edit186 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit186 as text
%        str2double(get(hObject,'String')) returns contents of edit186 as a double


% --- Executes during object creation, after setting all properties.
function edit186_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit186 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit187_Callback(hObject, eventdata, handles)
% hObject    handle to edit187 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit187 as text
%        str2double(get(hObject,'String')) returns contents of edit187 as a double


% --- Executes during object creation, after setting all properties.
function edit187_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit187 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit188_Callback(hObject, eventdata, handles)
% hObject    handle to edit188 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit188 as text
%        str2double(get(hObject,'String')) returns contents of edit188 as a double


% --- Executes during object creation, after setting all properties.
function edit188_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit188 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit189_Callback(hObject, eventdata, handles)
% hObject    handle to edit189 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit189 as text
%        str2double(get(hObject,'String')) returns contents of edit189 as a double


% --- Executes during object creation, after setting all properties.
function edit189_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit189 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit190_Callback(hObject, eventdata, handles)
% hObject    handle to edit190 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit190 as text
%        str2double(get(hObject,'String')) returns contents of edit190 as a double


% --- Executes during object creation, after setting all properties.
function edit190_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit190 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit191_Callback(hObject, eventdata, handles)
% hObject    handle to edit191 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit191 as text
%        str2double(get(hObject,'String')) returns contents of edit191 as a double


% --- Executes during object creation, after setting all properties.
function edit191_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit191 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit228_Callback(hObject, eventdata, handles)
% hObject    handle to edit228 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit228 as text
%        str2double(get(hObject,'String')) returns contents of edit228 as a double


% --- Executes during object creation, after setting all properties.
function edit228_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit228 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit229_Callback(hObject, eventdata, handles)
% hObject    handle to edit229 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit229 as text
%        str2double(get(hObject,'String')) returns contents of edit229 as a double


% --- Executes during object creation, after setting all properties.
function edit229_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit229 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit230_Callback(hObject, eventdata, handles)
% hObject    handle to edit230 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit230 as text
%        str2double(get(hObject,'String')) returns contents of edit230 as a double


% --- Executes during object creation, after setting all properties.
function edit230_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit230 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit231_Callback(hObject, eventdata, handles)
% hObject    handle to edit231 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit231 as text
%        str2double(get(hObject,'String')) returns contents of edit231 as a double


% --- Executes during object creation, after setting all properties.
function edit231_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit231 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit232_Callback(hObject, eventdata, handles)
% hObject    handle to edit232 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit232 as text
%        str2double(get(hObject,'String')) returns contents of edit232 as a double


% --- Executes during object creation, after setting all properties.
function edit232_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit232 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit233_Callback(hObject, eventdata, handles)
% hObject    handle to edit233 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit233 as text
%        str2double(get(hObject,'String')) returns contents of edit233 as a double


% --- Executes during object creation, after setting all properties.
function edit233_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit233 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit312_Callback(hObject, eventdata, handles)
% hObject    handle to edit312 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit312 as text
%        str2double(get(hObject,'String')) returns contents of edit312 as a double


% --- Executes during object creation, after setting all properties.
function edit312_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit312 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit313_Callback(hObject, eventdata, handles)
% hObject    handle to edit313 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit313 as text
%        str2double(get(hObject,'String')) returns contents of edit313 as a double


% --- Executes during object creation, after setting all properties.
function edit313_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit313 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit314_Callback(hObject, eventdata, handles)
% hObject    handle to edit314 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit314 as text
%        str2double(get(hObject,'String')) returns contents of edit314 as a double


% --- Executes during object creation, after setting all properties.
function edit314_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit314 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit315_Callback(hObject, eventdata, handles)
% hObject    handle to edit315 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit315 as text
%        str2double(get(hObject,'String')) returns contents of edit315 as a double


% --- Executes during object creation, after setting all properties.
function edit315_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit315 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit316_Callback(hObject, eventdata, handles)
% hObject    handle to edit316 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit316 as text
%        str2double(get(hObject,'String')) returns contents of edit316 as a double


% --- Executes during object creation, after setting all properties.
function edit316_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit316 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit317_Callback(hObject, eventdata, handles)
% hObject    handle to edit317 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit317 as text
%        str2double(get(hObject,'String')) returns contents of edit317 as a double


% --- Executes during object creation, after setting all properties.
function edit317_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit317 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit180_Callback(hObject, eventdata, handles)
% hObject    handle to edit180 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit180 as text
%        str2double(get(hObject,'String')) returns contents of edit180 as a double


% --- Executes during object creation, after setting all properties.
function edit180_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit180 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit181_Callback(hObject, eventdata, handles)
% hObject    handle to edit181 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit181 as text
%        str2double(get(hObject,'String')) returns contents of edit181 as a double


% --- Executes during object creation, after setting all properties.
function edit181_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit181 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit182_Callback(hObject, eventdata, handles)
% hObject    handle to edit182 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit182 as text
%        str2double(get(hObject,'String')) returns contents of edit182 as a double


% --- Executes during object creation, after setting all properties.
function edit182_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit182 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit183_Callback(hObject, eventdata, handles)
% hObject    handle to edit183 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit183 as text
%        str2double(get(hObject,'String')) returns contents of edit183 as a double


% --- Executes during object creation, after setting all properties.
function edit183_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit183 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton67.
function pushbutton67_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton68.
function pushbutton68_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton68 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton69.
function pushbutton69_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton69 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton70.
function pushbutton70_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton70 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton71.
function pushbutton71_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton71 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton72.
function pushbutton72_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton72 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton73.
function pushbutton73_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton73 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit184_Callback(hObject, eventdata, handles)
% hObject    handle to edit184 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit184 as text
%        str2double(get(hObject,'String')) returns contents of edit184 as a double


% --- Executes during object creation, after setting all properties.
function edit184_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit184 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit185_Callback(hObject, eventdata, handles)
% hObject    handle to edit185 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit185 as text
%        str2double(get(hObject,'String')) returns contents of edit185 as a double


% --- Executes during object creation, after setting all properties.
function edit185_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit185 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit222_Callback(hObject, eventdata, handles)
% hObject    handle to edit222 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit222 as text
%        str2double(get(hObject,'String')) returns contents of edit222 as a double


% --- Executes during object creation, after setting all properties.
function edit222_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit222 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit223_Callback(hObject, eventdata, handles)
% hObject    handle to edit223 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit223 as text
%        str2double(get(hObject,'String')) returns contents of edit223 as a double


% --- Executes during object creation, after setting all properties.
function edit223_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit223 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit224_Callback(hObject, eventdata, handles)
% hObject    handle to edit224 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit224 as text
%        str2double(get(hObject,'String')) returns contents of edit224 as a double


% --- Executes during object creation, after setting all properties.
function edit224_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit224 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit225_Callback(hObject, eventdata, handles)
% hObject    handle to edit225 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit225 as text
%        str2double(get(hObject,'String')) returns contents of edit225 as a double


% --- Executes during object creation, after setting all properties.
function edit225_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit225 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton74.
function pushbutton74_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton74 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton75.
function pushbutton75_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton75 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton76.
function pushbutton76_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton76 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton77.
function pushbutton77_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton77 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton78.
function pushbutton78_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton78 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton79.
function pushbutton79_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton79 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton80.
function pushbutton80_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton80 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit226_Callback(hObject, eventdata, handles)
% hObject    handle to edit226 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit226 as text
%        str2double(get(hObject,'String')) returns contents of edit226 as a double


% --- Executes during object creation, after setting all properties.
function edit226_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit226 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit227_Callback(hObject, eventdata, handles)
% hObject    handle to edit227 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit227 as text
%        str2double(get(hObject,'String')) returns contents of edit227 as a double


% --- Executes during object creation, after setting all properties.
function edit227_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit227 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit306_Callback(hObject, eventdata, handles)
% hObject    handle to edit306 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit306 as text
%        str2double(get(hObject,'String')) returns contents of edit306 as a double


% --- Executes during object creation, after setting all properties.
function edit306_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit306 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit307_Callback(hObject, eventdata, handles)
% hObject    handle to edit307 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit307 as text
%        str2double(get(hObject,'String')) returns contents of edit307 as a double


% --- Executes during object creation, after setting all properties.
function edit307_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit307 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit308_Callback(hObject, eventdata, handles)
% hObject    handle to edit308 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit308 as text
%        str2double(get(hObject,'String')) returns contents of edit308 as a double


% --- Executes during object creation, after setting all properties.
function edit308_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit308 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit309_Callback(hObject, eventdata, handles)
% hObject    handle to edit309 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit309 as text
%        str2double(get(hObject,'String')) returns contents of edit309 as a double


% --- Executes during object creation, after setting all properties.
function edit309_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit309 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton88.
function pushbutton88_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton88 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton89.
function pushbutton89_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton89 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton90.
function pushbutton90_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton90 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton91.
function pushbutton91_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton91 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton92.
function pushbutton92_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton92 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton93.
function pushbutton93_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton93 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton94.
function pushbutton94_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton94 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit310_Callback(hObject, eventdata, handles)
% hObject    handle to edit310 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit310 as text
%        str2double(get(hObject,'String')) returns contents of edit310 as a double


% --- Executes during object creation, after setting all properties.
function edit310_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit310 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit311_Callback(hObject, eventdata, handles)
% hObject    handle to edit311 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit311 as text
%        str2double(get(hObject,'String')) returns contents of edit311 as a double


% --- Executes during object creation, after setting all properties.
function edit311_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit311 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in microdrive_number.
function microdrive_number_Callback(hObject, eventdata, handles)
    global experiment microdrive_type electrode_type
% hObject    handle to microdrive_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns microdrive_number contents as cell array
%        contents{get(hObject,'Value')} returns selected item from microdrive_number
contents = get(hObject,'String') ;
microdrive_number_selected = str2num(contents{get(hObject,'Value')})

if(experiment.acquire.microdrive(microdrive_number_selected).pitch.available == 0)
    set(handles.microdrive_pitch,'Visible','off');
    set(handles.Pitch_Label,'Visible','off');
else
    set(handles.microdrive_pitch,'Visible','on');
    set(handles.Pitch_Label,'Visible','on');   
    set(handles.microdrive_pitch,'String',experiment.hardware.microdrive(microdrive_number_selected).coordinate.pitch);
end
if(experiment.acquire.microdrive(microdrive_number_selected).yaw.available == 0)
    set(handles.microdrive_yaw,'Visible','off');
    set(handles.Yaw_Label,'Visible','off');
else
    set(handles.microdrive_yaw,'Visible','on');
    set(handles.Yaw_Label,'Visible','on');   
    set(handles.microdrive_yaw,'String',experiment.hardware.microdrive(microdrive_number_selected).coordinate.yaw);
end
if(experiment.acquire.microdrive(microdrive_number_selected).x.available == 0)
    set(handles.microdrive_x,'Visible','off');
    set(handles.X_Label,'Visible','off');
else
    set(handles.microdrive_x,'Visible','on');
    set(handles.X_Label,'Visible','on');   
    set(handles.microdrive_x,'String',experiment.hardware.microdrive(microdrive_number_selected).coordinate.x);
end
if(experiment.acquire.microdrive(microdrive_number_selected).y.available == 0)
    set(handles.microdrive_y,'Visible','off');
    set(handles.Y_Label,'Visible','off');
else
    set(handles.microdrive_y,'Visible','on');
    set(handles.Y_Label,'Visible','on');   
    set(handles.microdrive_y,'String',experiment.hardware.microdrive(microdrive_number_selected).coordinate.y);
end
set(handles.microdrive_name,'String',experiment.hardware.microdrive(microdrive_number_selected).name);
set(handles.microdrive_type,'String',microdrive_type);
set(handles.microdrive_type,'Value',find(ismember(microdrive_type,experiment.hardware.microdrive(microdrive_number_selected).type)));



tmp_length = length(experiment.hardware.microdrive(microdrive_number_selected).electrodes);
for i = 1:tmp_length
    electrode_array{i} = num2str(i);
end
set(handles.electrode_number,'String',electrode_array);
set(handles.electrode_number,'Value',1);

set(handles.electrode_motorid,'String',experiment.hardware.microdrive(microdrive_number_selected).electrodes(1).motorid);
set(handles.electrode_group,'String',experiment.hardware.microdrive(microdrive_number_selected).electrodes(1).motorgroupid);
set(handles.electrode_acquisitionid,'String',experiment.hardware.microdrive(microdrive_number_selected).electrodes(1).acquisitionid);
set(handles.electrode_channel,'String',experiment.hardware.microdrive(microdrive_number_selected).electrodes(1).channelid);
set(handles.electrode_label,'String',experiment.hardware.microdrive(microdrive_number_selected).electrodes(1).label);
set(handles.electrode_type,'String',electrode_type);
set(handles.electrode_type,'Value',find(ismember(electrode_type,experiment.hardware.microdrive(microdrive_number_selected).electrodes(1).type)));

if(experiment.acquire.microdrive(microdrive_number_selected).electrodes(1).gain.available == 0)
    set(handles.electrode_gain,'Visible','off');
    set(handles.Gain_Label,'Visible','off');
else
    set(handles.electrode_gain,'Visible','on');
    set(handles.Gain_Label,'Visible','on');   
    set(handles.electrode_gain,'String',experiment.hardware.microdrive(microdrive_number_selected).electrodes(1).gain);
end



% --- Executes during object creation, after setting all properties.
function microdrive_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to microdrive_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu34.
function popupmenu34_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu34 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu34


% --- Executes during object creation, after setting all properties.
function popupmenu34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in microdrive_type2.
function Microdrive_type_Callback(hObject, eventdata, handles)
% hObject    handle to microdrive_type2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns microdrive_type2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from microdrive_type2
global experiment 

contents = get(handles.microdrive_number,'String') ;
microdrive_number_selected = str2num(contents{get(handles.microdrive_number,'Value')})
contents = get(hObject,'String')
contents{get(hObject,'Value')}
experiment.hardware.microdrive(microdrive_number_selected).type = contents{get(hObject,'Value')};

% --- Executes during object creation, after setting all properties.
function Microdrive_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to microdrive_type2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in electrode_number.
function electrode_number_Callback(hObject, eventdata, handles)
% hObject    handle to electrode_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns electrode_number contents as cell array
%        contents{get(hObject,'Value')} returns selected item from electrode_number

global experiment electrode_type 

contents = get(handles.microdrive_number,'String') ;
microdrive_number_selected = str2num(contents{get(handles.microdrive_number,'Value')})
contents = get(hObject,'String') ;
electrode_number_selected = str2num(contents{get(hObject,'Value')})

set(handles.electrode_motorid,'String',experiment.hardware.microdrive(microdrive_number_selected).electrodes(electrode_number_selected).motorid);
set(handles.electrode_group,'String',experiment.hardware.microdrive(microdrive_number_selected).electrodes(electrode_number_selected).motorgroupid);
set(handles.electrode_acquisitionid,'String',experiment.hardware.microdrive(microdrive_number_selected).electrodes(electrode_number_selected).acquisitionid);
set(handles.electrode_channel,'String',experiment.hardware.microdrive(microdrive_number_selected).electrodes(electrode_number_selected).channelid);
set(handles.electrode_label,'String',experiment.hardware.microdrive(microdrive_number_selected).electrodes(electrode_number_selected).label);
set(handles.electrode_type,'Value',find(ismember(electrode_type,experiment.hardware.microdrive(microdrive_number_selected).electrodes(electrode_number_selected).type)));

if(experiment.acquire.microdrive(microdrive_number_selected).electrodes(electrode_number_selected).gain.available == 0)
    set(handles.electrode_gain,'Visible','off');
    set(handles.Gain_Label,'Visible','off');
else
    set(handles.electrode_gain,'Visible','on');
    set(handles.Gain_Label,'Visible','on');   
    set(handles.electrode_gain,'String',experiment.hardware.microdrive(microdrive_number_selected).electrodes(electrode_number_selected).gain);
end



% --- Executes during object creation, after setting all properties.
function electrode_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to electrode_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in electrode_type.
function electrode_type_Callback(hObject, eventdata, handles)
% hObject    handle to electrode_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns electrode_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from electrode_type

global experiment
contents = get(handles.microdrive_number,'String') ;
microdrive_number_selected = str2num(contents{get(handles.microdrive_number,'Value')})
contents = get(handles.electrode_number,'String') ;
electrode_number_selected = str2num(contents{get(handles.electrode_number,'Value')})
contents = get(hObject,'String')
experiment.hardware.microdrive(microdrive_number_selected).electrodes(electrode_number_selected).type = contents{get(hObject,'Value')};


% --- Executes during object creation, after setting all properties.
function electrode_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to electrode_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcmotoridns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in microdrive_type2.
function microdrive_type2_Callback(hObject, eventdata, handles)
% hObject    handle to microdrive_type2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns microdrive_type2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from microdrive_type2


% --- Executes during object creation, after setting all properties.
function microdrive_type2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to microdrive_type2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function microdrive_name_Callback(hObject, eventdata, handles)
% hObject    handle to microdrive_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of microdrive_name as text
%        str2double(get(hObject,'String')) returns contents of microdrive_name as a double
global experiment 

contents = get(handles.microdrive_number,'String') ;
microdrive_number_selected = str2num(contents{get(handles.microdrive_number,'Value')})
experiment.hardware.microdrive(microdrive_number_selected).name = get(hObject,'String')

% --- Executes during object creation, after setting all properties.
function microdrive_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to microdrive_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in microdrive_type.
function microdrive_type_Callback(hObject, eventdata, handles)
% hObject    handle to microdrive_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns microdrive_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from microdrive_type
global experiment 
disp('yan')
contents = get(handles.microdrive_number,'String') ;
microdrive_number_selected = str2num(contents{get(handles.microdrive_number,'Value')})
contents = get(hObject,'String');
experiment.hardware.microdrive(microdrive_number_selected).type = contents{get(hObject,'Value')};

% --- Executes during object creation, after setting all properties.
function microdrive_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to microdrive_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit43_Callback(hObject, eventdata, handles)
% hObject    handle to edit43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit43 as text
%        str2double(get(hObject,'String')) returns contents of edit43 as a double


% --- Executes during object creation, after setting all properties.
function edit43_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit44_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function electrode_gain_Callback(hObject, eventdata, handles)
% hObject    handle to electrode_gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of electrode_gain as text
%        str2double(get(hObject,'String')) returns contents of electrode_gain as a double
global experiment 

contents = get(handles.microdrive_number,'String') ;
microdrive_number_selected = str2num(contents{get(handles.microdrive_number,'Value')})
contents = get(handles.electrode_number,'String') ;
electrode_number_selected = str2num(contents{get(handles.electrode_number,'Value')})
experiment.hardware.microdrive(microdrive_number_selected).electrodes(electrode_number_selected).gain = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function electrode_gain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to electrode_gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


