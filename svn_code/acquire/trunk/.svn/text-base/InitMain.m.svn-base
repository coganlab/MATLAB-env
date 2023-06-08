function handles = InitMain(handles)
%
%   handles = InitMain(handles)
%

global experiment;
global electrode_type microdrive_type

% set(handles.popEnvironment,'String',...
%     {'Lights on','Lights off, Power on',...
%         'Lights off, Power off','Dark'});
% set(handles.popEnvironment,'Value',2);
TC = get(handles.popTaskController,'String');
NumTaskControllers = length(TC);
set(handles.popTaskController,'Value',NumTaskControllers); %  Sets the default for the Labview Task Controller
set(handles.popType,'String',{'Behavior','Recording'});
set(handles.popType,'Value',2);
% set(handles.popMT1,'String',{'PRR','LIP'});
% set(handles.popMT1,'Value',1);
% set(handles.popMT2,'String',{'PRR','LIP'});
% set(handles.popMT2,'Value',2);

% set(handles.popStimMT,'String',{'PRR','LIP'});
% set(handles.popStimMT,'Value',1);
% set(handles.popStimElectrode,'String',{'Ch 1','Ch 2'});
% set(handles.popStimElectrode,'Value',2);
% set(handles.popPolarity,'String',{'Monopolar','Bipolar'});
% set(handles.popPolarity,'Value',1);
% 
% set(handles.popSpikeMT,'String',{'PRR','LIP'});
% set(handles.popSpikeElectrode,'String',{'Ch 1','Ch 2','Ch 3','Ch 4'});
% set(handles.popSpikeCell,'String',{'Cell 1','Cell 2','Cell 3','Cell 4'});
% set(handles.popSpikeMT,'Value',1);
% set(handles.popSpikeElectrode,'Value',1);
% set(handles.popSpikeCell,'Value',2);
% set(handles.edSpikeBuffer,'Value',30);
% 
% set(handles.popHistMT,'String',{'PRR','LIP'});
% set(handles.popHistElectrode,'String',{'Ch 1','Ch 2','Ch 3','Ch 4'});
% set(handles.popHistCell,'String',{'Cell 1','Cell 2','Cell 3','Cell 4'});
% set(handles.popHistMT,'Value',1);
% set(handles.popHistElectrode,'Value',1);
% set(handles.popHistCell,'Value',2);
% 
% set(handles.popFieldMT1,'String',{'PRR','LIP'});
% set(handles.popFieldElectrode1,'String',{'Ch 1','Ch 2','Ch 3','Ch 4'});
% set(handles.popFieldMT2,'String',{'PRR','LIP'});
% set(handles.popFieldElectrode2,'String',{'Ch 1','Ch 2','Ch 3','Ch 4'});
% set(handles.popFieldMT1,'Value',2);
% set(handles.popFieldElectrode1,'Value',1);
% set(handles.popFieldMT2,'Value',1);
% set(handles.popFieldElectrode2,'Value',1);

% set(handles.popAlignField,'String',{'StartAq','TargetOn','Go','TargetAq'});
% set(handles.popAlignField,'Value',2);

% set(handles.popSFSpikeMT,'String',{'PRR','LIP'});
% set(handles.popSFSpikeElectrode,'String',{'Ch 1','Ch 2','Ch 3','Ch 4'});
% set(handles.popSFFieldMT,'String',{'PRR','LIP'});
% set(handles.popSFFieldElectrode,'String',{'Ch 1','Ch 2','Ch 3','Ch 4'});
% set(handles.popSFSpikeMT,'Value',1);
% set(handles.popSFSpikeElectrode,'Value',1);
% set(handles.popSFFieldMT,'Value',1);
% set(handles.popSFFieldElectrode,'Value',1);

% set(handles.popSystem1,'String',{'None','2 Ch','4 Ch'});
% set(handles.popSystem2,'String',{'None','2 Ch','4 Ch'});
% set(handles.popSystem1,'Value',3);

% set(handles.popSystem2,'Value',3);

% 9 is the maximumnumber of displayed tasks
for i = 1:9
    tmp_label = ['rec_count_' num2str(i)];
    tmp_label2 = ['rec_count_out_' num2str(i)];
    if(i < length(experiment.acquire.recording.task.type_names)+1)
        set(handles.(tmp_label),'Visible','on')
        set(handles.(tmp_label2),'Visible','on')
        set(handles.(tmp_label),'String',experiment.acquire.recording.task.type_names{i});
    else
        set(handles.(tmp_label),'Visible','off')
        set(handles.(tmp_label2),'Visible','off')
    end
end

tmp_length = length(experiment.acquire.microdrive);

for i = 1:tmp_length
    drive_array{i} = num2str(i);
end
set(handles.microdrive_number,'String',drive_array);
set(handles.microdrive_number,'Value',1);




set(handles.microdrive_name,'String',experiment.hardware.microdrive(1).name);
set(handles.microdrive_type,'String',microdrive_type);
set(handles.microdrive_type,'Value',find(ismember(microdrive_type,experiment.hardware.microdrive(1).type)));



tmp_length = length(experiment.hardware.microdrive(1).electrodes);
for i = 1:tmp_length
    electrode_array{i} = num2str(i);
end
set(handles.electrode_number,'String',electrode_array);
set(handles.electrode_number,'Value',1);

set(handles.electrode_motorid,'String',experiment.hardware.microdrive(1).electrodes(1).motorid);
set(handles.electrode_group,'String',experiment.hardware.microdrive(1).electrodes(1).motorgroupid);
set(handles.electrode_acquisitionid,'String',experiment.hardware.microdrive(1).electrodes(1).acquisitionid);
set(handles.electrode_channel,'String',experiment.hardware.microdrive(1).electrodes(1).channelid);
set(handles.electrode_label,'String',experiment.hardware.microdrive(1).electrodes(1).label);
set(handles.electrode_type,'String',electrode_type);
set(handles.electrode_type,'Value',find(ismember(electrode_type,experiment.hardware.microdrive(1).electrodes(1).type)));



if(experiment.acquire.microdrive(1).pitch.available == 0)
    set(handles.microdrive_pitch,'Visible','off');
    set(handles.Pitch_Label,'Visible','off');
else
    set(handles.microdrive_pitch,'Visible','on');
    set(handles.Pitch_Label,'Visible','on');   
    set(handles.microdrive_pitch,'String',experiment.hardware.microdrive(1).coordinate.pitch);
end
if(experiment.acquire.microdrive(1).yaw.available == 0)
    set(handles.microdrive_yaw,'Visible','off');
    set(handles.Yaw_Label,'Visible','off');
else
    set(handles.microdrive_yaw,'Visible','on');
    set(handles.Yaw_Label,'Visible','on');   
    set(handles.microdrive_yaw,'String',experiment.hardware.microdrive(1).coordinate.yaw);
end
if(experiment.acquire.microdrive(1).x.available == 0)
    set(handles.microdrive_x,'Visible','off');
    set(handles.X_Label,'Visible','off');
else
    set(handles.microdrive_x,'Visible','on');
    set(handles.X_Label,'Visible','on');   
    set(handles.microdrive_x,'String',experiment.hardware.microdrive(1).coordinate.x);
end
if(experiment.acquire.microdrive(1).y.available == 0)
    set(handles.microdrive_y,'Visible','off');
    set(handles.Y_Label,'Visible','off');
else
    set(handles.microdrive_y,'Visible','on');
    set(handles.Y_Label,'Visible','on');   
    set(handles.microdrive_y,'String',experiment.hardware.microdrive(1).coordinate.y);
end


if(experiment.acquire.microdrive(1).electrodes(1).gain.available == 0)
    set(handles.electrode_gain,'Visible','off');
    set(handles.Gain_Label,'Visible','off');
else
    set(handles.electrode_gain,'Visible','on');
    set(handles.Gain_Label,'Visible','on');   
    set(handles.electrode_gain,'String',experiment.hardware.microdrive(1).electrodes(1).gain);
end

% if(experiment.acquire.gain(1).available == 0)
%     set(handles.stGain1,'Visible','off');
%     set(handles.edGain1,'Visible','off');
% end
% if(experiment.acquire.gain(2).available == 0)
%     set(handles.stGain2,'Visible','off');
%     set(handles.edGain2,'Visible','off');
% end
% if(experiment.acquire.gain(3).available == 0)
%     set(handles.stGain3,'Visible','off');
%     set(handles.edGain3,'Visible','off');
% end
% if(experiment.acquire.gain(4).available == 0)
%     set(handles.stGain4,'Visible','off');
%     set(handles.edGain4,'Visible','off');
% end
% if(experiment.acquire.gain(5).available == 0)
%     set(handles.stGain5,'Visible','off');
%     set(handles.edGain5,'Visible','off');
% end
% if(experiment.acquire.gain(6).available == 0)
%     set(handles.stGain6,'Visible','off');
%     set(handles.edGain6,'Visible','off');
% end
% if(experiment.acquire.gain(7).available == 0)
%     set(handles.stGain7,'Visible','off');
%     set(handles.edGain7,'Visible','off');
% end
% if(experiment.acquire.gain(8).available == 0)
%     set(handles.stGain8,'Visible','off');
%     set(handles.edGain8,'Visible','off');
% end




% set(handles.popTestGain,'String',{'100','1000','10000'});
% set(handles.popTestGain,'Value',2);
