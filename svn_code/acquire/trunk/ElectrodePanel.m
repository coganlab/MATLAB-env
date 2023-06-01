function varargout = controlpanel(varargin)
% CONTROLPANEL Application M-file for controlpanel.fig
%    FIG = CONTROLPANEL launch controlpanel GUI.
%    CONTROLPANEL('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 10-Dec-2008 14:38:59

if nargin == 0  % LAUNCH GUI

	fig = openfig('ControlPanel.fig','reuse');
	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
    guidata(fig, handles);   
    set(fig,'DoubleBuffer','on');
    get(handles.axDatah,'Visible');
          
   if nargout > 0 varargout{1} = handles; end

   if nargout > 1 varargout{2} = fig; end
      

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
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
%| 'Electrode_Microdrive_Panel_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.Electrode_Microdrive_Panel, handles.slider2. This
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
function varargout = edStep(h, eventdata, handles, varargin)
% Stub for callback of step edit box


% --------------------------------------------------------------------
function varargout = pbReset(h, eventdata, handles, varargin)

global TARGET
        Electrode = get(handles.frElectrode,'UserData');
        tcpwrite = Electrode.TCPWrite;  %eps_bw
        tcpread = Electrode.TCPRead;
        e = Electrode.Num;
        mt = Electrode.MT;

        disp(['Resetting counter for electrode ' num2str(e)  ' on MT ' num2str(mt)])
        aoRezero(tcpwrite,tcpread,mt,e);
%         set(handles.stPosition,'String','0')  
%         TARGET(d,e) = 0;
    

% -------------------------------------------------------------------- %
%                      Sliders configuration
% -------------------------------------------------------------------- %
function varargout = slVelocity(h, eventdata, handles, varargin)
    
    a = round(get(h,'Value'));
    set(handles.stVelocity,'String',num2str(a));

% --------------------------------------------------------------------
function varargout = pbStepUp(h, eventdata, handles)

global TARGET

        Electrode = get(handles.frElectrode,'UserData');
        tcpwrite = Electrode.TCPWrite;  %eps_bw
        e = Electrode.Num;
        mt = Electrode.MT;

        pos = str2num(get(handles.stPosition, 'String'));
        step = str2num(get(handles.edStep, 'String'));        
        vel = str2num(get(handles.stVelocity,'String'));
        disp(['Moving electrode ' num2str(e) ' on MT ' num2str(mt)]);
        aoGoTo(tcpwrite,mt,e,pos-step,vel);
%         set(handles.stPosition, 'String', num2str(pos-step));
        TARGET(mt,e) = pos-step;
        
        set(handles.pbStepUp,'BackgroundColor',[1,0,0]);
        set(handles.pbStepDown,'BackgroundColor',[.7,.7,.7]);

% --------------------------------------------------------------------
function varargout = pbStepDown(h, eventdata, handles, varargin)

global TARGET

        Electrode = get(handles.frElectrode,'UserData');
        tcpwrite = Electrode.TCPWrite;
        e = Electrode.Num;
        mt = Electrode.MT;

        pos = str2num(get(handles.stPosition, 'String'));
        step = str2num(get(handles.edStep, 'String'));
        vel = str2num(get(handles.stVelocity,'String'))
        disp(['Moving electrode ' num2str(e) ' on MT ' num2str(mt)]);
        aoGoTo(tcpwrite,mt,e,pos+step,vel);
        TARGET(mt,e) = pos+step;

%         set(handles.stPosition, 'String', num2str(pos+step));
        set(handles.pbStepUp,'BackgroundColor',[0.7,0.7,0.7]);
        set(handles.pbStepDown,'BackgroundColor',[1,0,0]);

        
        
% --------------------------------------------------------------------
function varargout = pbDriveTo(h, eventdata, handles, varargin)

global TARGET

        Electrode = get(handles.frElectrode,'UserData');
        tcpwrite = Electrode.TCPWrite;  %% Port initialized for control ie eps_bw
        e = Electrode.Num;
        mt = Electrode.MT;

        pos = str2num(get(handles.edDriveTo, 'String'));
        vel = str2num(get(handles.stVelocity,'String'));
        disp(['Moving electrode ' num2str(e) ' on MT ' num2str(mt)]);
        aoGoTo(tcpwrite,mt,e,pos,vel);
%         set(handles.stPosition, 'String', num2str(pos));        
        TARGET(mt,e) = pos;

% --------------------------------------------------------------------
function varargout = pbHalt(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.edPosition1_2.


global TARGET

        Electrode = get(handles.frElectrode,'UserData');
        tcpwrite = Electrode.TCPWrite;
        tcpread = Electrode.TCPRead;
        e = Electrode.Num;
        mt = Electrode.MT;

        disp(['Halt electrode ' num2str(e) ' on MT ' num2str(mt)]);
        aoHalt(tcpwrite,mt,e);
%         pos = aoGetPos(tcpwrite,tcpread,mt,e);
        done=0;
        [pos,done] = aoGetPos3(tcpwrite,tcpread,MT,Num);
        while ~done
            %wait until aoGetPos3 is done
        end
        

%         set(handles.stPosition,'String',num2str(pos));
        TARGET(mt,e) = pos;

% --------------------------------------------------------------------
function varargout = pbOBLower(h, eventdata, handles, varargin)
% 
% global TARGET
% 
%         runstring=1;
%         if get(handles.cbInBrain,'Value')
%             Question='You''re in the brain. Are you sure you want to do this?';
%             Title='Are you sure?';
%             reply=questdlg(Question,Title,'Yes','No','No')
%             if strcmp(reply,'No')
%                 runstring=0;
%             end
%         end
%         if runstring
%             Electrode = get(handles.frElectrode,'UserData');
%             tcp = Electrode.TCP;
%             e = Electrode.Num;
%             mt = Electrode.MT;
%             
%             disp(['Lower electrode ' num2str(e) ' on MT ' num2str(mt) ' to 10000 at velocity 250']);
%             aoHalt(tcp,mt,e);
%             set(handles.stPosition,'String',num2str(aoGetPos(tcp,dis,mt,e)));
%             aoGoTo(tcp,mt,e,10000,250);
% %             set(handles.stPosition,'String','10000');
%             TARGET(mt,e) = 10000;
%             set(handles.stVelocity,'String','250');
%             set(handles.slVelocity,'Value',250);
%         end
 
% --------------------------------------------------------------------
function varargout = pbOBRaise(h, eventdata, handles, varargin)
% 
% global TARGET
% 
%        runstring=1;
%         if get(handles.cbInBrain,'Value')
%             Question='You''re in the brain. Are you sure you want to do this?';
%             Title='Are you sure?';
%             reply=questdlg(Question,Title,'Yes','No','No')
%             if strcmp(reply,'No')
%                 runstring=0;
%             end
%         end
%         if runstring
%             Electrode = get(handles.frElectrode,'UserData');
%             tcp = Electrode.TCP;
%             e = Electrode.Num;
%             mt = Electrode.MT;
%             
%             disp(['Raise electrode ' num2str(e) ' on MT ' num2str(mt) ' to -2000 at velocity 250']);
%             CDD(s,e);
%             set(handles.stPosition,'String',num2str(aoGetPos(tcp,mt,e)));
%             aoGoTo(tcp,mt,e,-2000,250);
% %             set(handles.stPosition,'String','-2000');
%             set(handles.stVelocity,'String','250');
%             set(handles.slVelocity,'Value',250);
%             TARGET(mt,e) = -2e3;
%         end
%         
%         
% --------------------------------------------------------------------
function varargout = pbIBDayStart(h, eventdata, handles, varargin)
%  
% global TARGET
% 
%         Electrode = get(handles.frElectrode,'UserData');
%         tcp = Electrode.TCP;
%         e = Electrode.Num;
%         mt = Electrode.MT;
% 
%         disp(['Lower electrode ' num2str(e) ' on MT ' num2str(mt) ' to 0 at velocity 25']);
%         CDD(s,e);
%         set(handles.stPosition,'String',num2str(GC(s,e)));
%         GT(s,e,0,25);
% %         set(handles.stPosition,'String','0');
%         set(handles.stVelocity,'String','25');
%         set(handles.slVelocity,'Value',25);
%         set(handles.cbInBrain,'Value',1)
%         TARGET(d,e) = 0;
%         pause(.25)
%         set(handles.slVelocity,'Value',10);
%         set(handles.stVelocity,'String','10');
%         set(handles.edDriveTo,'String',2000);
%         
% --------------------------------------------------------------------
function varargout = pbIBDayEnd(h, eventdata, handles, varargin)
%  
% global TARGET
% 
%         Electrode = get(handles.frElectrode,'UserData');
%         s = Electrode.Serial;
%         e = Electrode.Num;
%         d = Electrode.Drive;
% 
%         disp(['Raise electrode ' num2str(e) ' on Drive ' num2str(d) ' to -2000 initially at velocity 25']);
%         CDD(s,e);
%         set(handles.stPosition,'String',num2str(GC(s,e)));
%         GT(s,e,-2000,25);
% %         set(handles.stPosition,'String','-2000');
%         set(handles.stVelocity,'String','25');
%         set(handles.slVelocity,'Value',25);
%         set(handles.cbInBrain,'Value',0)
%         TARGET(d,e) = -2e3;
%         
% --------------------------------------------------------------------
function varargout = pbClean(h, eventdata, handles, varargin)
% 
%         Electrode = get(handles.frElectrode,'UserData');
%         s = Electrode.Serial;
%         e = Electrode.Num;
%         d = Electrode.Drive;
% 
%         disp(['Cleaning electrode ' num2str(e) ' on Drive ' num2str(d)]);
% 
%         ChuzzOff(s,e);
%  
        
% --------------------------------------------------------------------
function varargout = Electrode_Microdrive_Panel_ResizeFcn(h, eventdata, handles, varargin)


function varargout = edDriveTo(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = checkbox10_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edit60_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = popupmenu4_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = tbExtract_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = axWavh_ButtonDownFcn(h, eventdata, handles, varargin)
disp('Pressed Button!');

CurrentPoint = get(h,'CurrentPoint');

if CurrentPoint(1,2) < -25
    set(handles.edThreshold,'String',num2str(fix(CurrentPoint(1,2))))
    Obh = get(h,'UserData');
    set(Obh(101),'Ydata',[CurrentPoint(1,2),CurrentPoint(1,2)])
else
    disp('Threshold is too low!')
end



% --------------------------------------------------------------------
function varargout = checkbox11_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edInterval_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edDistance_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edRateThresh_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edTime_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edRange_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = tbSort(h, eventdata, handles, varargin)

global SYSTEM SAMPLING

DIM = 2;    %  Dimension cluster space

if get(h,'Value')==1
    disp('Recomputing Principal Components');
    Electrode = get(handles.frElectrode,'UserData');
    mt = Electrode.MT;
    e = Electrode.Num;
    thresh = str2num(get(handles.edThreshold,'String'));
    K = str2num(get(handles.edClusters,'String'));

%     T = str2num(get(handles.edSpikeBuffer,'String'));
    T = 15;
    y = nstream_getmu_nspike_4(SAMPLING*T);
    %    y = mufilter(y(e,:));
    e = (mt-1)*SYSTEM(1).NumElectrodes + e;
    standev = std(y(e,:))
    sp = spikeextract(y(e,:)-mean(y(e,:)),thresh*standev);
    
    %standev = median(abs(y(e,:)))./0.6745;
    
    pc = onSpikepcs(sp);
    pc = pc(:,1:DIM);
    fet = sp*pc;
    perm = randperm(size(sp,1));
    perm = perm(1:K);
    centers = fet(perm,:);
    [centers,options,post] = kmeans(fet,K,centers);
    [dum,cind] = sort(sqrt(sum(centers'.^2)));
    centers = centers(cind,:);
    
    Sort.PC = pc;
    Sort.SD = standev;
    Sort.Centers = centers;
    Sort.Mean = mean(y(e,:));
    
    set(handles.tbSort,'UserData',Sort);
    
    disp('Leaving pbSort');
else
    disp('Stop sorting');
end


% --------------------------------------------------------------------
function varargout = edClusters_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edit68_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pushbutton82_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pushbutton83_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pbLowerIntoOil_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pushbutton85_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pushbutton86_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = cbInBrain_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = popChannel_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edDim_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ck1_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ck2_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ck3_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ck4_Callback(h, eventdata, handles, varargin)


