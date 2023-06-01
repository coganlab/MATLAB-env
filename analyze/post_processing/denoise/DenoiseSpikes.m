function varargout = DenoiseSpikes(varargin)
% DENOISESPIKES Application M-file for DenoiseSpikes.fig
%    FIG = DENOISESPIKES launch DenoiseSpikes GUI.
%    DENOISESPIKES('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 26-Dec-2010 15:43:29

global MONKEYDIR

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));
    set(fig,'DoubleBuffer','on');
    set(fig,'Name','DenoiseSpikes');
    
	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);
    
    Dir = getRecordingDays;
%     DayString = {};
%     for iDay = 1:length(Dir);
%         DayString{iDay} = Dir(iDay).name;
%     end
%     set(handles.edDay,'String',DayString);
    set(handles.edDay,'String',Dir(end).name)
    day = get(handles.edDay,'String');
    UpdateDay(handles,day);

    CompArr = {'<','>'};
    set(handles.popComp1,'String',CompArr);
    set(handles.popComp2,'String',CompArr);
    DimArr = cell(1,50);
    for i = 1:50
        DimArr{i} = num2str(i); 
    end
    set(handles.popBinComp1,'String',DimArr);
    set(handles.popBinComp2,'String',DimArr);
    set(handles.popNComp,'String',{'1','2'});
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
function varargout = pbLoad_Callback(h, eventdata, handles, varargin)

global MONKEYDIR

day = get(handles.edDay,'String');
RecString = get(handles.popRec,'String');
RecValue = get(handles.popRec,'Value');
rec = RecString{RecValue};
load([MONKEYDIR '/' day '/' rec '/rec' rec '.Rec.mat']);
MTString = get(handles.popMT,'String');
MTValue = get(handles.popMT,'Value');
mt = MTString{MTValue};

ChString = get(handles.popCh,'String');
ChValue = get(handles.popCh,'Value');
ch = str2double(ChString{ChValue});

mtch = ch;
filename = [MONKEYDIR '/' day '/' rec '/rec' rec  '.' mt '.sp.mat'];
disp(['Loading from ' filename]);
load(filename);
Sp = sp{mtch};
set(handles.pbLoad,'UserData',Sp);
set(handles.frLoad,'UserData',sp);
set(handles.stNumSpikes,'String',[num2str(size(Sp,1)) ' Spikes']);
PlotWaveforms(handles)
PlotClusters(handles)

% --------------------------------------------------------------------
function varargout = edDay_Callback(h, eventdata, handles, varargin)

day = get(h,'String');
% DayValue = get(h,'Value');
% day = DayString{DayValue};
UpdateDay(handles,day);


% --------------------------------------------------------------------
function UpdateDay(handles,day)
%
%
%

global MONKEYDIR

disp(['Update Recording list for ' day]);
recs = dayrecs(day);
if length(recs)
    set(handles.popRec,'Value',1);
    set(handles.popRec,'String',recs);
    disp(['Update MT list for ' day]);

    if(isfile([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat']))
        load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat']);
        if(isfield(experiment.hardware,'microdrive'))
            MTString = cell(1,length(experiment.hardware.microdrive));
            for i = 1:length(MTString)
                MTString{i} = experiment.hardware.microdrive(i).name;
            end
            % Some rigs (ok let's face it only rig 2) may have electrodes with
            % nonconsecutive numbering so need to check which electrodes exist
            disp(['Update Channel list for ' day]);
            ChannelString = {};
            for i = 1:length(experiment.hardware.microdrive(1).electrodes)
                if(~isempty(experiment.hardware.microdrive(1).electrodes(i).label))
                    ChannelString{end+1} = num2str(i);
                end
            end
        else
            MTString{1} = 'No microdrives';
            disp(['Update Channel list for ' day]);
            ChannelString = {};
        end
                set(handles.popCh,'String',ChannelString);
     else
         load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.Rec.mat']);
         MTString = {Rec.MT1,Rec.MT2};
         disp(['Update Channel list for ' day]);
         for i = 1:Rec.Ch(1); ChannelString{i} = num2str(i); end
     end
     
     set(handles.popCh,'String',ChannelString);
     set(handles.popMT,'String',MTString);

end

% --------------------------------------------------------------------
function varargout = popRec_Callback(h, eventdata, handles, varargin)

global MONKEYDIR


% --------------------------------------------------------------------
function varargout = popMT_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = popCh_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = popComp1_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = popupmenu5_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edComp1_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edComp2_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = popBinComp1_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = popBinComp2_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pbSelect_Callback(h, eventdata, handles, varargin)

CompArr = {'<','>'};

Sp = get(handles.pbLoad,'UserData');

NComp = get(handles.popNComp,'Value');

if NComp == 1
    Bin1 = get(handles.popBinComp1,'Value');
    Thresh1 = str2double(get(handles.edComp1,'String'));
    Comp1 = get(handles.popComp1,'Value');
    if Comp1==1 % <
        ind = find(Sp(:,Bin1+1) < Thresh1);
    elseif Comp1==2
        ind = find(Sp(:,Bin1+1) > Thresh1);
    end
    Noise.ind = ind;
    Noise.Sp = Sp(ind,:);
    set(handles.frNoise,'UserData',Noise);
    PlotNoise(handles);
    PlotNoiseCluster(handles);
elseif NComp ==2
    Bin1 = get(handles.popBinComp1,'Value');
    Thresh1 = str2double(get(handles.edComp1,'String'));
    Comp1 = get(handles.popComp1,'Value');
    Bin2 = get(handles.popBinComp2,'Value');
    Thresh2 = str2double(get(handles.edComp2,'String'));
    Comp2 = get(handles.popComp2,'Value');
    if Comp1==1 && Comp2 ==1% <
        ind = find(Sp(:,Bin1+1) < Thresh1 & Sp(:,Bin2+1) < Thresh2);
    elseif Comp1==2 && Comp2 == 1
        ind = find(Sp(:,Bin1+1) > Thresh1 & Sp(:,Bin2+1) < Thresh2);
    elseif Comp1==1 && Comp2 == 2
        ind = find(Sp(:,Bin1+1) < Thresh1 & Sp(:,Bin2+1) > Thresh2);
    elseif Comp1 == 2 && Comp2 == 2
        ind = find(Sp(:,Bin1+1) > Thresh1 & Sp(:,Bin2+1) > Thresh2);
    end
    Noise.Sp = Sp(ind,:);
    Noise.ind = ind;
    set(handles.frNoise,'UserData',Noise);
    PlotNoise(handles);
    PlotNoiseCluster(handles);
end

% --------------------------------------------------------------------
function varargout = pbUpdate_Callback(h, eventdata, handles, varargin)

Sp = get(handles.pbLoad,'UserData');
Noise = get(handles.frNoise,'UserData');
nind = setdiff([1:length(Sp(:,1))],Noise.ind);
Sp = Sp(nind,:);
set(handles.pbLoad,'UserData',Sp);
PlotWaveforms(handles);
PlotClusters(handles);


% --------------------------------------------------------------------
function PlotNoise(handles)

Noise = get(handles.frNoise,'UserData');
Noise;
disp('Drawing noise')
axes(handles.axNoise);
SpikeStart = str2num(get(handles.edSpikeStart,'String'));
SpikeStop = str2num(get(handles.edSpikeStop,'String'));
cla;
line(1:size(Noise.Sp,2)-1, Noise.Sp(1:end,2:end));
set(gca,'XLim',[1,size(Noise.Sp,2)-1]);


% --------------------------------------------------------------------
function PlotWaveforms(handles)

Sp = get(handles.pbLoad,'UserData');
disp('Drawing waveforms')
axes(handles.axWaveform);
SpikeStart = str2num(get(handles.edSpikeStart,'String'));
SpikeStop = str2num(get(handles.edSpikeStop,'String'));
cla;
line([1:size(Sp,2)-1], Sp(SpikeStart:min([SpikeStop,end]),2:end)');
set(gca,'XLim',[1,size(Sp,2)-1]);
axes(handles.axNoise);
cla;


% --------------------------------------------------------------------
function PlotClusters(handles)

Sp = get(handles.pbLoad,'UserData');
fet = spikepcs(Sp);
disp('Drawing clusters')
axes(handles.axCluster);
SpikeStart = str2num(get(handles.edSpikeStart,'String'));
SpikeStop = str2num(get(handles.edSpikeStop,'String'));
cla;
h=line(fet(SpikeStart:min([SpikeStop,end]),1),fet(SpikeStart:min([SpikeStop,end]),2),'Linestyle','.');
set(h,'Markersize',.5);
axes(handles.axNoiseCluster);
cla;
disp('End Drawing clusters')

% --------------------------------------------------------------------
function PlotNoiseCluster(handles)

Noise = get(handles.frNoise,'UserData');
fet = spikepcs(Noise.Sp);
disp('Drawing clusters')
axes(handles.axNoiseCluster);
cla;
line(fet(:,1),fet(:,2),'LineStyle','.','Color','k','Markersize',.5);

% --------------------------------------------------------------------
function varargout = popupmenu8_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pbSave_Callback(h, eventdata, handles, varargin)

Sp = get(handles.pbLoad,'UserData');
sp = get(handles.frLoad,'UserData');

global MONKEYDIR

day = get(handles.edDay,'String');
RecString = get(handles.popRec,'String');
RecValue = get(handles.popRec,'Value');
rec = RecString{RecValue};
load([MONKEYDIR '/' day '/' rec '/rec' rec '.Rec.mat']);
MTString = get(handles.popMT,'String');
MTValue = get(handles.popMT,'Value');
mt = MTString{MTValue};

ChString = get(handles.popCh,'String');
ChValue = get(handles.popCh,'Value');
ch = str2double(ChString{ChValue});

mtch = ch;
sp{mtch} = Sp;

filename = [MONKEYDIR '/' day '/' rec '/rec' rec '.' mt '.sp.mat'];
disp(['Saving ' filename]);
save(filename,'sp');
disp('Done saving spikes');


% --------------------------------------------------------------------
function varargout = pbJuiceTube_Callback(h, eventdata, handles, varargin)

CompArr = {'<','>'};

Sp = get(handles.pbLoad,'UserData');

UpperBin1 = 5; UpperBin2 = 15;
LowerBin1 = 5; LowerBin2 = 15;
UpperThresh = str2num(get(handles.edUpperRange,'String'));
LowerThresh = str2num(get(handles.edLowerRange,'String'));

ind = [];
for iBin = [2:UpperBin1 UpperBin2:size(Sp,2)]
    ind = [ind find(Sp(:,iBin) > UpperThresh)'];
end

for iBin = [2:LowerBin1 LowerBin2:size(Sp,2)]
    ind = [ind find(Sp(:,iBin) < LowerThresh)'];
end

Noise.Sp = Sp(ind,:);
Noise.ind = ind;
set(handles.frNoise,'UserData',Noise);
PlotNoise(handles);
PlotNoiseCluster(handles);

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



function edSpikeStart_Callback(hObject, eventdata, handles)
% hObject    handle to edSpikeStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edSpikeStart as text
%        str2double(get(hObject,'String')) returns contents of edSpikeStart as a double


% --- Executes during object creation, after setting all properties.
function edSpikeStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edSpikeStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edSpikeStop_Callback(hObject, eventdata, handles)
% hObject    handle to edSpikeStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edSpikeStop as text
%        str2double(get(hObject,'String')) returns contents of edSpikeStop as a double


% --- Executes during object creation, after setting all properties.
function edSpikeStop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edSpikeStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbRePlot.
function pbRePlot_Callback(hObject, eventdata, handles)
% hObject    handle to pbRePlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

PlotWaveforms(handles)
PlotClusters(handles)



function edUpperRange_Callback(hObject, eventdata, handles)
% hObject    handle to edUpperRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edUpperRange as text
%        str2double(get(hObject,'String')) returns contents of edUpperRange as a double


% --- Executes during object creation, after setting all properties.
function edUpperRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edUpperRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edLowerRange_Callback(hObject, eventdata, handles)
% hObject    handle to edLowerRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edLowerRange as text
%        str2double(get(hObject,'String')) returns contents of edLowerRange as a double


% --- Executes during object creation, after setting all properties.
function edLowerRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edLowerRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
