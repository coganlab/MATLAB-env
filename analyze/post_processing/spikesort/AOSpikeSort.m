function varargout = AOSpikeSort(varargin)
% SPIKESORT_V3_V2 Application M-file for SpikeSort.fig
%    FIG = SPIKESORT_V3_V2 launch SpikeSort GUI.
%    SPIKESORT_V3_V2('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 24-Apr-2012 14:07:10

global MONKEYDIR

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));
    set(fig,'DoubleBuffer','on');
    set(fig,'Name','AOSpikeSort (Exp Def File)');

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

    %  Generate recording day list
    disp('Generate recording day list');
    Dir = getRecordingDays;
    set(handles.popDay,'String',Dir(end).name)
    day = get(handles.popDay,'String');
    UpdateDay(handles,day);
    set(handles.pbLoadSort,'Visible','off');
    set(handles.pbLoadMovie,'Visible','off');
% 
%     WaveformData(1).N = 0;
%     WaveformData(1).Waveforms = zeros(14,21);
%     set(handles.frCompare,'UserData',WaveformData);
    %  Generate display dim list
    cellnumarr = {'1','2','3','4','5','6','7',...
            '8','9','10','11','12','13','14'};
    set(handles.popDim1,'String',{'1','2','3','4','5','6'});
    set(handles.popDim2,'String',{'1','2','3','4','5','6'});
    set(handles.popDim3,'String',{'1','2','3','4','5','6'});
    set(handles.popDim1,'Value',1);
    set(handles.popDim2,'Value',2);
    set(handles.popDim3,'Value',3);
    set(handles.Xlabel1,'String','PC 1');
    set(handles.Xlabel2,'String','PC 1');
    set(handles.Xlabel3,'String','PC 2');
    set(handles.Ylabel1,'String','PC 2');
    set(handles.Ylabel2,'String','PC 3');
    set(handles.Ylabel3,'String','PC 3');
%     set(handles.PClabel1,'String','PC 1');
%     set(handles.PClabel2,'String','PC 2');
%     set(handles.PClabel3,'String','PC 3');
    set(handles.popNClus,'String',cellnumarr);
    set(handles.popNClus,'Value',2);
    set(handles.popNDim,'String',{'1','2','3','4','5','6'});
    set(handles.popNDim,'Value',3);
    

    for iCl = 1:14
        eval(['a = handles.pop' num2str(iCl) ';']);
        set(a,'String',cellnumarr,'Value',iCl);
        eval(['a = handles.st' num2str(iCl) ';']);
        set(a,'ForegroundColor',mycolors(iCl));
    end
    

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


%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.


% --------------------------------------------------------------------
function [day,rec,mt,ch,contact] = RecInformation(handles)

global MONKEYDIR 

day = get(handles.popDay,'String');
RecString = get(handles.popRec,'String');
RecValue = get(handles.popRec,'Value');
rec = RecString{RecValue};
MTString = get(handles.popMT,'String');
MTValue = get(handles.popMT,'Value');
mt = MTString{MTValue};
ChString = get(handles.popChannel,'String');
ChValue = get(handles.popChannel,'Value');
ch = str2double(ChString{ChValue});
ContactString = get(handles.popContact,'String');
ContactValue = get(handles.popContact,'Value');
contact = str2double(ContactString{ContactValue});



% --------------------------------------------------------------------
function varargout = pbLoad_Callback(h, eventdata, handles, varargin)

global MONKEYDIR experiment


[day,rec,mt,ch,contact] = RecInformation(handles);
if exist([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat'],'file')
    load([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat']);
end

%mtch = ch2mtch(Rec,mt,ch);


filename = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.sp.mat'];
disp(['Loading from ' filename]);
load(filename);
mtch = ch;
if exist('experiment','var')
    if isfield(experiment,'hardware')
        if isfield(experiment.hardware,'microdrive')
            mtch = expChannelIndex(experiment,mt,ch,contact);
        end
    end
end
sp = sp{mtch};
set(handles.pbLoad,'UserData',sp);
AOTrials = dbAOSelectTrials(day,rec);

set(handles.frTrials,'UserData',AOTrials);
whos AOTrials
if ~isempty(AOTrials);
     set(handles.stRecTrials,'String',num2str(length(AOTrials)));
%     set(handles.stSTrials,'String',num2str(length(TaskTrials(Trials,'Sacc'))));
%     set(handles.stLRTrials,'String',num2str(length(TaskTrials(Trials,'LR1T'))));
%     set(handles.stRTrials,'String',num2str(length(TaskTrials(Trials,'Fix1T'))));
%     set(handles.stSRFTrials,'String',num2str(length(TaskTrials(Trials,'SaccRF'))));
%     set(handles.stLRRFTrials,'String',num2str(length(TaskTrials(Trials,'LRRF'))));
%     set(handles.stRRFTrials,'String',num2str(length(TaskTrials(Trials,'ReachRF'))));
%     set(handles.st3TTrials,'String',num2str(length(TaskTrials(Trials,'Free3T'))));
%     set(handles.stISTrials,'String',num2str(length(TaskTrials(Trials,'IntSacc'))));
    
    %Find max and min trial depth
    
%    Depth.min=-Trials(1).Depth{1}(ch);
%    Depth.max=Depth.min;
%    for iTrial=2:length(Trials)
%        if -Trials(iTrial).Depth{1}(ch)<Depth.max
%            Depth.max=-Trials(iTrial).Depth{1}(ch);
%        elseif -Trials(iTrial).Depth{1}(ch)>Depth.min
%            Depth.min=-Trials(iTrial).Depth{1}(ch);
%        end
%    end
%    Depth.gmin = Depth.min+10;
%    Depth.gmax = Depth.max-10;
%    set(handles.frDepth,'UserData',Depth)
            
else
     set(handles.stRecTrials,'String','0');
%     set(handles.stSTrials,'String','0');
%     set(handles.stLRTrials,'String','0');
%     set(handles.stRTrials,'String','0');
%     set(handles.stSRFTrials,'String','0');
%     set(handles.stLRRFTrials,'String','0');
%     set(handles.stRRFTrials,'String','0');
%     set(handles.st3TTrials,'String','0');
%     set(handles.stISTrials,'String','0');
%     set(handles.stFrTrials,'String','0');
%     set(handles.stSFrTrials,'String','0');
%     set(handles.stLRFrTrials,'String','0');
%     set(handles.stRFrTrials,'String','0');
%     set(handles.stSRFFrTrials,'String','0');
%     set(handles.stLRRFFrTrials,'String','0');
%     set(handles.stRRFFrTrials,'String','0');
%     set(handles.st3TFrTrials,'String','0');
%     set(handles.stISFrTrials,'String','0');
end

disp('Done loading raw spikes');

% --------------------------------------------------------------------
function varargout = pbProject_Callback(h, eventdata, handles, varargin)

global MAXFRAME MONKEYDIR

sp = get(handles.pbLoad,'UserData');
IsoWin = 1e3*str2double(get(handles.edIsoWin,'String'));
sptimes = sp(:,1);
[day,rec,mt,ch,contact] = RecInformation(handles);
if isfile([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat'])
    load([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat'])
    RecDuration  = expRecDuration(experiment,day,rec);
else
    RecDuration = max(sptimes);
end
% figure;
% plot(sp([1:500],[2:end])')
T = [0:IsoWin:RecDuration RecDuration];
nFrames = length(T)-1;
disp([num2str(nFrames) ' frames']);
MAXFRAME = nFrames;
set(handles.stFrame,'String','Frame 1');
drawnow
N = zeros(1,nFrames+1);
for i = 2:nFrames+1
    N(i) = find(sptimes<T(i), 1, 'last' );
end
if length(sptimes) ~= N(2) %added by RAS on 12/12/12 to be able to sort 1 frame recordings
    N(end) = N(end)+1; %was originally there without if-end
end

    sp_seg = sp(N(1)+1:N(1+1),2:end);
    [U_seg,pcold,eigvalues] = spikepcs(sp(N(1)+1:N(2),:));
    FrameData(1).Sp = sp(N(1)+1:N(2),2:end);
    FrameData(1).U = U_seg;
    FrameData(1).SpTimes = sp(N(1)+1:N(2),1);
    FrameData(1).PC=pcold;
    FrameData(1).EigFrac=(eigvalues.^2)/sum(eigvalues.^2); %fractional sum of squares
    FrameData(1).TempInclude = ones(size(U_seg,1),1);
    set(handles.frMovie,'UserData',FrameData);

handles = RedrawMovie(handles,1);

for iFrame = 2:nFrames
    disp(['Frame ' num2str(iFrame) ' has ' num2str(N(iFrame+1)-N(iFrame)-1) ' spikes'] )
    set(handles.stFrame,'String',['Frame ' num2str(iFrame)]);
    if N(iFrame+1)-(N(iFrame)+1);
        [U_seg,pc,eigvalues] = spikepcs(sp(N(iFrame)+1:min(N(iFrame+1),end),:),pcold);
        U_old=sp(N(iFrame-1)+1:N(iFrame),2:end)*pcold;
        U_new=sp(N(iFrame-1)+1:N(iFrame),2:end)*pc;
        FrameData(iFrame).U = U_seg;
        FrameData(iFrame).PC=pc;
        FrameData(iFrame).EigFrac=(eigvalues.^2)/sum(eigvalues.^2); %fractional sum of squares
        FrameData(iFrame).Sp = sp(N(iFrame)+1:min(N(iFrame+1),end),2:end);
        FrameData(iFrame).SpTimes = sp(N(iFrame)+1:min(N(iFrame+1),end),1);
        FrameData(iFrame).TempInclude = ones(size(U_seg,1),1);
        
        set(handles.frMovie,'UserData',FrameData);        
        handles = RedrawMovie(handles,iFrame);
        pcold = pc;
    else
        FrameData(iFrame).Sp = [];
        FrameData(iFrame).SpTimes = [];
    end
end

set(handles.frMovie,'UserData',FrameData);


% --------------------------------------------------------------------
function varargout = pbBackMovie_Callback(h, eventdata, handles, varargin)

FrameString = get(handles.stFrame,'String');
FrameNumber = str2double(FrameString(7:end));
if FrameNumber > 1
    disp(['Back movie from ' num2str(FrameNumber) ' to ' num2str(FrameNumber-1)]);
    FrameNumber = FrameNumber-1;
    handles = RedrawMovie(handles,FrameNumber);
else
    disp('At beginning of movie')
end

% --------------------------------------------------------------------
function varargout = pbForwardMovie_Callback(h, eventdata, handles, varargin)

global MAXFRAME

FrameString = get(handles.stFrame,'String');
FrameNumber = str2double(FrameString(7:end));
if FrameNumber<MAXFRAME
    disp(['Forward movie from ' num2str(FrameNumber) ' to ' num2str(FrameNumber+1)]);
    FrameNumber = FrameNumber+1;
    handles = RedrawMovie(handles,FrameNumber);
else
    disp('At end of movie');
end

% --------------------------------------------------------------------
function handles = RedrawMovie(handles,FrameNumber)

disp(['Redrawing frame ' num2str(FrameNumber)])

Dim1 = get(handles.popDim1,'Value');
Dim2 = get(handles.popDim2,'Value');
Dim3 = get(handles.popDim3,'Value');
set(handles.Xlabel1,'String',['PC ' num2str(Dim1)]);
set(handles.Xlabel2,'String',['PC ' num2str(Dim1)]);
set(handles.Xlabel3,'String',['PC ' num2str(Dim2)]);
set(handles.Ylabel1,'String',['PC ' num2str(Dim2)]);
set(handles.Ylabel2,'String',['PC ' num2str(Dim3)]);
set(handles.Ylabel3,'String',['PC ' num2str(Dim3)]);
set(handles.PClabel1,'String',['PC ' num2str(Dim1)]);
set(handles.PClabel2,'String',['PC ' num2str(Dim2)]);
set(handles.PClabel3,'String',['PC ' num2str(Dim3)]);
FrameData = get(handles.frMovie,'UserData');

set(handles.stFrame,'String',['Frame ' num2str(FrameNumber)]);

U_seg = FrameData(FrameNumber).U;
U_seg = U_seg(find(FrameData(FrameNumber).TempInclude),:);

NSKIP = 1;

axes(handles.axDim12); cla;
line(U_seg(1:NSKIP:end,Dim1),U_seg(1:NSKIP:end,Dim2),'LineStyle','.','Markersize',0.5,'Color','b');

axes(handles.axDim13); cla;
line(U_seg(1:NSKIP:end,Dim1),U_seg(1:NSKIP:end,Dim3),'LineStyle','.','Markersize',0.5,'Color','b');

axes(handles.axDim23); cla;
line(U_seg(1:NSKIP:end,Dim2),U_seg(1:NSKIP:end,Dim3),'LineStyle','.','Markersize',0.5,'Color','b');

handles = setFrameTrials(handles,FrameNumber);

drawnow


% --------------------------------------------------------------------
function handles = RedrawSortMovie(handles,FrameNumber)

disp(['Redrawing Sort frame ' num2str(FrameNumber)])

Dim1 = get(handles.popDim1,'Value');
Dim2 = get(handles.popDim2,'Value');
Dim3 = get(handles.popDim3,'Value');
set(handles.Xlabel1,'String',['PC ' num2str(Dim1)]);
set(handles.Xlabel2,'String',['PC ' num2str(Dim1)]);
set(handles.Xlabel3,'String',['PC ' num2str(Dim2)]);
set(handles.Ylabel1,'String',['PC ' num2str(Dim2)]);
set(handles.Ylabel2,'String',['PC ' num2str(Dim3)]);
set(handles.Ylabel3,'String',['PC ' num2str(Dim3)]);
set(handles.PClabel1,'String',['PC ' num2str(Dim1)]);
set(handles.PClabel2,'String',['PC ' num2str(Dim2)]);
set(handles.PClabel3,'String',['PC ' num2str(Dim3)]);

% reassign frame number
set(handles.stFrame,'String',['Frame ' num2str(FrameNumber)]);
FrameData = get(handles.frMovie,'UserData');


SortData = get(handles.frSort,'UserData');
%SortData
SortData(FrameNumber).Clu = SortData(FrameNumber).Clu(SortData(FrameNumber).TempInclude>0, :);

disp('Assigning U_seg');
U_seg = SortData(FrameNumber).U;
U_seg = U_seg(SortData(FrameNumber).TempInclude>0, :);
% size(U_seg)
disp('Axes display')
axes(handles.axDim12); cla
% zoom on;
NSKIP = 2;
if (size(U_seg,2) >= Dim1) && (size(U_seg,2) >= Dim2) 
    for iClus = 1:14
        if ~SortData(FrameNumber).RemCell(iClus)
            ind = find(SortData(FrameNumber).Clu(:,2)==iClus);
            if ~isempty(ind)
                line(U_seg(ind(1:NSKIP:end),Dim1),U_seg(ind(1:NSKIP:end),Dim2),'LineStyle','.',...
                    'Markersize',0.5,'Color',mycolors(iClus));
            end
        end
    end
end

disp('Plotting ax13')
axes(handles.axDim13); cla
if (size(U_seg,2) >= Dim1) && (size(U_seg,2) >= Dim3) 
    for iClus = 1:14
        if ~SortData(FrameNumber).RemCell(iClus)
            ind = find(SortData(FrameNumber).Clu(:,2)==iClus);
            if ~isempty(ind)
                line(U_seg(ind(1:NSKIP:end),Dim1),U_seg(ind(1:NSKIP:end),Dim3),'LineStyle','.',...
                    'Markersize',0.5,'Color',mycolors(iClus));
            end
        end
    end
end

disp('Plotting ax23')
axes(handles.axDim23); cla
if (size(U_seg,2) >= Dim2) && (size(U_seg,2) >= Dim3)
    for iClus = 1:14
        if ~SortData(FrameNumber).RemCell(iClus)
            ind = find(SortData(FrameNumber).Clu(:,2)==iClus);
            if ~isempty(ind)
                line(U_seg(ind(1:NSKIP:end),Dim2),U_seg(ind(1:NSKIP:end),Dim3),'LineStyle','.',...
                    'Markersize',0.5,'Color',mycolors(iClus));
            end
        end
    end
end

disp('Plotting waveforms')
axes(handles.axWaveforms); cla;
for iFrame = 1:FrameNumber
    for iClus = 1:14
        if ~SortData(iFrame).RemCell(iClus)
            ind = find(SortData(iFrame).Clu(:,2)==iClus, 1);
            if ~isempty(ind)
                line([1:size(SortData(1).Waveform,2)],...
                    SortData(iFrame).Waveform(iClus,:),...
                    'Color',mycolors(iClus));
            end
        end
    end
end
set(gca,'XLim',[0,size(SortData(1).Waveform,2)]);

disp('Plotting FrWaveforms')
axes(handles.axFrWaveform); cla;
for iClus = 1:14
    if ~SortData(FrameNumber).RemCell(iClus)
        ind = find(SortData(FrameNumber).Clu(:,2)==iClus, 1);
        if ~isempty(ind)
            line(1:size(SortData(1).Waveform,2), ...
                SortData(FrameNumber).Waveform(iClus,:), ...
                'Color',mycolors(iClus));
        end
    end
end
set(gca,'XLim',[0,size(SortData(1).Waveform,2)]);



disp('Setting Iso checkboxes')
for iClus = 1:14
    if ~SortData(FrameNumber).RemCell(iClus)
        eval(['a = handles.ck' num2str(iClus) ';']);
        if iClus < length(SortData(FrameNumber).Iso)+1
            set(a,'Value',SortData(FrameNumber).Iso(iClus));
        else    
            set(a,'Value',0);
        end
    end
end

handles = setFrameTrials(handles,FrameNumber);

drawnow

% --------------------------------------------------------------------
function varargout = pbPlaySort_Callback(h, eventdata, handles, varargin)

SortData = get(handles.frSort,'UserData');
if get(handles.pbPlaySort,'Value')
    set(handles.pbPlaySort,'String','Pause');
else
    set(handles.pbPlaySort,'String','Play');
end
for iFrame = 1:length(SortData)
    if get(handles.pbPlaySort,'Value')
        RedrawSortMovie(handles,iFrame);
    else
        break
    end
end

% --------------------------------------------------------------------
function varargout = tbPlayMovie_Callback(h, eventdata, handles, varargin)

MovieData = get(handles.frMovie,'UserData');
if get(handles.tbPlayMovie,'Value')
    set(handles.tbPlayMovie,'String','Pause');
else
    set(handles.tbPlayMovie,'String','Play');
end
for iFrame = 1:length(MovieData)
    if get(handles.tbPlayMovie,'Value')
        RedrawMovie(handles,iFrame);
    else
        break
    end
end



% --------------------------------------------------------------------
function varargout = pbSortMovie_Callback(h, eventdata, handles, varargin)

global MAXFRAME

disp('Inside pbSortMovie');
NDim = get(handles.popNDim,'Value');
NClus = get(handles.popNClus,'Value');
FrameData = get(handles.frMovie,'UserData');

for iFrame = 1:MAXFRAME
    SortData(iFrame).Iso = zeros(1,14);
end

for firstFrame = 1:MAXFRAME
    sptimes = FrameData(firstFrame).SpTimes;
    if(length(sptimes)<10)
        disp(['Frame ' num2str(firstFrame) ' doesnt have enough spikes for initial sort']);
        SortData(firstFrame).Clu(:,1) = 0;
        SortData(firstFrame).Clu(1,1) = 1;
        SortData(firstFrame).TempInclude = ones(size(sptimes,1),1);
        SortData(firstFrame).RemCell=zeros(1,14);
        SortData(firstFrame).RemIso=SortData(firstFrame).RemCell;
    else
        break;
    end
end

length(sptimes);
SortData(firstFrame).Clu(:,1) = sptimes;
SortData(firstFrame).TempInclude = ones(size(sptimes,1),1);
SortData(firstFrame).RemCell=zeros(1,14);
SortData(firstFrame).RemIso=SortData(firstFrame).RemCell;

disp(['Frame ' num2str(firstFrame)]);
in = [sptimes FrameData(firstFrame).Sp];
[dum,pcold] = spikepcs(in);
U_seg = FrameData(firstFrame).U(:,1:NDim);
SortData(firstFrame).U = U_seg;
[centres,options,post] = kmeans(U_seg,NClus);
[dum,cind] = sort(sqrt(sum(centres'.^2)));
centres = centres(cind,:);
options(14) = 1;
[centres,options,post] = kmeans(U_seg,NClus,centres,options);

for c = 1:NClus
    ind = post(:,c)>0;
    if sum(ind)
        SortData(firstFrame).Clu(ind,2) = c;
        SortData(firstFrame).Waveform(c,:) = mean(FrameData(firstFrame).Sp(ind,:));
        eval(['hh = handles.ck' num2str(c) ';']);
        set(hh,'Value',1);
    end
end
SortData(firstFrame).Iso(1:NClus) = 1;
set(handles.frSort,'UserData',SortData);

handles = RedrawSortMovie(handles,1);
    
for iFrame = firstFrame+1:MAXFRAME
    disp(['Frame ' num2str(iFrame)])
    disp('Getting data')
    length(FrameData)
    sp_seg = FrameData(iFrame).Sp;
    sptimes = FrameData(iFrame).SpTimes;
    if length(sptimes)
        SortData(iFrame).Clu(:,1) = sptimes;
        SortData(iFrame).Iso(1:NClus) = 1;
        SortData(iFrame).TempInclude = ones(size(sptimes,1),1);
        SortData(iFrame).RemCell=zeros(1,14);
        SortData(iFrame).RemIso=SortData(iFrame).RemCell;
        if(length(sptimes)>10)
            disp('Getting pcs')
            [U_seg,pc] = spikepcs([sptimes sp_seg],pcold);
            U_old = FrameData(iFrame-1).Sp*pcold;
            U_new = FrameData(iFrame-1).Sp*pc;
            disp('Getting mean waveform projs');
            for c = 1:NClus
                ind = post(:,c)>0;
                c_old(c,:) = mean(U_old(ind,1:NDim));
                c_new(c,:) = mean(U_new(ind,1:NDim));
            end
            %whos c_new c_old
            %disp('getting distances')
            disp('Dist statement')
            dmat = zeros(NClus,NClus);
            for ki = 1:NClus
                for kj = 1:NClus
                    dmat(ki,kj)=sum((c_new(ki,:)-c_old(kj,:)).^2).^0.5;
                end
            end
            %dmat = dist(c_new,c_old');
            for c = 1:NClus
                [a,cind(c)] = min(dmat(c,:));
            end
            %whos dmat cind
            %disp('Transforming pcs')
            if NClus>2
                if cind(1)~=1 || cind(2)~=2 || cind(3)~=3
                    pc(:,2) = -pc(:,2); U_seg(:,2) = -U_seg(:,2);
                end
            elseif NClus==2
                if cind(1)~=1 || cind(2)~=2
                    pc(:,2) = -pc(:,2); U_seg(:,2) = -U_seg(:,2);
                end
            end
            
            %disp('Saving U_seg')
            U_seg = U_seg(:,1:NDim);
            SortData(iFrame).U = U_seg;
            
            %disp('Do sort')
            ocentres = centres;
            if size(U_seg,1) > NClus
                [centres,options,post] = kmeans(U_seg,NClus);
            end
            [dum,cind] = sort(sqrt(sum(centres'.^2)));
            newpost = zeros(size(post));
            for c = 1:NClus
                ind = post(:,cind(c))>0;
                newpost(ind,c) = 1;
            end
            post = newpost;
            %disp('Assigning cluster ids')
            for c = 1:NClus
                ind = find(post(:,c));
                if ~isempty(ind)
                    SortData(iFrame).Clu(ind,2) = c;
                    SortData(iFrame).Waveform(c,:) = ...
                        mean(FrameData(iFrame).Sp(ind,:));
                end
            end
            %disp('Save sort')
        else
            SortData(iFrame).Clu = [];
        SortData(iFrame).Iso(1:NClus) = 0;
        SortData(iFrame).TempInclude = ones(size(sptimes,1),1);
        SortData(iFrame).RemCell=zeros(1,14);
        SortData(iFrame).RemIso=SortData(iFrame).RemCell;
        end
        set(handles.frSort,'UserData',SortData);
        RedrawSortMovie(handles,iFrame);
    end
end

% --------------------------------------------------------------------
function varargout = pbResort_Callback(h, eventdata, handles, varargin)

global MAXFRAME

disp('Inside pbResort');
NDim = get(handles.popNDim,'Value');
NClus = get(handles.popNClus,'Value');
FrameData = get(handles.frMovie,'UserData');
SortData = get(handles.frSort,'UserData');

FrameString = get(handles.stFrame,'String');
FrameNumber = str2double(FrameString(7:end));
IncCells=[];
for c=1:NClus
    if ~SortData(FrameNumber).RemCell(c)
        IncCells=[IncCells c];
    end
end
IncCells;
NClus=length(IncCells);

IncSpikes=find(FrameData(FrameNumber).TempInclude);
U_seg = FrameData(FrameNumber).U(:,1:NDim);
U_seg = U_seg(IncSpikes,:);
SortData(FrameNumber).NDim = NDim;

%U_seg(1:50,:)

[centres,options,post] = kmeans(U_seg,NClus);
[dum,cind] = sort(sqrt(sum(centres'.^2)));
centres = centres(cind,:);
options(14)=1;
[centres,options,post] = kmeans(U_seg,NClus,centres,options);

for c = 1:NClus
    ind = find(post(:,c));
    %disp(['found ind for c: ' num2str(c)])
    if ~isempty(ind)
        SortData(FrameNumber).Clu(IncSpikes(ind),2) = IncCells(c);
        SortData(FrameNumber).Waveform(IncCells(c),:) = ...
            mean(FrameData(FrameNumber).Sp(IncSpikes(ind),:));
        eval(['hh = handles.ck' num2str(IncCells(c)) ';']);
        set(hh,'Value',1);
    end
end
SortData(FrameNumber).Iso(1:NClus) = 1;
set(handles.frSort,'UserData',SortData);

handles = RedrawSortMovie(handles,FrameNumber);
    

% --------------------------------------------------------------------
function varargout = pbTrackBackwards_Callback(h, eventdata, handles, varargin)

global MAXFRAME

disp('Inside pbTrackBackwards');

FrameData = get(handles.frMovie,'UserData');
SortData = get(handles.frSort,'UserData');
FrameString = get(handles.stFrame,'String');
FrameNumber = str2double(FrameString(7:end));

if FrameNumber==1 
    disp('At beginning of movie:  Cannot track backwards');
    return
end

% Current frame information
Center = zeros(14,size(SortData(1).Waveform,2));
ID = zeros(1,14);
for c = 1:14
    ind = find(SortData(FrameNumber).Clu(:,2) == c);
    if ~isempty(ind)
        ID(c) = 1;
        Center(c,:) = mean(FrameData(FrameNumber).Sp(ind,:));
    end
end

% Previous frame information
BackCenter = zeros(14,size(SortData(1).Waveform,2));
BackID = zeros(1,14);
for c = 1:14
    ind = find(SortData(FrameNumber-1).Clu(:,2) == c);
    if ~isempty(ind)
        BackID(c) = 1;
        BackCenter(c,:) = mean(FrameData(FrameNumber-1).Sp(ind,:));
    end
end

newID = zeros(1,14);
for Backc = 1:14
%     disp(['Back cluster ' num2str(Backc)]);
    dd = zeros(1,14);
    if BackID(Backc)
        for c = 1:14
            if ID(c)
                dd(c) = sum((Center(c,:)-BackCenter(Backc,:)).^2).^0.5;
            end
        end
        IDs = find(ID);
        [dum,n] = min(dd(IDs));
        newID(Backc) = IDs(n);
    end
end

%  Reassign elements
for c = 1:14
    ind = find(SortData(FrameNumber-1).Clu(:,2) == c);
    if ~isempty(ind)
        SortData(FrameNumber-1).Clu(ind,2) = newID(c);
    end
end    

SortData(FrameNumber-1).Iso = zeros(1,14);
for c = 1:14
    ind = find(SortData(FrameNumber-1).Clu(:,2) == c);
    length(ind)
    if ~isempty(ind)
        SortData(FrameNumber-1).Waveform(c,:) = ...
            mean(FrameData(FrameNumber-1).Sp(ind,:));
        SortData(FrameNumber-1).Iso(c) = 1;
    end
end

set(handles.frSort,'UserData',SortData);

handles = RedrawSortMovie(handles,FrameNumber-1);


% --------------------------------------------------------------------
function varargout = pbTrackForwards_Callback(h, eventdata, handles, varargin)

global MAXFRAME

disp('Inside pbTrackForwards');

FrameData = get(handles.frMovie,'UserData');
SortData = get(handles.frSort,'UserData');
FrameString = get(handles.stFrame,'String');
FrameNumber = str2double(FrameString(7:end));

if FrameNumber==MAXFRAME 
    disp('At end of movie:  Cannot track forwards');
    return
end

% Current frame information
Center = zeros(14,size(SortData(1).Waveform,2));
ID = zeros(1,14);
for c = 1:14
    ind = find(SortData(FrameNumber).Clu(:,2) == c);
    if ~isempty(ind)
        ID(c) = 1;
        Center(c,:) = mean(FrameData(FrameNumber).Sp(ind,:));
    end
end

% Forward frame information
BackCenter = zeros(14,size(SortData(1).Waveform,2));
BackID = zeros(1,14);
for c = 1:14
    ind = find(SortData(FrameNumber+1).Clu(:,2) == c);
    if ~isempty(ind)
        BackID(c) = 1;
        BackCenter(c,:) = mean(FrameData(FrameNumber+1).Sp(ind,:));
    end
end

newID = zeros(1,14);
for Backc = 1:14
%     disp(['Back cluster ' num2str(Backc)]);
    dd = zeros(1,14);
    if BackID(Backc)
        for c = 1:14
            if ID(c)
                dd(c) = sum((Center(c,:)-BackCenter(Backc,:)).^2).^0.5;
            end
        end
        IDs = find(ID);
        [dum,n] = min(dd(IDs));
        newID(Backc) = IDs(n);
    end
end

%  Reassign elements
for c = 1:14
    ind = find(SortData(FrameNumber+1).Clu(:,2) == c);
    if ~isempty(ind)
        SortData(FrameNumber+1).Clu(ind,2) = newID(c);
    end
end    

SortData(FrameNumber+1).Iso = zeros(1,14);
for c = 1:14
    ind = find(SortData(FrameNumber+1).Clu(:,2) == c);
    length(ind)
    if ~isempty(ind)
        SortData(FrameNumber+1).Waveform(c,:) = ...
            mean(FrameData(FrameNumber+1).Sp(ind,:));
        SortData(FrameNumber+1).Iso(c) = 1;
    end
end

set(handles.frSort,'UserData',SortData);

handles = RedrawSortMovie(handles,FrameNumber+1);

% global MAXFRAME
% 
% disp('Inside pbTrackForwards');
% 
% FrameData = get(handles.frMovie,'UserData');
% SortData = get(handles.frSort,'UserData');
% FrameString = get(handles.stFrame,'String');
% FrameNumber = str2double(FrameString(7:end));
% 
% if FrameNumber==MAXFRAME
%     disp('At end of movie:  Cannot track forwards');
%     return
% end
% 
% disp('Current frame information')
% Center = zeros(14,length(SortData(1).Waveform(1,:)));
% ID = zeros(1,14);
% for c = 1:14
%     ind = find(SortData(FrameNumber).Clu(:,2) == c);
%     if length(ind)
%         ID(c) = 1;
%         Center(c,:) = mean(FrameData(FrameNumber).Sp(ind,:));
%     end
% end
% 
% disp('Forward frame information')
% ForwardCenter = zeros(14,size(SortData(1).Waveform,2));
% ForwardID = zeros(1,14);
% for c = 1:14
%     ind = find(SortData(FrameNumber+1).Clu(:,2) == c);
%     if length(ind)
%         ForwardID(c) = 1;
%         ForwardCenter(c,:) = mean(FrameData(FrameNumber+1).Sp(ind,:));
%     end
% end
% 
% newID = zeros(1,14);
% for Forwardc = 1:14
%     dd = zeros(1,14);
%     if ForwardID(Forwardc)
%         for c = 1:14
%             if ID(c)
%                 dd(c) = sum((Center(c,:)-ForwardCenter(Forwardc,:)).^2).^0.5;
%             end
%         end
%         IDs = find(ID);
%         [dum,n] = min(dd(IDs));
%         newID(Forwardc) = IDs(n);
%     end
% end
% 
% disp('Reassign elements')
% for c = 1:14
%     ind = find(SortData(FrameNumber+1).Clu(:,2) == c);
%     if length(ind)
%         SortData(FrameNumber+1).Clu(ind,2) = newID(c);
%     end
% end
% 
% SortData(FrameNumber-1).Iso = zeros(1,14);
% for c = 1:14
%     ind = find(SortData(FrameNumber+1).Clu(:,2) == c);
%     length(ind)
%     if length(ind)
%         SortData(FrameNumber+1).Waveform(c,:) = ...
%             mean(FrameData(FrameNumber+1).Sp(ind,:));
%         SortData(FrameNumber+1).Iso(c) = 1;
%     end
% end
% 
% set(handles.frSort,'UserData',SortData);
% 
% handles = RedrawSortMovie(handles,FrameNumber+1);


% --------------------------------------------------------------------
function varargout = pbBackSort_Callback(h, eventdata, handles, varargin)

FrameString = get(handles.stFrame,'String');
FrameNumber = str2double(FrameString(7:end));
if FrameNumber > 1
    disp(['Back sort movie from ' num2str(FrameNumber) ' to ' ...
            num2str(FrameNumber-1)]);
    FrameNumber = FrameNumber-1;
    % deactivate threshold override, as threshold should change frame to
    % frame
    set(handles.thresholdOverride,'Value',0);
    set(handles.thresholdSlider,'Enable','off');
    RedrawSortMovie(handles,FrameNumber);
else
    disp('At beginning of movie')
end

% --------------------------------------------------------------------
function varargout = pbForwardSort_Callback(h, eventdata, handles, varargin)

global MAXFRAME

FrameString = get(handles.stFrame,'String');
FrameNumber = str2double(FrameString(7:end));
if FrameNumber < MAXFRAME
    disp(['Forward sort movie from ' num2str(FrameNumber) ' to ' ...
            num2str(FrameNumber+1)]);
    FrameNumber = FrameNumber+1;
    % deactivate threshold override, as threshold should change frame to
    % frame
    set(handles.thresholdOverride,'Value',0);
    set(handles.thresholdSlider,'Enable','off');
    RedrawSortMovie(handles,FrameNumber);
else
    disp('At end of movie');
end

% --------------------------------------------------------------------
function varargout = popNClus_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = popNDim_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pbReassign_Callback(h, eventdata, handles, varargin)

disp('Reassign callback');
SortData = get(handles.frSort,'UserData');
FrameData = get(handles.frMovie,'UserData');
FrameString = get(handles.stFrame,'String');
FrameNumber = str2double(FrameString(7:end));

for i = 1:14
    eval(['a = handles.ck' num2str(i) ';']);
    ck(i) = get(a,'Value');
    if SortData(FrameNumber).RemCell(i)
        if ~isfield(SortData,'RemIso')
            for iFr=1:length(SortData)
                SortData(iFr).RemIso=ones(1,14);
            end
        end
        ck(i)=SortData(FrameNumber).RemIso(i);
        set(a,'Value',ck(i));
    end
end

SortData(FrameNumber).Iso = ck;

for iCl = 1:14
    ind{iCl} = find(SortData(FrameNumber).Clu(:,2)==iCl);
end

for iCl = 1:14
    if SortData(FrameNumber).Iso(iCl)
        eval(['hh = handles.pop' num2str(iCl) ';']);
        newCl = get(hh,'Value');
        disp(['Replacing ' num2str(iCl) ' with ' num2str(newCl)])
        SortData(FrameNumber).Clu(ind{iCl},2)=newCl;
    else
        SortData(FrameNumber).Clu(ind{iCl},2)=1;
    end
end


for iCl = 1:14
    ind = find(SortData(FrameNumber).Clu(:,2)==iCl);
    if ~isempty(ind)
        SortData(FrameNumber).Waveform(iCl,:) = ...
            mean(FrameData(FrameNumber).Sp(ind,:));
        SortData(FrameNumber).Iso(iCl)=1;
    else
        SortData(FrameNumber).Waveform(iCl,:) = ...
            zeros(1,size(SortData(1).Waveform,2));
        SortData(FrameNumber).Iso(iCl)=0;
    end;
end

set(handles.frSort,'UserData',SortData);
RedrawSortMovie(handles,FrameNumber);

% --------------------------------------------------------------------
function varargout = pbReassignAll_Callback(h, eventdata, handles, varargin)

% disp('Reassigning all frames')
% SortData = get(handles.frSort,'UserData');
% FrameData = get(handles.frMovie,'UserData');
% 
% for i = 1:14
%     eval(['a = handles.ck' num2str(i) ';']);
%     ck(i) = get(a,'Value');
% end
% 
% for FrameNumber = 1:length(SortData)
%     SortData(FrameNumber).Iso = ck;
% 
%     for iCl = 1:14
%         ind{iCl} = find(SortData(FrameNumber).Clu(:,2)==iCl);
%     end
%     
%     for iCl = 1:14
%         if SortData(FrameNumber).Iso(iCl)
%             eval(['hh = handles.pop' num2str(iCl) ';']);
%             newCl = get(hh,'Value');
%             disp(['Replacing ' num2str(iCl) ' with ' num2str(newCl)])
%             SortData(FrameNumber).Clu(ind{iCl},2)=newCl;
%         else
%             SortData(FrameNumber).Clu(ind{iCl},2)=1;
%         end
%     end
%     
%     for iCl = 1:14
%         ind = find(SortData(FrameNumber).Clu(:,2)==iCl);
%         if length(ind)
%             SortData(FrameNumber).Waveform(iCl,:) = ...
%                 mean(FrameData(FrameNumber).Sp(ind,:));
%         else
%             SortData(FrameNumber).Waveform(iCl,:) = ...
%                 zeros(1,size(SortData(FrameNumber).Waveform,2));
%         end;
%     end
% 
%     set(handles.frSort,'UserData',SortData);
%     
%     RedrawSortMovie(handles,FrameNumber);
% end

% --------------------------------------------------------------------
function varargout = pbSaveAll_Callback(h, eventdata, handles, varargin)

global MONKEYDIR experiment

disp('Exporting sort data')

[day,rec,mt,ch,contact] = RecInformation(handles);
load([MONKEYDIR '/' day '/' rec '/rec' rec '.Rec.mat']);
IsoWin = str2double(get(handles.edIsoWin,'String'));

if exist([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat'],'file')
    load([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat']);
end

if exist('experiment')
    mtch = expChannelIndex(experiment,mt,ch,contact);
    Fs = experiment.hardware.acquisition(1).samplingrate;
else
    mtch = ch;
    Fs = Rec.Fs;
end


SortData = get(handles.frSort,'UserData');

Iqual(1)=str2double(get(handles.edIsoQual1,'String'));
Iqual(2)=str2double(get(handles.edIsoQual2,'String'));
Iqual(3)=str2double(get(handles.edIsoQual3,'String'));
Iqual(4)=str2double(get(handles.edIsoQual4,'String'));
Iqual(5)=str2double(get(handles.edIsoQual5,'String'));
Iqual(6)=str2double(get(handles.edIsoQual6,'String'));
Iqual(7)=str2double(get(handles.edIsoQual7,'String'));
Iqual(8)=str2double(get(handles.edIsoQual8,'String'));
Iqual(9)=str2double(get(handles.edIsoQual9,'String'));
Iqual(10)=str2double(get(handles.edIsoQual10,'String'));
Iqual(11)=str2double(get(handles.edIsoQual11,'String'));
Iqual(12)=str2double(get(handles.edIsoQual12,'String'));
Iqual(13)=str2double(get(handles.edIsoQual13,'String'));
Iqual(14)=str2double(get(handles.edIsoQual14,'String'));

SortData(1).IsoQual=Iqual;

disp('Looping over frames');
recDuration = calcRecDuration(day, rec);
nRecFrames = ceil(recDuration./2./IsoWin./Fs);
Clu = []; Iso = zeros(nRecFrames,14);
whos Iso
for iFrame = 1:length(SortData);
    nIso(iFrame) = length(SortData(iFrame).Iso);
end
mIso = max(nIso);
for iFrame = 1:length(SortData);
    if nIso(iFrame)<mIso
        SortData(iFrame).Iso(nIso(iFrame)+1:mIso)= 0;
    end
end
% totaldepth=zeros(1,14);
% ntrials=totaldepth;
for iFrame = 1:length(SortData);
    FrClu = SortData(iFrame).Clu;
    Clu = [Clu;FrClu];
    FrIso = SortData(iFrame).Iso;
    Iso(iFrame,:) = FrIso;
%     ntrials = ntrials + FrIso*SortData(iFrame).nTrials;
%     totaldepth = totaldepth + FrIso*SortData(iFrame).nTrials*SortData(iFrame).Depth;
end
% ntrials(find(ntrials==0))=1;
% SortData(1).AvgDepth=totaldepth./ntrials;

disp('Saving data to disk');
[MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.clu.mat']
if isfile([MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.clu.mat'])
    load([MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.clu.mat'],'clu');
    load([MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.iso.mat'],'iso');
    clu{mtch} = Clu; iso{mtch} = Iso;
    save([MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.clu.mat'],'clu');
    save([MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.iso.mat'],'iso');
else
    clu = cell(1,2); clu{mtch} = Clu;
    iso = cell(1,2); iso{mtch} = Iso;
    save([MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.clu.mat'],'clu');
    save([MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.iso.mat'],'iso');
end

MovieData = get(handles.frMovie,'UserData');
filename = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.' num2str(mtch) ...
        '.MovieData.mat'];
save(filename,'MovieData');

SortData = get(handles.frSort,'UserData');
filename = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.' num2str(mtch) ...
        '.SortData.mat'];
%SortData=rmfield(SortData,'TempInclude');
save(filename,'SortData');
disp('Done saving data')

% --------------------------------------------------------------------
function varargout = pbSave_Callback(h, eventdata, handles, varargin)

global MONKEYDIR

disp('Exporting sort data')
[day,rec,mt,ch,contact] = RecInformation(handles);
IsoWin = str2double(get(handles.edIsoWin,'String'));

load([MONKEYDIR '/' day '/' rec '/rec' rec '.Rec.mat']);
if exist([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat'],'file')
    load([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat']);
end
if exist('experiment')
    mtch = expChannelIndex(experiment,mt,ch,contact);
    Fs = experiment.hardware.acquisition(1).samplingrate;
else
    mtch = ch;
    Fs = Rec.Fs;
end

SortData = get(handles.frSort,'UserData');
disp('Looping over frames');
recDuration = calcRecDuration(day, rec);
nRecFrame = ceil(recDuration./2./IsoWin./Fs);
Clu = []; Iso = zeros(nRecFrame,14);
for iFrame = 1:length(SortData);
    nIso(iFrame) = length(SortData(iFrame).Iso);
end
mIso = max(nIso);
for iFrame = 1:length(SortData);
    if nIso(iFrame)<mIso
        SortData(iFrame).Iso(nIso(iFrame)+1:mIso)= 0;
    end
end
for iFrame = 1:length(SortData);
    FrClu = SortData(iFrame).Clu;
    Clu = [Clu;FrClu];
    FrIso = SortData(iFrame).Iso;
    Iso(iFrame,:) = FrIso;
end

disp('Saving data to disk');
if isfile([MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.clu.mat'])
    disp('Clu already exists');
    load([MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.clu.mat'],'clu');
    load([MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.iso.mat'],'iso');
    clu{mtch} = Clu; iso{mtch} = Iso;
    save([MONKEYDIR '/' day '/' rec '/rec' rec  '.' mt '.clu.mat'],'clu');
    save([MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.iso.mat'],'iso');
    
else
    disp('Clu does not already exist - Please create');
    
end

disp('Done saving data')

% --------------------------------------------------------------------
function varargout = popChannel_Callback(h, eventdata, handles, varargin)

global MONKEYDIR

[day,rec,mt,ch] = RecInformation(handles);
contact = 1;
%load([MONKEYDIR '/' day '/' rec '/rec' rec '.Rec.mat']);
if exist([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat'],'file')
    load([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat']);
end

disp(['Update Contact list for ' day]);
ContactString = {};
if isfield(experiment.hardware,'microdrive')
    if isfield(experiment.hardware.microdrive(1).electrodes(ch), 'numContacts')
        nContacts = experiment.hardware.microdrive(1).electrodes(ch).numContacts;
    else
        nContacts = 1;
    end
    for i = 1:nContacts
        ContactString{i} = num2str(i);
    end
else
    ContactString{1} = '';
end
set(handles.popContact,'String',ContactString);
set(handles.popContact,'Value',contact);
mtch = ch;
if exist('experiment')
  if isfield(experiment,'hardware')
    if isfield(experiment.hardware,'microdrive')
      mtch = expChannelIndex(experiment,mt,ch,contact);
    end
  end
end

MovieDataFile = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.' num2str(mtch) ...
        '.MovieData.mat'];
SortDataFile = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.' num2str(mtch) ...
        '.SortData.mat'];

if isfile(SortDataFile)
    set(handles.pbLoadSort,'Visible','on');
else
    set(handles.pbLoadSort,'Visible','off');
end
    

if isfile(MovieDataFile)
    set(handles.pbLoadMovie,'Visible','on');
else
    set(handles.pbLoadMovie,'Visible','off');
end


% % --------------------------------------------------------------------
% function varargout = popCompareCh_Callback(h, eventdata, handles, varargin)
% 
% global MONKEYDIR
% 
% [day,rec,systring,ch] = RecInformation(handles);
% 
% SortDataFile = [MONKEYDIR '/' day '/' rec '/rec' rec systring ...
%         '.SortData' num2str(ch) '.mat'];
% 
% if isfile(SortDataFile)
%     set(handles.pbPlotWaveforms,'Visible','on');
% else
%     set(handles.pbPlotWaveforms,'Visible','off');
% end
%     
% --------------------------------------------------------------------
function varargout = popMT_Callback(h, eventdata, handles, varargin)

global MONKEYDIR experiment

[day,rec,mt,channel,contact] = RecInformation(handles);
%
MTValue = get(handles.popMT,'Value');
if exist([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat'],'file')
    load([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat']);
    disp(['Update Channel list for ' day]);
        ChannelString = {};
        if isfield(experiment.hardware,'microdrive')
            for i = 1:length(experiment.hardware.microdrive(1).electrodes)
                if(~isempty(experiment.hardware.microdrive(1).electrodes(i).label))
                    ChannelString{end+1} = num2str(i);
                end
            end
        else
            ChannelString{1} = '';
        end
else
    load([MONKEYDIR '/' day '/' rec '/rec' rec '.Rec.mat']);
    if isfield(Rec,'Ch')  && ~isempty(Rec.Ch)
        for iCh = 1:Rec.Ch(1)
            ChannelString{iCh} = num2str(iCh);
        end
    else
        ChannelString{1} = '';
    end
end
set(handles.popChannel,'String',ChannelString);

disp(['Update Contact list for ' day]);
ContactString = {};%  ch = 1; contact = 1;
if isfield(experiment.hardware,'microdrive')
    if isfield(experiment.hardware.microdrive(1).electrodes(channel), 'numContacts')
        nContacts = experiment.hardware.microdrive(1).electrodes(channel).numContacts;
    else
        nContacts = 1;
    end
    for i = 1:nContacts
        ContactString{i} = num2str(i);
    end
else
    ContactString{1} = '';
end
set(handles.popContact,'String',ContactString);
set(handles.popContact,'Value',contact);
mtch = channel;
if exist('experiment','var')
    if isfield(experiment,'hardware')
        if isfield(experiment.hardware,'microdrive');
            mtch = expChannelIndex(experiment,mt,channel,contact);
        end
    end
end
MovieDataFile = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.' num2str(mtch)...
        '.MovieData.mat'];
SortDataFile = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.' num2str(mtch) ...
        '.SortData.mat'];

if isfile(SortDataFile)
    set(handles.pbLoadSort,'Visible','on');
else
    set(handles.pbLoadSort,'Visible','off');
end

if isfile(MovieDataFile)
    set(handles.pbLoadMovie,'Visible','on');
else
    set(handles.pbLoadMovie,'Visible','off');
end
% 
% % --------------------------------------------------------------------
% function varargout = popCompareSys_Callback(h, eventdata, handles, varargin)
% 
% global MONKEYDIR
% 
% [day,rec,systring,ch] = RecInformation(handles);
% 
% SortDataFile = [MONKEYDIR '/' day '/' rec '/rec' rec systring ...
%         '.SortData' num2str(ch) '.mat'];
% 
% if isfile(SortDataFile)
%     set(handles.pbLoadSort,'Visible','on');
% else
%     set(handles.pbLoadSort,'Visible','off');
% end

% --------------------------------------------------------------------
function varargout = popRec_Callback(h, eventdata, handles, varargin)

disp('Entering popRec Callback')
global MONKEYDIR experiment

[day,rec,mt,ch,contact] = RecInformation(handles);
%load([MONKEYDIR '/' day '/' rec '/rec' rec '.Rec.mat']);
if exist([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat'],'file')
    load([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat']);
end

disp(['Update Contact list for ' day]);
ContactString = {};%  ch = 1; contact = 1;
if isfield(experiment.hardware,'microdrive')
    if isfield(experiment.hardware.microdrive(1).electrodes(ch), 'numContacts')
        nContacts = experiment.hardware.microdrive(1).electrodes(ch).numContacts;
    else
        nContacts = 1;
    end
    for i = 1:nContacts
        ContactString{i} = num2str(i);
    end
else
    ContactString{1} = '';
end
set(handles.popContact,'String',ContactString);
set(handles.popContact,'Value',contact);
mtch = ch;
if exist('experiment','var')
    if isfield(experiment,'hardware')
        if isfield(experiment.hardware,'microdrive');
            mtch = expChannelIndex(experiment,mt,ch,contact);
        end
    end
end

MovieDataFile = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.' num2str(mtch)...
        '.MovieData.mat'];
SortDataFile = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.' num2str(mtch) ...
        '.SortData.mat'];
    
if isfile(SortDataFile)
    set(handles.pbLoadSort,'Visible','on');
else
    set(handles.pbLoadSort,'Visible','off');
end

if isfile(MovieDataFile)
    set(handles.pbLoadMovie,'Visible','on');
else
    set(handles.pbLoadMovie,'Visible','off');
end
disp('Leaving popRec Callback')
% 
% % --------------------------------------------------------------------
% function varargout = popCompareRec_Callback(h, eventdata, handles, varargin)
% 
% global MONKEYDIR
% 
% [day,rec,systring,ch] = RecInformation(handles);
% 
% SortDataFile = [MONKEYDIR '/' day '/' rec '/rec' rec systring ...
%         '.SortData' num2str(ch) '.mat'];
% 
% if isfile(SortDataFile)
%     set(handles.pbPlotWaveforms,'Visible','on');
% else
%     set(handles.pbPlotWaveforms,'Visible','off');
% end


% --------------------------------------------------------------------
function varargout = popDay_Callback(h, eventdata, handles, varargin)

day = get(h,'String');
% DayValue = get(h,'Value');
% day = DayString{DayValue};
set(handles.popRec,'Value',1);
UpdateDay(handles,day);


% --------------------------------------------------------------------
function UpdateDay(handles,day)
%
%
%

global MONKEYDIR

disp(['Update Recording list for ' day]);
recs = dayrecs(day);
if ~isempty(recs);
    set(handles.popRec,'String',recs);

    rec = recs{1};
    disp(['Update System list for ' day]);
    %load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.Rec.mat']);
    if(isfile([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat']))
        load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat']);
        if isfield(experiment.hardware,'microdrive')
            MTString = cell(1,length(experiment.hardware.microdrive));
            for i = 1:length(MTString)
                MTString{i} = experiment.hardware.microdrive(i).name;
            end
        else
            MTString{1} = '';
        end
        set(handles.popMT,'String',MTString);
        % Some rigs (ok let's face it only rig 2) may have electrodes with
        % nonconsecutive numbering so need to check which electrodes exist
        disp(['Update Channel list for ' day]);
        ChannelString = {};
        if isfield(experiment.hardware,'microdrive')
            for i = 1:length(experiment.hardware.microdrive(1).electrodes)
                if(~isempty(experiment.hardware.microdrive(1).electrodes(i).label))
                    ChannelString{end+1} = num2str(i);
                end
            end
        else
            ChannelString{1} = '';
        end
        set(handles.popChannel,'String',ChannelString);
        ch = get(handles.popChannel,'Value');

        disp(['Update Contact list for ' day]);
        ContactString = {};
        if isfield(experiment.hardware,'microdrive')
            if isfield(experiment.hardware.microdrive(1).electrodes(ch), 'numContacts')
                nContacts = experiment.hardware.microdrive(1).electrodes(ch).numContacts;
            else
                nContacts = 1;
            end
            for i = 1:nContacts
                ContactString{i} = num2str(i);
            end
        else
            ContactString{1} = '';
        end
        set(handles.popContact,'String',ContactString);
        day = get(handles.popDay,'String');
        RecString = get(handles.popRec,'String');
        RecValue = get(handles.popRec,'Value');
        rec = RecString{RecValue};
        MTString = get(handles.popMT,'String');
        MTValue = get(handles.popMT,'Value');
        mt = MTString{MTValue};
        
        contact = get(handles.popContact,'Value');
        
        load([MONKEYDIR '/' day '/' rec '/rec' rec '.Rec.mat']);
        if exist('experiment','var')
            if isfield(experiment,'hardware')
                if isfield(experiment.hardware,'microdrive')
                    mtch = expChannelIndex(experiment,mt,ch,contact);
                else
                    mtch = ch;
                end
            else
                mtch = ch;
            end
        else
            mtch = ch;
        end
        mtch
    MovieDataFile = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.' num2str(mtch)...
            '.MovieData.mat'];
    SortDataFile = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.' num2str(mtch) ...
            '.SortData.mat'];

        if isfile(SortDataFile)
            set(handles.pbLoadSort,'Visible','on');
        else
            set(handles.pbLoadSort,'Visible','off');
        end

        if isfile(MovieDataFile)
            set(handles.pbLoadMovie,'Visible','on');
        else
            set(handles.pbLoadMovie,'Visible','off');
        end

        day = get(handles.popDay,'String');
        rec = RecString{RecValue};
        mt = MTString{MTValue};
    else
        disp('No experiment definition file')
        load([MONKEYDIR '/' day '/' rec '/rec' rec '.Rec.mat']);
        MTString = {Rec.MT1,Rec.MT2};
        set(handles.popMT,'String',MTString);
        
        disp(['Update Channel list for ' day]);
        if isfield(Rec,'Ch')  && ~isempty(Rec.Ch)
            for iCh = 1:Rec.Ch(1)
                ChannelString{iCh} = num2str(iCh);
            end
        else
            ChannelString{1} = '';
        end
        set(handles.popChannel,'String',ChannelString);

        ContactString = {};
        ContactString{1} = '1';
        set(handles.popContact,'String',ContactString);

        day = get(handles.popDay,'String');
        RecString = get(handles.popRec,'String');
        RecValue = get(handles.popRec,'Value');
        rec = RecString{RecValue};
        MTString = get(handles.popMT,'String');
        MTValue = get(handles.popMT,'Value');
        mt = MTString{MTValue};

        ch = get(handles.popChannel,'Value');
        contact = get(handles.popContact,'Value');
        
        load([MONKEYDIR '/' day '/' rec '/rec' rec '.Rec.mat']);
        if exist('experiment')
            mtch = expChannelIndex(experiment,mt,ch,contact);
        else
            mtch = ch;
        end
        MovieDataFile = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.' num2str(mtch)...
            '.MovieData.mat'];
        SortDataFile = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.' num2str(mtch) ...
            '.SortData.mat'];

        if isfile(SortDataFile)
            set(handles.pbLoadSort,'Visible','on');
        else
            set(handles.pbLoadSort,'Visible','off');
        end

        if isfile(MovieDataFile)
            set(handles.pbLoadMovie,'Visible','on');
        else
            set(handles.pbLoadMovie,'Visible','off');
        end

        day = get(handles.popDay,'String');
        rec = RecString{RecValue};
        mt = MTString{MTValue};

        
    end
else
end


% --------------------------------------------------------------------
function handles = setFrameTrials(handles, FrameNumber)

disp('In frame trials')
AOTrials = get(handles.frTrials,'UserData');
IsoWin = 1e3*str2double(get(handles.edIsoWin,'String'));

if ~isempty(AOTrials)
    AOStartOn = getAOStartOn(AOTrials);
    Start = (FrameNumber-1)*IsoWin;
    Stop = FrameNumber*IsoWin;
    
    ind = find(AOStartOn>Start & AOStartOn<Stop);
    set(handles.stFrTrials,'String',length(ind));
    if ~isempty(ind)
%         set(handles.stSFrTrials,'String',num2str(length(TaskTrials(Trials(ind),'Sacc'))));
%         set(handles.stLRFrTrials,'String',num2str(length(TaskTrials(Trials(ind),'LR1T'))));
%         set(handles.stRFrTrials,'String',num2str(length(TaskTrials(Trials(ind),'Fix1T'))));
%         set(handles.stSRFFrTrials,'String',num2str(length(TaskTrials(Trials(ind),'SaccRF'))));
%         set(handles.stLRRFFrTrials,'String',num2str(length(TaskTrials(Trials(ind),'LRRF'))));
%         set(handles.stRRFFrTrials,'String',num2str(length(TaskTrials(Trials(ind),'ReachRF'))));
%         set(handles.st3TFrTrials,'String',num2str(length(TaskTrials(Trials(ind),'Free3T'))));
%         set(handles.stISFrTrials,'String',num2str(length(TaskTrials(Trials(ind),'IntSacc'))));
        
        %Electrode depths
        %disp('plotting electrode depth')
        %ChString = get(handles.edChannel,'String');
        %ChValue = get(handles.edChannel,'Value');
        %ch = str2double(ChString{ChValue});
        
        %Depth=get(handles.frDepth,'UserData');
        %tempDepth=zeros(length(ind),1);
        %for iTrial=1:length(ind)
        %    tempDepth(iTrial)=-Trials(ind(iTrial)).Depth(ch);
        %end
        %axes(handles.axDepth)
        %plot(tempDepth)
        %axis([0 length(ind)+1 Depth.gmax Depth.gmin])      
        
    else
%         set(handles.stFrTrials,'String','0');
%         set(handles.stSFrTrials,'String','0');
%         set(handles.stLRFrTrials,'String','0');
%         set(handles.stRFrTrials,'String','0');
%         set(handles.stSRFFrTrials,'String','0');
%         set(handles.stLRRFFrTrials,'String','0');
%         set(handles.stRRFFrTrials,'String','0');
%         set(handles.st3TFrTrials,'String','0');
%         set(handles.stISFrTrials,'String','0');
    end
else
%     set(handles.stFrTrials,'String','0');
%     set(handles.stSFrTrials,'String','0');
%     set(handles.stLRFrTrials,'String','0');
%     set(handles.stRFrTrials,'String','0');
%     set(handles.stSRFFrTrials,'String','0');
%     set(handles.stLRRFFrTrials,'String','0');
%     set(handles.stRRFFrTrials,'String','0');
%     set(handles.st3TFrTrials,'String','0');
%     set(handles.stISFrTrials,'String','0');
end
% --------------------------------------------------------------------
function varargout = pbPauseMovie_Callback(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = edIsoWin_Callback(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = pbLoadMovie_Callback(h, eventdata, handles, varargin)

global MONKEYDIR MAXFRAME

disp('Loading movie data')
[day,rec,mt,ch,contact] = RecInformation(handles);
load([MONKEYDIR '/' day '/' rec '/rec' rec '.Rec.mat'])
if exist('experiment')
    mtch = expChannelIndex(experiment,mt,ch,contact);
else
    mtch = ch;
end
filename = [MONKEYDIR '/' day '/' rec '/rec' rec '.'  mt '.' num2str(mtch) '.MovieData.mat'];
load(filename);
MAXFRAME = length(MovieData);
if ~isfield(MovieData,'TempInclude')
    [Utmp,PC,eigvalues]=spikepcs(MovieData(1).Sp);
    MovieData(1).EigFrac=(eigvalues.^2)/sum(eigvalues.^2);
    MovieData(1).TempInclude = ones(size(MovieData(1).U,1),1);
    MovieData(1).PC = PC;
    for iFrame=2:MAXFRAME
        [Utmp,PC,eigvalues]=spikepcs(MovieData(iFrame).Sp,PC);
        MovieData(iFrame).EigFrac=(eigvalues.^2)/sum(eigvalues.^2);
        MovieData(iFrame).TempInclude = ones(size(MovieData(iFrame).U,1),1);
        MovieData(iFrame).PC = PC;
    end
end
set(handles.frMovie,'UserData',MovieData);
%         
AOTrials = dbAOSelectTrials(day,rec);
if ~isempty(AOTrials)
     set(handles.frTrials,'UserData',AOTrials);
     set(handles.stRecTrials,'String',num2str(length(AOTrials)));
%     set(handles.stSTrials,'String',num2str(length(TaskTrials(Trials,'Sacc'))));
%     set(handles.stLRTrials,'String',num2str(length(TaskTrials(Trials,'LR1T'))));
%     set(handles.stRTrials,'String',num2str(length(TaskTrials(Trials,'Fix1T'))));
%     set(handles.stSRFTrials,'String',num2str(length(TaskTrials(Trials,'SaccRF'))));
%     set(handles.stLRRFTrials,'String',num2str(length(TaskTrials(Trials,'LRRF'))));
%     set(handles.stRRFTrials,'String',num2str(length(TaskTrials(Trials,'ReachRF'))));
%     set(handles.st3TTrials,'String',num2str(length(TaskTrials(Trials,'Free3T'))));
%     set(handles.stISTrials,'String',num2str(length(TaskTrials(Trials,'IntSacc'))));
else
     set(handles.stRecTrials,'String','0');
%     set(handles.stSTrials,'String','0');
%     set(handles.stLRTrials,'String','0');
%     set(handles.stRTrials,'String','0');
%     set(handles.stSRFTrials,'String','0');
%     set(handles.stLRRFTrials,'String','0');
%     set(handles.stRRFTrials,'String','0');
%     set(handles.st3TTrials,'String','0');
%     set(handles.stISTrials,'String','0');
%     set(handles.stFrTrials,'String','0');
%     set(handles.stSFrTrials,'String','0');
%     set(handles.stLRFrTrials,'String','0');
%     set(handles.stRFrTrials,'String','0');
%     set(handles.stSRFFrTrials,'String','0');
%     set(handles.stLRRFFrTrials,'String','0');
%     set(handles.stRRFFrTrials,'String','0');
%     set(handles.st3TFrTrials,'String','0');
%     set(handles.stISFrTrials,'String','0');
end


% --------------------------------------------------------------------
function varargout = pbLoadSort_Callback(h, eventdata, handles, varargin)

global MONKEYDIR MAXFRAME

disp('Loading sort data')
[day,rec,mt,ch,contact] = RecInformation(handles);
load([MONKEYDIR '/' day '/' rec '/rec' rec '.Rec.mat'])
if exist('experiment')
    mtch = expChannelIndex(experiment,mt,ch,contact);
else
    mtch = ch;
end
filename = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.' num2str(mtch) '.SortData.mat'];
load(filename);
filename = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.' num2str(mtch) '.MovieData.mat'];
load(filename);

if ~isfield(SortData,'IsoQual')
    SortData(1).IsoQual=zeros(1,14);
end
Iqual=SortData(1).IsoQual
set(handles.edIsoQual1,'String',Iqual(1));
set(handles.edIsoQual2,'String',Iqual(2));
set(handles.edIsoQual3,'String',Iqual(3));
set(handles.edIsoQual4,'String',Iqual(4));
set(handles.edIsoQual5,'String',Iqual(5));
set(handles.edIsoQual6,'String',Iqual(6));
set(handles.edIsoQual7,'String',Iqual(7));
set(handles.edIsoQual8,'String',Iqual(8));
set(handles.edIsoQual9,'String',Iqual(9));
set(handles.edIsoQual10,'String',Iqual(10));
set(handles.edIsoQual11,'String',Iqual(11));
set(handles.edIsoQual12,'String',Iqual(12));
set(handles.edIsoQual13,'String',Iqual(13));
set(handles.edIsoQual14,'String',Iqual(14));

SortData(1).Clu(:,1)=MovieData(1).SpTimes;
MAXFRAME = length(SortData)
SortData
if ~isfield(SortData,'TempInclude')
    for iFrame=1:MAXFRAME
        SortData(iFrame).TempInclude = ones(size(SortData(iFrame).U,1),1);
        SortData(iFrame).RemCell=zeros(1,14);
    end
end
set(handles.frSort,'UserData',SortData);
% 
AOTrials = dbAOSelectTrials(day,rec);
set(handles.frTrials,'UserData',AOTrials);
if ~isempty(AOTrials)
     set(handles.frTrials,'UserData',AOTrials);
     set(handles.stRecTrials,'String',num2str(length(AOTrials)));
%     set(handles.stSTrials,'String',num2str(length(TaskTrials(Trials,'Sacc'))));
%     set(handles.stLRTrials,'String',num2str(length(TaskTrials(Trials,'LR1T'))));
%     set(handles.stRTrials,'String',num2str(length(TaskTrials(Trials,'Fix1T'))));
%     set(handles.stSRFTrials,'String',num2str(length(TaskTrials(Trials,'SaccRF'))));
%     set(handles.stLRRFTrials,'String',num2str(length(TaskTrials(Trials,'LRRF'))));
%     set(handles.stRRFTrials,'String',num2str(length(TaskTrials(Trials,'ReachRF'))));
%     set(handles.st3TTrials,'String',num2str(length(TaskTrials(Trials,'Free3T'))));
%     set(handles.stISTrials,'String',num2str(length(TaskTrials(Trials,'IntSacc'))));
else
     set(handles.stRecTrials,'String','0');
%     set(handles.stSTrials,'String','0');
%     set(handles.stLRTrials,'String','0');
%     set(handles.stRTrials,'String','0');
%     set(handles.stSRFTrials,'String','0');
%     set(handles.stLRRFTrials,'String','0');
%     set(handles.stRRFTrials,'String','0');
%     set(handles.st3TTrials,'String','0');
%     set(handles.stISTrials,'String','0');
%     set(handles.stFrTrials,'String','0');
%     set(handles.stSFrTrials,'String','0');
%     set(handles.stLRFrTrials,'String','0');
%     set(handles.stRFrTrials,'String','0');
%     set(handles.stSRFFrTrials,'String','0');
%     set(handles.stLRRFFrTrials,'String','0');
%     set(handles.stRRFFrTrials,'String','0');
%     set(handles.st3TFrTrials,'String','0');
%     set(handles.stISFrTrials,'String','0');
end

% --------------------------------------------------------------------
function varargout = pbSaveMovie_Callback(h, eventdata, handles, varargin)

global MONKEYDIR

disp('Saving movie data')
[day,rec,mt,ch,contact] = RecInformation(handles);
load([MONKEYDIR '/' day '/' rec '/rec' rec '.Rec.mat'])
if exist('experiment')
    mtch = expChannelIndex(experiment,mt,ch,contact);
else
    mtch = ch;
end
MovieData = get(handles.frMovie,'UserData');
filename = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.' num2str(mtch) '.MovieData.mat'];
save(filename,'MovieData');

% --------------------------------------------------------------------
function varargout = pbSaveSort_Callback(h, eventdata, handles, varargin)

global MONKEYDIR

disp('Saving sort data')
[day,rec,mt,ch,contact] = RecInformation(handles);
load([MONKEYDIR '/' day '/' rec '/rec' rec '.Rec.mat'])
if isfile([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat'])
    load([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat'])
end
SortData = get(handles.frSort,'UserData');
Iqual(1)=get(handles.edIsoQual1,'String');
Iqual(2)=get(handles.edIsoQual2,'String');
Iqual(3)=get(handles.edIsoQual3,'String');
Iqual(4)=get(handles.edIsoQual4,'String');
Iqual(5)=get(handles.edIsoQual5,'String');
Iqual(6)=get(handles.edIsoQual6,'String');
Iqual(7)=get(handles.edIsoQual7,'String');
Iqual(8)=get(handles.edIsoQual8,'String');
Iqual(9)=get(handles.edIsoQual9,'String');
Iqual(10)=get(handles.edIsoQual10,'String');
Iqual(11)=get(handles.edIsoQual11,'String');
Iqual(12)=get(handles.edIsoQual12,'String');
Iqual(13)=get(handles.edIsoQual13,'String');
Iqual(14)=get(handles.edIsoQual14,'String');

SortData(1).IsoQual=Iqual;
if exist('experiment')
    mtch = expChannelIndex(experiment,mt,ch,contact);
else
    mtch = ch;
end
%SortData=rmfield(SortData,'TempInclude');
filename = [MONKEYDIR '/' day '/' rec '/rec' rec .' mt '.' num2str(mtch) '.SortData.mat'];
save(filename,'SortData');


% --------------------------------------------------------------------
function varargout = pbNoneIsolated_Callback(h, eventdata, handles, varargin)

for iClu=2:14
    eval(['set(handles.ck' num2str(iClu) ',''Value'',0);']);
end


% --------------------------------------------------------------------

function varargout = popDim1_Callback(h, eventdata, handles, varargin)



    
% --------------------------------------------------------------------
function varargout = popDim2_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = popDim3_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = popDN_Callback(h, eventdata, handles, varargin)





% --------------------------------------------------------------------
function varargout = togglebutton3_Callback(h, eventdata, handles, varargin)






% --------------------------------------------------------------------
function varargout = pushbutton6_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ck1_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pop1_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = checkbox3_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = popupmenu11_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = checkbox4_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = popupmenu12_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = checkbox5_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = popupmenu13_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ck5_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pop5_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ck6_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pop6_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ck7_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pop7_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ck8_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pop8_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pushbutton7_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = popupmenu18_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = popupmenu19_Callback(h, eventdata, handles, varargin)






% --------------------------------------------------------------------
function varargout = ck9_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pop9_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ck10_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pop10_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ck11_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pop11_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ck12_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pop12_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ck13_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pop13_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ck14_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pop14_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pbPlotWaveforms_Callback(h, eventdata, handles, varargin)
% 
% global MONKEYDIR
% % 
% % WaveformData = get(handles.frCompare,'UserData');
% N = WaveformData(1).N
% 
% disp('Loading sort data')
% [day,rec,systring,ch] = RecInformation(handles);
% 
% filename = [MONKEYDIR '/' day '/' rec '/rec' rec systring '.SortData' num2str(ch) '.mat'];
% load(filename);
% % 
% disp('Averaging waveforms')
% N = N+1;
% WaveformData(1).N = N;
% WaveformData(N).Waveforms = zeros(14,size(SortData(1).Waveform,2));
% WaveformData(N).Nfr = zeros(1,14);
% for iCl = 1:14
%     nfr = 0;
%     for iFrame = 1:length(SortData);
%         if SortData(iFrame).Iso(iCl)
%             nfr = nfr + 1;
%             disp('SortData Statement ok')
%             WaveformData(N).Waveforms(iCl,:) = ...
%                 WaveformData(N).Waveforms(iCl,:) + SortData(iFrame).Waveform(iCl,:);
%         end
%     end
%     WaveformData(N).Nfr(iCl) = nfr;
%     if nfr WaveformData(N).Waveforms(iCl,:) = WaveformData(N).Waveforms(iCl,:)./nfr; end
% end
% set(handles.frCompare,'UserData',WaveformData);
% 
% disp('Drawing waveforms')
% axes(handles.axCompareWaveforms);
% cla;
% for iN = 1:N
%     for iCl = 1:14
%         if WaveformData(N).Nfr(iCl)
%             line([1:size(WaveformData.Waveforms,2)],WaveformData(iN).Waveforms(iCl,:),'Color',mycolors(iCl));
%         end
%     end
% end

% --------------------------------------------------------------------
function varargout = pbClear_Callback(h, eventdata, handles, varargin)

WaveformData(1).N  = 0;
WaveformData(1).Waveforms  = zeros(14,21);
WaveformData(1).Nfr  = zeros(1,14);
set(handles.frCompare,'UserData',WaveformData);
cla(handles.axCompareWaveforms)





% --------------------------------------------------------------------
function varargout = pbManualSort_Callback(h, eventdata, handles, varargin)

disp({'Adding a manually sorted cluster. Start by clicking on the graph '; 
    'you want to cluster on, then left-click on ecah point in the region ';
    'you would like to select as a cluster, using the right-click on the ';
    'last point to complete the cluster.'})

Dim1 = get(handles.popDim1,'Value');
Dim2 = get(handles.popDim2,'Value');
Dim3 = get(handles.popDim3,'Value');

FrameData = get(handles.frMovie,'UserData');
SortData = get(handles.frSort,'UserData');
FrameString = get(handles.stFrame,'String');
FrameNumber = str2double(FrameString(7:end));
tempind=find(FrameData(FrameNumber).TempInclude);
%FrameData(FrameNumber).U=FrameData(FrameNumber).U(tempind,:);

for icell = 2:14
    ind = find(SortData(FrameNumber).Clu(:,2) == icell);
    if ~(length(ind)>0)
        c=icell;
        break
    end
end

[tempX,tempY]=ginput(1);
axes(gca);
hold on;
tag=get(gca,'Tag')
if strcmp(tag(6),'1')
    d1=Dim1;
else
    d1=Dim2;
end
if strcmp(tag(7),'2')
    d2=Dim2;
else
    d2=Dim3;
end
IncSpikes=find(FrameData(FrameNumber).TempInclude);
U_seg = FrameData(FrameNumber).U(IncSpikes,[d1 d2]);


ButPress=1;
UserX=[];
UserY=[];
loop=0;
while ButPress==1
    loop=loop+1;
    [UserX(end+1),UserY(end+1),ButPress]=ginput(1);
    templines(loop)=plot(UserX,UserY);
    set(templines(loop),'Color',mycolors(c));
end
UserX(end+1)=UserX(1);
UserY(end+1)=UserY(1);
    loop=loop+1;
    templines(loop)=plot(UserX,UserY);
    set(templines(loop),'Color',mycolors(c));

% for iloop=1:loop
%     set(templines(loop),'Visible','off')
% end
% clear templines

disp('Assigning spikes within polygon')
A = inpolygon(U_seg(:,1),U_seg(:,2),UserX,UserY);
ind=find(inpolygon(U_seg(:,1),U_seg(:,2),UserX,UserY));
if length(ind)
    disp(['Found ' num2str(length(ind)) ' spikes'])
    SortData(FrameNumber).Clu(IncSpikes(ind),2) = c;
    SortData(FrameNumber).Waveform(c,:) = ...
        mean(FrameData(FrameNumber).Sp(IncSpikes(ind),:));
    eval(['hh = handles.ck' num2str(c) ';']);
    set(hh,'Value',1);
end

disp('Setting spikes as isolated')
SortData(FrameNumber).Iso(c) = 1;
set(handles.frSort,'UserData',SortData);

disp('Redrawing movie')
RedrawSortMovie(handles,FrameNumber);



% --------------------------------------------------------------------
function varargout = pbRemoveCell_Callback(h, eventdata, handles, varargin)

%Not- if iso checkbox is set isolated as a cell, when you remove it, 
%I'm adding something that won't let you reassign that as not isolated
%after removing it. But if it's set as not-isolated when you remove it, 
%you can later reassign that cluster as not isolated and essentially clear
%that, as in for denoising. To get the spikes back in that case if you did
%that erroneously, you unfortunately have to start over, and reload and 
%reproject; which is why I'm adding the safety in for removed clusetrs 
%notified as isolated

FrameData = get(handles.frMovie,'UserData');
SortData = get(handles.frSort,'UserData');
FrameString = get(handles.stFrame,'String');
FrameNumber = str2double(FrameString(7:end));

sp_seg = FrameData(FrameNumber).Sp;
sp_seg = [zeros(size(sp_seg,1),1) sp_seg];
RemCell = get(handles.edRemCell,'String');
RemCell=str2double(RemCell);
SortData(FrameNumber).RemCell(RemCell)=1;
eval(['a = handles.ck' num2str(RemCell) ';']);
SortData(FrameNumber).RemIso(RemCell)=get(a,'Value');

ind = find(SortData(FrameNumber).Clu(:,2) == RemCell);
disp(['Removing ' [num2str(length(ind))] ' spikes from frame'])
SortData(FrameNumber).TempInclude(ind)=0;
FrameData(FrameNumber).TempInclude(ind)=0;
sp_seg= sp_seg(find(SortData(FrameNumber).TempInclude),:);
[U_seg,pcold,eigvalues] = spikepcs(sp_seg);
FrameData(FrameNumber).U(find(FrameData(FrameNumber).TempInclude),:) = U_seg;
FrameData(FrameNumber).PC = pcold;
FrameData(FrameNumber).EigFrac=(eigvalues.^2)/sum(eigvalues.^2);

SortData(FrameNumber).U=FrameData(FrameNumber).U;

set(handles.frMovie,'UserData',FrameData);
set(handles.frSort,'UserData',SortData);

handles = RedrawSortMovie(handles,FrameNumber);


% --------------------------------------------------------------------
function varargout = edRemCell_Callback(h, eventdata, handles, varargin)


% --------------------------------------------------------------------
function varargout = pbRemoveAll_Callback(h, eventdata, handles, varargin)

FrameData = get(handles.frMovie,'UserData');
SortData = get(handles.frSort,'UserData');

for FrameNumber=1:length(FrameData)
    
    sp_seg = FrameData(FrameNumber).Sp;
    sp_seg = [zeros(size(sp_seg,1),1) sp_seg];
    RemCell = get(handles.edRemCell,'String');
    RemCell=str2double(RemCell);
    SortData(FrameNumber).RemCell(RemCell)=1;
    eval(['a = handles.ck' num2str(RemCell) ';']);
    SortData(FrameNumber).RemIso(RemCell)=get(a,'Value');
    ind = find(SortData(FrameNumber).Clu(:,2) == RemCell);
    disp(['Removing ' [num2str(length(ind))] ' spikes from frame'])
    
    SortData(FrameNumber).TempInclude(ind)=0;
    FrameData(FrameNumber).TempInclude(ind)=0;
    sp_seg= sp_seg(find(SortData(FrameNumber).TempInclude),:);
    [U_seg,pcold,eigvalues] = spikepcs(sp_seg);
    FrameData(FrameNumber).U(find(FrameData(FrameNumber).TempInclude),:) = U_seg;
    FrameData(FrameNumber).PC = pcold;
    FrameData(FrameNumber).EigFrac=(eigvalues.^2)/sum(eigvalues.^2);
    SortData(FrameNumber).U=FrameData(FrameNumber).U;
    
    set(handles.frMovie,'UserData',FrameData);
    set(handles.frSort,'UserData',SortData);
    handles = RedrawSortMovie(handles,FrameNumber);

end


% --------------------------------------------------------------------
function varargout = pbRecoverCell_Callback(h, eventdata, handles, varargin)

FrameData = get(handles.frMovie,'UserData');
SortData = get(handles.frSort,'UserData');
FrameString = get(handles.stFrame,'String');
FrameNumber = str2double(FrameString(7:end));

sp_seg = FrameData(FrameNumber).Sp;
sp_seg = [zeros(size(sp_seg,1),1) sp_seg];
RecCell = get(handles.edRemCell,'String');
RecCell=str2double(RecCell);
SortData(FrameNumber).RemCell(RecCell)=0;
ind = find(SortData(FrameNumber).Clu(:,2) == RecCell);
disp(['Recovering ' [num2str(length(ind))] ' spikes to frame'])

SortData(FrameNumber).TempInclude(ind)=1;
FrameData(FrameNumber).TempInclude(ind)=1;
sp_seg= sp_seg(find(SortData(FrameNumber).TempInclude),:);
[U_seg,pcold,eigvalues] = spikepcs(sp_seg);
FrameData(FrameNumber).U(find(FrameData(FrameNumber).TempInclude),:) = U_seg;
FrameData(FrameNumber).PC = pcold;
FrameData(FrameNumber).EigFrac=(eigvalues.^2)/sum(eigvalues.^2);
SortData(FrameNumber).U=FrameData(FrameNumber).U;

set(handles.frMovie,'UserData',FrameData);
set(handles.frSort,'UserData',SortData);

handles = RedrawSortMovie(handles,FrameNumber);


% --------------------------------------------------------------------
function varargout = pbRecoverAll_Callback(h, eventdata, handles, varargin)

FrameData = get(handles.frMovie,'UserData');
SortData = get(handles.frSort,'UserData');

for FrameNumber=1:length(FrameData)
    
    sp_seg = FrameData(FrameNumber).Sp;
    sp_seg = [zeros(size(sp_seg,1),1) sp_seg];
    RecCell = get(handles.edRemCell,'String');
    RecCell=str2double(RecCell);
    SortData(FrameNumber).RemCell(RecCell)=0;
    ind = find(SortData(FrameNumber).Clu(:,2) == RecCell);
    disp(['Recovering ' [num2str(length(ind))] ' spikes to frame'])
    
    SortData(FrameNumber).TempInclude(ind)=1;
    FrameData(FrameNumber).TempInclude(ind)=1;
    sp_seg= sp_seg(find(SortData(FrameNumber).TempInclude),:);
    [U_seg,pcold,eigvalues] = spikepcs(sp_seg);
    FrameData(FrameNumber).U(find(FrameData(FrameNumber).TempInclude),:) = U_seg;
    FrameData(FrameNumber).PC = pcold;
    FrameData(FrameNumber).EigFrac=(eigvalues.^2)/sum(eigvalues.^2);
    SortData(FrameNumber).U=FrameData(FrameNumber).U;
    
    set(handles.frMovie,'UserData',FrameData);
    set(handles.frSort,'UserData',SortData);
    handles = RedrawSortMovie(handles,FrameNumber);
    
end


% --------------------------------------------------------------------
function varargout = pbSetPC_Callback(h, eventdata, handles, varargin)

PCCellNum = get(handles.edPCCell,'String');
PCCellNum = str2double(PCCellNum);
FrNum = get(handles.edFrNum,'String');
FrNum = str2double(FrNum);
PCNum = get(handles.edPCNum,'String');
PCNum = str2double(PCNum);

%will regenerate PCS greater than PCNum after subtracting projections along prior PCs
FrameData = get(handles.frMovie,'UserData');
SortData = get(handles.frSort,'UserData');
FrameString = get(handles.stFrame,'String');
FrameNumber = str2double(FrameString(7:end));
numEndPCs=size(FrameData(FrameNumber).PC,2)-PCNum;

tempwav=SortData(FrNum).Waveform(PCCellNum,:);
tempwav=tempwav/(sqrt(sum(tempwav.^2))); %Normalizes waveform to have energy of one
FrameData(FrameNumber).PC(:,PCNum)=tempwav;
FrameData(FrameNumber).EigFrac(PCNum)=0;

sp_seg = FrameData(FrameNumber).Sp;
sp_seg = sp_seg(find(SortData(FrameNumber).TempInclude),:);
%sp_seg=sp_seg-repmat(mean(sp_seg),[size(sp_seg,1),1]); %Note subtracting the mean does not affect this
U_seg = FrameData(FrameNumber).U(find(FrameData(FrameNumber).TempInclude),:);
%for iPC=1:PCNum
%   iPC
    size(sp_seg)
    size(FrameData(FrameNumber).PC(:,1:PCNum))
    U_seg(:,1:PCNum)=sp_seg*FrameData(FrameNumber).PC(:,1:PCNum);
    disp('did this work?')
    size(U_seg)
    size(FrameData(FrameNumber).PC(:,1:PCNum)')
    sp_seg=sp_seg-U_seg(:,1:PCNum)*(FrameData(FrameNumber).PC(:,1:PCNum)');
    %end
sp_seg = [zeros(size(sp_seg,1),1) sp_seg];
[endU_seg,endpcs,endeigvalues] = spikepcs(sp_seg);
disp(endeigvalues)
U_seg(:,PCNum+1:end)=endU_seg(:,1:numEndPCs);
FrameData(FrameNumber).PC(:,PCNum+1:end)=endpcs(:,1:numEndPCs);
FrameData(FrameNumber).EigFrac(PCNum+1:end)=(endeigvalues(1:numEndPCs).^2)/sum(endeigvalues(1:numEndPCs).^2);
FrameData(FrameNumber).U(find(FrameData(FrameNumber).TempInclude),:) = U_seg;
SortData(FrameNumber).U=FrameData(FrameNumber).U;

set(handles.frMovie,'UserData',FrameData);
set(handles.frSort,'UserData',SortData);
handles = RedrawSortMovie(handles,FrameNumber);


% --------------------------------------------------------------------
function varargout = edPCCell_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edFrNum_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edPCNum_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edIsoQual1_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edIsoQual2_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edIsoQual3_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edIsoQual4_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edIsoQual5_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edIsoQual6_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edIsoQual7_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edIsoQual8_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edIsoQual9_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edIsoQual10_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edIsoQual11_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edIsoQual12_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edIsoQual13_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edIsoQual14_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edPCDifCell_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pbSetDifPC_Callback(h, eventdata, handles, varargin)

PCCellNum = get(handles.edPCCell,'String');
PCCellNum = str2double(PCCellNum);
PCDifCellNum = get(handles.edPCDifCell,'String');
PCDifCellNum = str2double(PCDifCellNum);
FrNum = get(handles.edFrNum,'String');
FrNum = str2double(FrNum);
DifFrNum = get(handles.edDifFrNum,'String');
DifFrNum = str2double(DifFrNum);
PCNum = get(handles.edDifPCNum,'String');
PCNum = str2double(PCNum);


%will regenerate PCS greater than PCNum after subtracting projections along prior PCs
FrameData = get(handles.frMovie,'UserData');
SortData = get(handles.frSort,'UserData');
FrameString = get(handles.stFrame,'String');
FrameNumber = str2double(FrameString(7:end));
numEndPCs=size(FrameData(FrameNumber).PC,2)-PCNum;

tempwav=SortData(FrNum).Waveform(PCCellNum,:);
tempwav2=SortData(DifFrNum).Waveform(PCDifCellNum,:);
tempwav=tempwav/(sqrt(sum(tempwav.^2))); %Normalizes waveform to have energy of one
tempwav2=tempwav2/(sqrt(sum(tempwav2.^2))); %Normalizes waveform to have energy of one
tempwav=tempwav-tempwav2;
tempwav=tempwav/(sqrt(sum(tempwav.^2))); %Normalizes waveform to have energy of one
FrameData(FrameNumber).PC(:,PCNum)=tempwav;
FrameData(FrameNumber).EigFrac(PCNum)=0;

sp_seg = FrameData(FrameNumber).Sp;
sp_seg = sp_seg(find(SortData(FrameNumber).TempInclude),:);
U_seg = FrameData(FrameNumber).U(find(FrameData(FrameNumber).TempInclude),:);
%for iPC=1:PCNum
%     iPC
%     size(sp_seg)
%     size(FrameData(FrameNumber).PC(:,1:PCNum))
    U_seg(:,1:PCNum)=sp_seg*FrameData(FrameNumber).PC(:,1:PCNum);
%     disp('did this work?')
%     size(U_seg)
%     size(FrameData(FrameNumber).PC(:,1:PCNum)')
    sp_seg=sp_seg-U_seg(:,1:PCNum)*(FrameData(FrameNumber).PC(:,1:PCNum)');
    %end
sp_seg = [zeros(size(sp_seg,1),1) sp_seg];
[endU_seg,endpcs,endeigvalues] = spikepcs(sp_seg);
%disp(endeigvalues)
U_seg(:,PCNum+1:end)=endU_seg(:,1:numEndPCs);
FrameData(FrameNumber).PC(:,PCNum+1:end)=endpcs(:,1:numEndPCs);
FrameData(FrameNumber).EigFrac(PCNum+1:end)=(endeigvalues(1:numEndPCs).^2)/sum(endeigvalues(1:numEndPCs).^2);
FrameData(FrameNumber).U(find(FrameData(FrameNumber).TempInclude),:) = U_seg;
SortData(FrameNumber).U=FrameData(FrameNumber).U;

%U_seg(1:50,1:3)

% %%%%%%%%%%%%%%%%%%%%%%%%%Earlier versoin
% sp_seg = FrameData(FrameNumber).Sp;
% sp_seg = sp_seg(find(SortData(FrameNumber).TempInclude),:);
% %sp_seg=sp_seg-repmat(mean(sp_seg),[size(sp_seg,1),1]); %Note subtracting the mean does not affect this
% U_seg = FrameData(FrameNumber).U(find(FrameData(FrameNumber).TempInclude),:);
% size(U_seg)
% %for iPC=1:PCNum
% %   iPC
%     size(sp_seg)
%     size(FrameData(FrameNumber).PC(:,1:PCNum))
%     U_seg(:,1:PCNum)=sp_seg*FrameData(FrameNumber).PC(:,1:PCNum);
%     disp('did this work?')
%     size(U_seg)
%     size(FrameData(FrameNumber).PC(:,1:PCNum)')
%     sp_seg=sp_seg-U_seg(:,1:PCNum)*(FrameData(FrameNumber).PC(:,1:PCNum)');
%     %end
% sp_seg = [zeros(size(sp_seg,1),1) sp_seg];
% [endU_seg,endpcs,endeigvalues] = spikepcs(sp_seg);
% disp(endeigvalues)
% U_seg(:,PCNum+1:end)=endU_seg(:,1:numEndPCs);
% FrameData(FrameNumber).PC(:,PCNum+1:end)=endpcs(:,1:numEndPCs);
% FrameData(FrameNumber).EigFrac(PCNum+1:end)=(endeigvalues(1:numEndPCs).^2)/sum(endeigvalues(1:numEndPCs).^2);
% FrameData(FrameNumber).U(find(FrameData(FrameNumber).TempInclude),:) = U_seg;
% SortData(FrameNumber).U=FrameData(FrameNumber).U;






set(handles.frMovie,'UserData',FrameData);
set(handles.frSort,'UserData',SortData);
handles = RedrawSortMovie(handles,FrameNumber);



% --------------------------------------------------------------------
function varargout = edDifFrNum_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edDifPCNum_Callback(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = pbRecreateSort_Callback(h, eventdata, handles, varargin)

global MAXFRAME MONKEYDIR

[day,rec,mt,ch,contact] = RecInformation(handles);
load([MONKEYDIR '/' day '/' rec '/rec' rec '.Rec.mat']);
if isfile([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat'])
    load([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat']);
end

load([MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.clu.mat']);
load([MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.iso.mat']);
Clu = clu{mtch};
Iso = iso{mtch};

sp = get(handles.pbLoad,'UserData');
IsoWin = 1e3*str2double(get(handles.edIsoWin,'String'));
sptimes = sp(:,1);
T = [0:IsoWin:max(sptimes) max(sptimes)];
nFrames = length(T)-1;
disp([num2str(nFrames) ' frames']);
MAXFRAME = nFrames;
set(handles.stFrame,'String','Frame 1');
drawnow
N = zeros(1,nFrames+1);
for i = 2:nFrames+1
    N(i) = max(find(sptimes<T(i)));
end
N(end) = N(end)+1;
sp_seg = sp(N(1)+1:N(1+1),2:end);
[U_seg,pcold,eigvalues] = spikepcs(sp(N(1)+1:N(2),:));
FrameData(1).Sp = sp(N(1)+1:N(2),2:end);
FrameData(1).U = U_seg;
FrameData(1).SpTimes = sp(N(1)+1:N(2),1);
FrameData(1).PC=pcold;
FrameData(1).EigFrac=(eigvalues.^2)/sum(eigvalues.^2); %fractional sum of squares
FrameData(1).TempInclude = ones(size(U_seg,1),1);
set(handles.frMovie,'UserData',FrameData);

NClus=size(Iso,2);
SortData(1).Clu=Clu(N(1)+1:N(1+1),:);
SortData(1).Iso=zeros(1,14);
SortData(1).Iso(1:NClus)=Iso(1,:);
SortData(1).U=FrameData(1).U;
SortData(1).TempInclude = FrameData(1).TempInclude;
SortData(1).RemCell=zeros(1,14);
SortData(1).IsoQual=zeros(1,14);

for c = NClus:-1:1
    ind = find(SortData(1).Clu(:,2)==c);
    if length(ind)
        disp(['found spikes for clus ' num2str(c)])
        if Iso(1,c)
            SortData(1).Waveform(c,:) = mean(FrameData(1).Sp(ind,:));
            eval(['hh = handles.ck' num2str(c) ';']);
            set(hh,'Value',1);
        else
            disp('should be assigning spikes for clus 2 as not isolated')
            SortData(1).Clu(ind,2)=1;
        end
    end
end
ind = find(SortData(1).Clu(:,2)==2);
set(handles.frSort,'UserData',SortData);

handles = RedrawSortMovie(handles,1);

for iFrame = 2:nFrames
    disp(['Frame ' num2str(iFrame) ' has ' num2str(N(iFrame+1)-N(iFrame)-1) ' spikes'] )
    set(handles.stFrame,'String',['Frame ' num2str(iFrame)]);
    if N(iFrame+1)-(N(iFrame)+1);
        [U_seg,pc,eigvalues] = spikepcs(sp(N(iFrame)+1:N(iFrame+1),:),pcold);
        U_old = sp(N(iFrame-1)+1:N(iFrame),2:end)*pcold;
        U_new = sp(N(iFrame-1)+1:N(iFrame),2:end)*pc;
        FrameData(iFrame).U = U_seg;
        FrameData(iFrame).PC=pc;
        FrameData(iFrame).EigFrac=(eigvalues.^2)/sum(eigvalues.^2); %fractional sum of squares
        FrameData(iFrame).Sp = sp(N(iFrame)+1:N(iFrame+1),2:end);
        FrameData(iFrame).SpTimes = sp(N(iFrame)+1:N(iFrame+1),1);
        FrameData(iFrame).TempInclude = ones(size(U_seg,1),1);
        
        set(handles.frMovie,'UserData',FrameData);  
        
        SortData(iFrame).Clu=Clu(N(iFrame)+1:N(iFrame+1),:);
        SortData(iFrame).Iso=zeros(1,14);
        SortData(iFrame).Iso(1:NClus)=Iso(iFrame,:);
        SortData(iFrame).U=FrameData(iFrame).U;
        SortData(iFrame).TempInclude = FrameData(iFrame).TempInclude;
        SortData(iFrame).RemCell=zeros(1,14);
        
        for c = NClus:-1:1
            ind = find(SortData(iFrame).Clu(:,2)==c);
            if length(ind)
                if Iso(iFrame,c)
                    SortData(iFrame).Waveform(c,:) = mean(FrameData(iFrame).Sp(ind,:));
                    eval(['hh = handles.ck' num2str(c) ';']);
                    set(hh,'Value',1);
                else
                    disp(['Found not isolated cluster, ' num2str(c) ' reassigning to MU'])
%                     tmp=SortData(iFrame).Clu(ind,2);
%                     SortData(iFrame).Clu(ind,2)=1;
%                     tmp=SortData(iFrame).Clu(ind,2);
                    eval(['hh = handles.ck' num2str(c) ';']);
                    set(hh,'Value',0);
                end
            end
        end       
        set(handles.frSort,'UserData',SortData);
        
%         for c=1:NClus
%             ind = find(SortData(iFrame).Clu(:,2)==c);
%             disp([num2str(length(ind)) ' spikes still in cluster ' num2str(c)])
%         end
        
        handles = RedrawSortMovie(handles,iFrame);
        pcold = pc;

    end
end

set(handles.frMovie,'UserData',FrameData);


% --------------------------------------------------------------------
function varargout = pbRecalcPCs_Callback(h, eventdata, handles, varargin)

FrameData = get(handles.frMovie,'UserData');
SortData = get(handles.frSort,'UserData');
FrameString = get(handles.stFrame,'String');
FrameNumber = str2double(FrameString(7:end));

sp_seg = FrameData(FrameNumber).Sp;
sp_seg = [zeros(size(sp_seg,1),1) sp_seg];
sp_seg= sp_seg(find(SortData(FrameNumber).TempInclude),:);
[U_seg,pcold,eigvalues] = spikepcs(sp_seg);
FrameData(FrameNumber).U(find(FrameData(FrameNumber).TempInclude),:) = U_seg;
FrameData(FrameNumber).PC = pcold;
FrameData(FrameNumber).EigFrac=(eigvalues.^2)/sum(eigvalues.^2);

SortData(FrameNumber).U=FrameData(FrameNumber).U;

set(handles.frMovie,'UserData',FrameData);
set(handles.frSort,'UserData',SortData);

handles = RedrawSortMovie(handles,FrameNumber);

% --------------------------------------------------------------------
function mtch = ch2mtch(Rec,mt,ch)
%
%   mtch = ch2mtch(Rec,mt,ch)
%


switch mt
    case Rec.MT1
        mtch = ch;
    case Rec.MT2
        mtch = ch + Rec.Ch(1);
end


% --- Executes on selection change in popSpType.
function popSpType_Callback(hObject, eventdata, handles)
% hObject    handle to popSpType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popSpType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popSpType


% --- Executes during object creation, after setting all properties.
function popSpType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popSpType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axDim12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axDim12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axDim12

% --- Executes on button press in tbOSort.
function tbOSort_Callback(hObject, eventdata, handles)
% hObject    handle to tbOSort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% if(get(hObject,'Value'))
%     set(handles.uipanelManual,'Visible','off');
%     set(handles.uipanelOSort,'Visible','on');
% else
%     set(handles.uipanelManual,'Visible','on');
%     set(handles.uipanelOSort,'Visible','off');
% end 

OSortFrame(handles);


% --- Executes on button press in togglebutton5.
function togglebutton5_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton5


% --- Executes during object creation, after setting all properties.
function popMT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popMT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popChannel.
function popupmenu45_Callback(hObject, eventdata, handles)
% hObject    handle to popChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popChannel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popChannel


% --- Executes during object creation, after setting all properties.
function popChannel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cbApplyRules.
function cbApplyRules_Callback(hObject, eventdata, handles)
% hObject    handle to cbApplyRules (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FrameString = get(handles.stFrame,'String');
FrameNumber = str2double(FrameString(7:end));
OSortFrame(handles);
RedrawSortMovie(handles,FrameNumber);
% Hint: get(hObject,'Value') returns toggle state of cbApplyRules

% --- Runs OSort on current frame data and saves it into SortData stored in
% UserData of tbOSort
function OSortFrame(handles, frame)
global MONKEYDIR
disp('Entering OSort');

SortData = get(handles.frSort,'UserData');

disp('1');
if nargin < 2
    FrameString = get(handles.stFrame,'String');
    FrameNumber = str2double(FrameString(7:end));
else
    FrameNumber = frame;
end

% clear previously reported text from info panel
% set(handles.clustersText,'String','');
% set(handles.rulesApplied,'String','');
% set(handles.lastSortTime,'String','');
disp('2');
MovieData = get(handles.frMovie,'UserData');
spikes = MovieData(FrameNumber).Sp;


% get threshold:
disp('3');
AOTrials = get(handles.frTrials,'UserData');
[day,rec,mt,ch] = RecInformation(handles);
if(length(AOTrials)>0) % if Labview behavior
    % in order to get threshold, use trial number which would approx
    % correspond to the center of this frame (pretty arbitrary)
    k = floor((FrameNumber/length(MovieData))*length(AOTrials) + 1/(length(MovieData)*2));
    aotrial = AOTrials(k);    
    load([MONKEYDIR '/' day '/' rec '/rec' rec '.Rec.mat'])
    Raw = RawTrial(aotrial,mt,ch,'End',[0,1e3]);
else % if Matlab behavior
    disp('4');
    Raw = stateRaw(day,rec,mt,ch,'Move',[0,500]);
    % k = floor((FrameNumber/length(MovieData))*size(Raw,1)) + 1/(length(MovieData)*2));
    k = floor(size(Raw,1)/2);
    Raw = Raw(k,:);
end
disp('5');

if(get(handles.thresholdOverride,'Value')) % use threshold override
    stdEst = get(handles.thresholdSlider,'Value');
else % dont' override, get from mufilter and update threshold readout
    stdEst = std(mufilter(Raw))
    set(handles.thresholdSlider,'Value',stdEst);
    set(handles.thresholdReadout,'String',num2str(stdEst));
end


% run Osort on spikes from this frame
tic
[assigned, nrAssigned, baseSpikes, baseSpikesID] = sortSpikesOffline(spikes,stdEst,size(spikes,1));
disp(['Sorting took ' num2str(toc) ' seconds.']);
% OSortData(FrameNumber).sortTime = sortTime;
% set(handles.lastSortTime,'String',[sortTime ' s']);

% create mapping for OSort clusterIDs for 1 to numClusters
MAXNUMCLUSTERS = 10;

numClusters = min([length(nrAssigned) MAXNUMCLUSTERS]);
clusterMap = nrAssigned(length(nrAssigned)-numClusters+1:end,1);
clusterMap = flipud(clusterMap);

% apply post-sort rules if box is checked (default)  
if(get(handles.cbApplyRules,'Value'))
    % if second cluster (first cell) is <= 10% of first cluster (noise) the
    % whole frame is probably noise
    noiseSize = nrAssigned(find(nrAssigned(:,1) == clusterMap(1)),2);
    firstCell = nrAssigned(find(nrAssigned(:,1) == clusterMap(2)),2);
    if(firstCell<=0.01*noiseSize)
        disp('Applying rule: All noise');
        % reassign all values that describe the clusters to be 1
        % cluster
        numClusters = 1;
        assigned(:) = clusterMap(1);
        nrAssigned(end,2) = size(spikes,2);
        noiseBaseSpikeID = baseSpikesID(find(baseSpikesID(:,1) == clusterMap(1)),2);
        baseSpikes(noiseBaseSpikeID,:) = mean(baseSpikes);
        % OSortData(FrameNumber).rulesApplied = sprintf([OSortData(FrameNumber).rulesApplied 'All Noise\n']);
        
        % set(handles.rulesApplied,'String',sprintf([get(handles.rulesApplied,'String') 'All Noise\n']));
    else
        disp('Applying rule: Small Clusters');
        MINSPIKES = 50;
        % any cluster with less than minspikes spikes is noise 
        for i=1:size(clusterMap,1);
            if(nrAssigned(find(nrAssigned(:,1) == clusterMap(i)),2) < MINSPIKES)
                % add second column to clusterMap to indicate if that
                % cluster is too small
                clusterMap(i,2) = 1;
            end
        end

        d = find(clusterMap(:,2));
        if(d)
            % set(handles.rulesApplied,'String',sprintf([get(handles.rulesApplied,'String') 'Small Clusters\n']));
            % OSortData(FrameNumber).rulesApplied = sprintf([OSortData(FrameNumber).rulesApplied 'Small Clusters\n']);
        end
        while(d)
            index = d(1);
            clusterID = clusterMap(index,1);
            nrAssnRow = find(nrAssigned(:,1) == clusterID);
            noiseClusterID = clusterMap(1);
            assigned(find(assigned == clusterID)) = noiseClusterID; % reassign all spikes
            nrAssigned(end,2) = nrAssigned(end,2) + nrAssigned(nrAssnRow,2); % add total to noise cluster
            % update noise base spike
            noiseBaseSpikeID = baseSpikesID(find(baseSpikesID(:,1) == clusterMap(1)),2);
            clusterBaseSpikeID = baseSpikesID(find(baseSpikesID(:,1) == clusterID),2);
            baseSpikes(noiseBaseSpikeID,:) = mean([baseSpikes(noiseBaseSpikeID,:);baseSpikes(clusterBaseSpikeID,:)]);
            % remove from clusterMap
            clusterMap = [clusterMap(1:index-1,:);clusterMap(index+1:end,:)];
            % remove from nrAssigned
            nrAssigned = [nrAssigned(1:nrAssnRow-1,:);nrAssigned(nrAssnRow+1:end,:)];
            d = find(clusterMap(:,2));
        end
        % remove second column from clusterMap and reset the size of
        % numClusters
        clusterMap = clusterMap(:,1);
        numClusters = length(clusterMap);
   end
end

% take only needed baseSpikes to insert into OSortData
newBaseSpikes = zeros(14,size(spikes,2));
for i=1:size(clusterMap,1);
    clusterID = baseSpikesID(find(baseSpikesID(:,1) == clusterMap(i)),2);
    newBaseSpikes(i,:) = baseSpikes(clusterID,:);
end
assigned(1) = 1;
for i=2:size(assigned,2);
   clusterID = find(clusterMap == assigned(i));
   if(clusterID)
       assigned(i) = clusterID;
   else
       assigned(i) = 1;
   end
end


SortData(FrameNumber).Iso = [ones(1,numClusters) zeros(1,14-numClusters)];
SortData(FrameNumber).Clu = [MovieData(FrameNumber).SpTimes assigned'];
SortData(FrameNumber).TempInclude = ones(size(spikes,1),1);
SortData(FrameNumber).RemCell = zeros(1,14);
SortData(FrameNumber).RemIso = zeros(1,14);
SortData(FrameNumber).IsoQual = zeros(1,14);
SortData(FrameNumber).NDim = 3;
SortData(FrameNumber).U=MovieData(FrameNumber).U;
SortData(FrameNumber).Waveform = newBaseSpikes;

set(handles.frSort,'UserData',SortData);
nrAssigned
% % create clusters cell array and assign sizes before copying spikes for
% % memory purposes
% clusters = cell(1,numClusters);    
% for i=1:length(clusters);
%     clusters{i} = zeros(nrAssigned(find(nrAssigned(:,1) == clusterMap(i)),2),size(spikes,2));
% end
% % maintain count of spikes assigned to each cluster
% clustersIndices = zeros(numClusters,1);
% % separate projections into separate matrices by cluster
% U = MovieData(FrameNumber).U;
% for i=1:length(U); 
%     % if the index is in the cluster map (i.e., it is one of the
%     % numClusters-1 largest clusters,) use it as the cluster ID 
%     index = find(clusterMap == assigned(i));
%     % if it is not, then just assign it to the first (noise) cluster
%     if(isempty(index)) 
%         index = 1;             
%     end
%     % copy spike over to corresponding cluster
%     clustersIndices(index) = clustersIndices(index)+1;
%     clusters{index}(clustersIndices(index),:) = U(i,:);  
% end

% convert to SortData and store in tbOSort UserData
    

% --- Executes on button press in pbOSortAll.
function pbOSortAll_Callback(hObject, eventdata, handles)

global MAXFRAME;
% hObject    handle to pbOSortAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

SortData = get(handles.frSort,'UserData');
okToRun = 0;
if(length(SortData) > 0)
    button = questdlg('Running OSort will replace the currently loaded sort (but not save anything.)  Continue?','Warning','No');
    if(strcmp(button,'Yes'))
        okToRun = 1;
    end
else
    okToRun = 1;
end

if(okToRun)
    bar = waitbar(0, 'Sorting Frames...');
    for i=1:MAXFRAME;
        waitbar((i-1)/MAXFRAME,bar,['Sorting frame ' num2str(i) ' of ' num2str(MAXFRAME)]);
        OSortFrame(handles,i);
    end
    close(bar);
end

% --- Executes on button press in pbOSortFrame.
function pbOSortFrame_Callback(hObject, eventdata, handles)
% hObject    handle to pbOSortFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FrameString = get(handles.stFrame,'String');
FrameNumber = str2double(FrameString(7:end));
OSortFrame(handles,FrameNumber);
RedrawSortMovie(handles,FrameNumber);


% --- Executes on slider movement.
function thresholdSlider_Callback(hObject, eventdata, handles)
% hObject    handle to thresholdSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(hObject,'Value',ceil(get(hObject,'Value')));
set(handles.thresholdReadout,'String',num2str(get(hObject,'Value')));

% --- Executes during object creation, after setting all properties.
function thresholdSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresholdSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in thresholdOverride.
function thresholdOverride_Callback(hObject, eventdata, handles)
% hObject    handle to thresholdOverride (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of thresholdOverride
if(get(hObject,'Value'))
    set(handles.thresholdSlider,'Enable','on');
else
    set(handles.thresholdSlider,'Enable','off');
end


% --- Executes on button press in pbSaveTrials.
function pbSaveTrials_Callback(hObject, eventdata, handles)
% hObject    handle to pbSaveTrials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[day,rec,mt,ch] = RecInformation(handles);
saveAOTrials(day);


% --- Executes on selection change in popContact.
function popContact_Callback(hObject, eventdata, handles)
% hObject    handle to popContact (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popContact contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popContact

global MONKEYDIR

[day,rec,mt,ch,contact] = RecInformation(handles);
%load([MONKEYDIR '/' day '/' rec '/rec' rec '.Rec.mat']);
if exist([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat'],'file')
    load([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat']);
end
if exist('experiment')
    mtch = expChannelIndex(experiment,mt,ch,contact);
else
    mtch = ch;
end

MovieDataFile = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.' num2str(mtch) ...
        '.MovieData.mat'];
SortDataFile = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.' num2str(mtch) ...
        '.SortData.mat'];

if isfile(SortDataFile)
    set(handles.pbLoadSort,'Visible','on');
else
    set(handles.pbLoadSort,'Visible','off');
end
    

if isfile(MovieDataFile)
    set(handles.pbLoadMovie,'Visible','on');
else
    set(handles.pbLoadMovie,'Visible','off');
end


% --- Executes during object creation, after setting all properties.
function popContact_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popContact (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
