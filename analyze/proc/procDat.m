function procDat(day, rec)
%  PROCDAT processes DAT file to give RAW,HND,EYE, STIM files
%
%  PROCDAT(DAY, REC, NSPIKECH)
%

global MONKEYDIR
disp('In procDat')
olddir = pwd;
Dir1 = dir([MONKEYDIR '/' day '/0*']);
Dir2 = dir([MONKEYDIR '/' day '/1*']);

tmp = [Dir1;Dir2];
%tmp = dir([MONKEYDIR '/' day '/0*']);
[recs{1:length(tmp)}] = deal(tmp.name);
nRecs = length(recs);
COMEDICH = 8; %%%%%%%%%%% Needs to be taken from the exp def file
recs;

if nargin < 2 || isempty(rec)
    num = [1,nRecs];
elseif ischar(rec)
    num = [find(strcmp(recs,rec)),find(strcmp(recs,rec))];
elseif length(rec)==1
    num = [rec,rec];
else
    num = rec;
end
for iRec = num(1):num(2)
    cd([MONKEYDIR '/' day '/' recs{iRec}]);
    load(['rec' recs{iRec} '.experiment.mat']);
    switch experiment.hardware.acquisition(1).type
        case 'nstream'
            Comedi = dir(['rec' recs{iRec} '.comedi.dat']);
            Nspike = [];
            delta = [];
            % if isfile(['rec' recs{iRec} '.nspike.dat'])
            %     Nspike = dir(['rec' recs{iRec} '.nspike.dat']);
            %     delta = Comedi.bytes./2./COMEDICH./3e4 - Nspike.bytes./2./256./3e4;
            %     disp(['Delta between Comedi and nspike is ' num2str(delta)])
            % end
            if (~isempty(delta) && abs(delta) < 1000000) || isempty(Nspike)
                if ~isfile(['rec' recs{iRec} '.hnd.dat']) && isfile(['rec' recs{iRec} '.Rec.mat'])
                    disp('Processing comedi dat files')
                    disp(['Running comedi_preproc on ' MONKEYDIR '/' day '/' recs{iRec}]);
                    eval(['!' MONKEYDIR '/' day '/C/NSpike/nstream/current_version/pkg/bin/comedi_preproc < rec' recs{iRec} '.comedi.dat']);
                    eval(['!mv file.ev.txt rec' recs{iRec} '.ev.txt']);
                    eval(['!mv file.eye.dat rec' recs{iRec} '.eye.dat']);
                    eval(['!mv file.hnd.dat rec' recs{iRec} '.hnd.dat']);
                    eval(['!mv file.joy.dat rec' recs{iRec} '.joy.dat']);
                    eval(['!mv file.display.dat rec' recs{iRec} '.display.dat']);
                    eval(['!mv file.state.dat rec' recs{iRec} '.state.dat']);
                elseif ~isfile(['rec' recs{iRec} '.comedi.dat'])
                    disp(['No Comedi file found.  Cannot process.'])
                end
                proc_raw_file_exists = 0;
                for j = 1:length(experiment.hardware.microdrive)
                    if isfile(['rec' recs{iRec} '.' experiment.hardware.microdrive(j).name '.raw.dat'])
                        display(['rec' recs{iRec} '.' experiment.hardware.microdrive(j).name '.raw.dat already processed']);
                        proc_raw_file_exists = 1;
                    end
                end
                if ~proc_raw_file_exists
                    if ~isempty(Nspike)
                        disp('Processing nspike dat files')
                        disp(['Running preprocNspike on ' MONKEYDIR '/' day '/' recs{iRec}]);
                        preprocNspike(recs{iRec}, experiment);
                        %                         for j = 1:length(experiment.hardware.microdrive)
                        %                             eval(['!mv file.raw1.dat rec' recs{iRec} '.' experiment.hardware.microdrive(j).name '.raw.dat']);
                        %                         end
                    end
                elseif ~isfile(['rec' recs{iRec} '.nspike.dat'])
                    disp(['No NSpike file found.  Cannot process.'])
                end
            else
                disp(['WARNING: ' recs{iRec} ' ' day ' Comedi and NSpike files differ in length by more than 1 second'])
                disp(['Moving ' recs{iRec} ' to s' recs{iRec}]);
                unix(['mv '  MONKEYDIR '/' day '/' recs{iRec} ' '  MONKEYDIR '/' day '/s' recs{iRec}]);
            end
        case 'nstream_64'
            Comedi = dir(['rec' recs{iRec} '.comedi.dat']);
            Nspike = [];
            delta = [];
            if isfile(['rec' recs{iRec} '.nspike.dat'])
                Nspike = dir(['rec' recs{iRec} '.nspike.dat']);
                delta = Comedi.bytes./2./COMEDICH./3e4 - Nspike.bytes./2./64./3e4;
                disp(['Delta between Comedi and nspike is ' num2str(delta)])
            end
            if (~isempty(delta) && abs(delta) < 1000000) || isempty(Nspike)
                if ~isfile(['rec' recs{iRec} '.hnd.dat']) && isfile(['rec' recs{iRec} '.Rec.mat'])
                    disp('Processing comedi dat files')
                    disp(['Running comedi_preproc on ' MONKEYDIR '/' day '/' recs{iRec}]);
                    eval(['!' MONKEYDIR '/' day '/C/NSpike/nstream_64/current_version/pkg/bin/comedi_preproc < rec' recs{iRec} '.comedi.dat']);
                    eval(['!mv file.ev.txt rec' recs{iRec} '.ev.txt']);
                    eval(['!mv file.eye.dat rec' recs{iRec} '.eye.dat']);
                    eval(['!mv file.hnd.dat rec' recs{iRec} '.hnd.dat']);
                    eval(['!mv file.mocap.dat rec' recs{iRec} '.mocap.dat']);
                    eval(['!mv file.display.dat rec' recs{iRec} '.display.dat']);
                    eval(['!mv file.state.dat rec' recs{iRec} '.state.dat']);
                elseif ~isfile(['rec' recs{iRec} '.comedi.dat'])
                    disp(['No Comedi file found.  Cannot process.'])
                end
                proc_raw_file_exists = 0;
                for j = 1:length(experiment.hardware.microdrive)
                    if isfile(['rec' recs{iRec} '.' experiment.hardware.microdrive(j).name '.raw.dat'])
                        display(['rec' recs{iRec} '.' experiment.hardware.microdrive(j).name '.raw.dat already processed']);
                        proc_raw_file_exists = 1;
                    end
                end
                if ~proc_raw_file_exists
                    
                    if ~isempty(Nspike)
                        disp('Processing nspike dat files')
                        disp(['Running preprocNspike64 on ' MONKEYDIR '/' day '/' recs{iRec}]);
                        preprocNspike64(recs{iRec}, experiment);
                    end
                elseif ~isfile(['rec' recs{iRec} '.nspike.dat'])
                    disp(['No NSpike file found.  Cannot process.'])
                end
                
            else
                disp(['WARNING: ' recs{iRec} ' ' day ' Comedi and NSpike files differ in length by more than 1 second'])
                disp(['Moving ' recs{iRec} ' to s' recs{iRec}]);
                unix(['mv '  MONKEYDIR '/' day '/' recs{iRec} ' '  MONKEYDIR '/' day '/s' recs{iRec}]);
            end
        case 'nstream_32'
            Comedi = dir(['rec' recs{iRec} '.comedi.dat']);
            Nspike = [];
            delta = [];
            if isfile(['rec' recs{iRec} '.nspike.dat'])
                Nspike = dir(['rec' recs{iRec} '.nspike.dat']);
                delta = Comedi.bytes./2./COMEDICH./3e4 - Nspike.bytes./2./32./3e4;
                disp(['Delta between Comedi and nspike is ' num2str(delta)])
            end
            if (~isempty(delta) && abs(delta) < 1000000) || isempty(Nspike)
                if ~isfile(['rec' recs{iRec} '.hnd.dat']) && isfile(['rec' recs{iRec} '.Rec.mat'])
                    disp('Processing comedi dat files')
                    disp(['Running comedi_preproc on ' MONKEYDIR '/' day '/' recs{iRec}]);
                    eval(['!' MONKEYDIR '/' day '/C/NSpike/nstream_32/current_version/pkg/bin/comedi_preproc < rec' recs{iRec} '.comedi.dat']);
                    eval(['!mv file.ev.txt rec' recs{iRec} '.ev.txt']);
                    eval(['!mv file.eye.dat rec' recs{iRec} '.eye.dat']);
                    eval(['!mv file.hnd.dat rec' recs{iRec} '.hnd.dat']);
                    eval(['!mv file.mocap.dat rec' recs{iRec} '.mocap.dat']);
                    eval(['!mv file.display.dat rec' recs{iRec} '.display.dat']);
                    eval(['!mv file.state.dat rec' recs{iRec} '.state.dat']);
                elseif ~isfile(['rec' recs{iRec} '.comedi.dat'])
                    disp(['No Comedi file found.  Cannot process.'])
                end
                proc_raw_file_exists = 0;
                for j = 1:length(experiment.hardware.microdrive)
                    if isfile(['rec' recs{iRec} '.' experiment.hardware.microdrive(j).name '.raw.dat'])
                        display(['rec' recs{iRec} '.' experiment.hardware.microdrive(j).name '.raw.dat already processed']);
                        proc_raw_file_exists = 1;
                    end
                end
                if ~proc_raw_file_exists
                    
                    if ~isempty(Nspike)
                        disp('Processing nspike dat files')
                        disp(['Running preprocNspike32 on ' MONKEYDIR '/' day '/' recs{iRec}]);
                        preprocNspike32(recs{iRec}, experiment);
                        %                         for j = 1:length(experiment.hardware.microdrive)
                        %                             eval(['!mv file.raw1.dat rec' recs{iRec} '.' experiment.hardware.microdrive(j).name '.raw.dat']);
                        %                         end
                    end
                elseif ~isfile(['rec' recs{iRec} '.nspike.dat'])
                    disp(['No NSpike file found.  Cannot process.'])
                end
                
            else
                disp(['WARNING: ' recs{iRec} ' ' day ' Comedi and NSpike files differ in length by more than 1 second'])
                disp(['Moving ' recs{iRec} ' to s' recs{iRec}]);
                unix(['mv '  MONKEYDIR '/' day '/' recs{iRec} ' '  MONKEYDIR '/' day '/s' recs{iRec}]);
            end
        case 'nstream128_32'
            Comedi = dir(['rec' recs{iRec} '.comedi.dat']);
            Nspike = [];
            delta = [];
            if isfile(['rec' recs{iRec} '.nspike.dat'])
                Nspike = dir(['rec' recs{iRec} '.nspike.dat']);
                delta = Comedi.bytes./2./COMEDICH./3e4 - Nspike.bytes./2./32./3e4;
                disp(['Delta between Comedi and nspike is ' num2str(delta)])
            end
            if (~isempty(delta) && abs(delta) < 1000000) || isempty(Nspike)
                if ~isfile(['rec' recs{iRec} '.hnd.dat']) && isfile(['rec' recs{iRec} '.Rec.mat'])
                    disp('Processing comedi dat files')
                    disp(['Running comedi_preproc on ' MONKEYDIR '/' day '/' recs{iRec}]);
                    % need to do something for phasespace
                    eval(['!' MONKEYDIR '/' day '/C/NSpike/nstream/current_version/pkg/bin/comedi_preproc < rec' recs{iRec} '.comedi.dat'])
                    eval(['!mv file.ev.txt rec' recs{iRec} '.ev.txt']);
                    eval(['!mv file.eye.dat rec' recs{iRec} '.eye.dat']);
                    eval(['!mv file.hnd.dat rec' recs{iRec} '.hnd.dat']);
                    eval(['!mv file.strobe.dat rec' recs{iRec} '.strobe.dat']);
                    eval(['!mv file.timecode.dat rec' recs{iRec} '.timecode.dat']);
                    eval(['!mv file.display.dat rec' recs{iRec} '.display.dat']);
                    eval(['!mv file.state.dat rec' recs{iRec} '.state.dat']);
                elseif ~isfile(['rec' recs{iRec} '.comedi.dat'])
                    disp(['No Comedi file found.  Cannot process.'])
                end
                proc_raw_file_exists = 0;
                for j = 1:length(experiment.hardware.microdrive)
                    if isfile(['rec' recs{iRec} '.' experiment.hardware.microdrive(j).name '.raw.dat'])
                        display(['rec' recs{iRec} '.' experiment.hardware.microdrive(j).name '.raw.dat already processed']);
                        proc_raw_file_exists = 1;
                    end
                end
                if ~proc_raw_file_exists
                    if ~isempty(Nspike)
                        disp('Processing nspike dat files')
                        disp(['Running preprocNspike on ' MONKEYDIR '/' day '/' recs{iRec}]);
                        preprocNspike128_32(recs{iRec}, experiment);
                    end
                elseif ~isfile(['rec' recs{iRec} '.nspike.dat'])
                    disp(['No NSpike file found.  Cannot process.'])
                end
            else
                disp(['WARNING: ' recs{iRec} ' ' day ' Comedi and NSpike files differ in length by more than 1 second'])
                disp(['Moving ' recs{iRec} ' to s' recs{iRec}]);
                unix(['mv '  MONKEYDIR '/' day '/' recs{iRec} ' '  MONKEYDIR '/' day '/s' recs{iRec}]);
            end
        case {'nstream_128'}
            Comedi = dir(['rec' recs{iRec} '.comedi.dat']);
            Nspike = [];
            delta = [];
            if isfile(['rec' recs{iRec} '.nspike.dat'])
                Nspike = dir(['rec' recs{iRec} '.nspike.dat']);
                delta = Comedi.bytes./2./COMEDICH./3e4 - Nspike.bytes./2./128./3e4;
                disp(['Delta between Comedi and nspike is ' num2str(delta)])
            end
            
            if (~isempty(delta) && abs(delta) < 1000000) || isempty(Nspike)
                if ~isfile(['rec' recs{iRec} '.hnd.dat']) && isfile(['rec' recs{iRec} '.Rec.mat'])
                    disp('Processing comedi dat files')
                    disp(['Running comedi_preproc on ' MONKEYDIR '/' day '/' recs{iRec}]);
                    % need to do something for phasespace
                    eval(['!' MONKEYDIR '/' day '/C/NSpike/nstream_128/current_version/pkg/bin/comedi_preproc < rec' recs{iRec} '.comedi.dat'])
                    
                    eval(['!mv file.ev.txt rec' recs{iRec} '.ev.txt']);
                    eval(['!mv file.eye.dat rec' recs{iRec} '.eye.dat']);
                    eval(['!mv file.hnd.dat rec' recs{iRec} '.hnd.dat']);
                    eval(['!mv file.joy.dat rec' recs{iRec} '.joy.dat']);
                    eval(['!mv file.display.dat rec' recs{iRec} '.display.dat']);
                    eval(['!mv file.state.dat rec' recs{iRec} '.state.dat']);
                elseif ~isfile(['rec' recs{iRec} '.comedi.dat'])
                    disp(['No Comedi file found.  Cannot process.'])
                end
                proc_raw_file_exists = 0;
                for j = 1:length(experiment.hardware.microdrive)
                    if isfile(['rec' recs{iRec} '.' experiment.hardware.microdrive(j).name '.raw.dat'])
                        display(['rec' recs{iRec} '.' experiment.hardware.microdrive(j).name '.raw.dat already processed']);
                        proc_raw_file_exists = 1;
                    end
                end
                if ~proc_raw_file_exists
                    if ~isempty(Nspike)
                        disp('Processing nspike dat files')
                        disp(['Running preprocNspike on ' MONKEYDIR '/' day '/' recs{iRec}]);
                        preprocNspike128(recs{iRec}, experiment);
                    end
                elseif ~isfile(['rec' recs{iRec} '.nspike.dat'])
                    disp(['No NSpike file found.  Cannot process.'])
                end
            else
                disp(['WARNING: ' recs{iRec} ' ' day ' Comedi and NSpike files differ in length by more than 1 second'])
                disp(['Moving ' recs{iRec} ' to s' recs{iRec}]);
                unix(['mv '  MONKEYDIR '/' day '/' recs{iRec} ' '  MONKEYDIR '/' day '/s' recs{iRec}]);
            end
        case {'nstream_256'}
            Comedi = dir(['rec' recs{iRec} '.comedi.dat']);
            Nspike = [];
            delta = [];
            if isfile(['rec' recs{iRec} '.nspike.dat'])
                Nspike = dir(['rec' recs{iRec} '.nspike.dat']);
                delta = Comedi.bytes./2./COMEDICH./3e4 - Nspike.bytes./2./256./3e4;
                disp(['Delta between Comedi and nspike is ' num2str(delta)])
            end
            if (~isempty(delta) && abs(delta) < 1000000) || isempty(Nspike)
                if ~isfile(['rec' recs{iRec} '.hnd.dat']) && isfile(['rec' recs{iRec} '.Rec.mat'])
                    disp('Processing comedi dat files')
                    disp(['Running comedi_preproc on ' MONKEYDIR '/' day '/' recs{iRec}]);
                    % need to do something for phasespace
                    eval(['!' MONKEYDIR '/' day '/C/NSpike/nstream_256/pkg/bin/comedi_preproc < rec' recs{iRec} '.comedi.dat'])
                    eval(['!mv file.ev.txt rec' recs{iRec} '.ev.txt']);
                    eval(['!mv file.eye.dat rec' recs{iRec} '.eye.dat']);
                    eval(['!mv file.hnd.dat rec' recs{iRec} '.hnd.dat']);
                    eval(['!mv file.mocap.dat rec' recs{iRec} '.mocap.dat']);
                    eval(['!mv file.audiosync.dat rec' recs{iRec} '.reward.dat']);
                    eval(['!mv file.state.dat rec' recs{iRec} '.state.dat']);
                elseif ~isfile(['rec' recs{iRec} '.comedi.dat'])
                    disp(['No Comedi file found.  Cannot process.'])
                end
                proc_raw_file_exists = 0;
                for j = 1:length(experiment.hardware.microdrive)
                    if isfile(['rec' recs{iRec} '.' experiment.hardware.microdrive(j).name '.raw.dat'])
                        display(['rec' recs{iRec} '.' experiment.hardware.microdrive(j).name '.raw.dat already processed']);
                        proc_raw_file_exists = 1;
                    end
                end
                if ~proc_raw_file_exists
                    if ~isempty(Nspike)
                        disp('Processing nspike dat files')
                        disp(['Running preprocNspike256 on ' MONKEYDIR '/' day '/' recs{iRec}]);
                        preprocNspike256(recs{iRec}, experiment);
                    end
                elseif ~isfile(['rec' recs{iRec} '.nspike.dat'])
                    disp(['No NSpike file found.  Cannot process.'])
                end
            else
                disp(['WARNING: ' recs{iRec} ' ' day ' Comedi and NSpike files differ in length by more than 1 second'])
                disp(['Moving ' recs{iRec} ' to s' recs{iRec}]);
                unix(['mv '  MONKEYDIR '/' day '/' recs{iRec} ' '  MONKEYDIR '/' day '/s' recs{iRec}]);
            end
        case 'NI'
            if ~isfile(['rec' recs{iRec} '.dat'])
                cmdstr = ['convertDaqtoDat(''rec' recs{iRec} '.daq'',''rec' recs{iRec} '.dat'',10)']
                eval(cmdstr)
            end
            
            if strcmp(experiment.recording.type,'Recording')
                Raw = [];
                if isfile(['rec' recs{iRec} '.dat'])
                    Raw = dir(['rec' recs{iRec} '.dat']);
                end
                proc_raw_file_exists = 0;
                for j = 1:length(experiment.hardware.microdrive)
                    if isfile(['rec' recs{iRec} '.' experiment.hardware.microdrive(j).name '.raw.dat'])
                        display(['rec' recs{iRec} '.' experiment.hardware.microdrive(j).name '.raw.dat already processed']);
                        proc_raw_file_exists = 1;
                    end
                end
                if ~proc_raw_file_exists
                    if ~isempty(Raw)
                        disp('Processing Matlab dat files')
                        disp(['Running preprocMatlab on ' MONKEYDIR '/' day '/' recs{iRec}]);
                        preprocLaser(recs{iRec}, experiment);
                    end
                elseif ~isfile(['rec' recs{iRec} '.raw.dat'])
                    disp(['No raw file found.  Cannot process.'])
                end
            end
            
        case {'nstream_rig2_256_256'}
            Comedi = dir(['rec' recs{iRec} '.comedi.dat']);
            Nspike = [];
            delta = [];
            if isfile(['rec' recs{iRec} '.nspike.dat'])
                Nspike = dir(['rec' recs{iRec} '.nspike.dat']);
                delta = Comedi.bytes./2./COMEDICH./3e4 - Nspike.bytes./2./256./3e4;
                disp(['Delta between Comedi and nspike is ' num2str(delta)])
            end
            if (~isempty(delta) && abs(delta) < 1000000) || isempty(Nspike)
                if ~isfile(['rec' recs{iRec} '.hnd.dat']) && isfile(['rec' recs{iRec} '.Rec.mat'])
                    disp('Processing comedi dat files')
                    disp(['Running comedi_preproc on ' MONKEYDIR '/' day '/' recs{iRec}]);
                    % need to do something for phasespace
                    eval(['!' MONKEYDIR '/' day '/C/NSpike/nstream_256/pkg/bin/comedi_preproc < rec' recs{iRec} '.comedi.dat'])
                    eval(['!mv file.ev.txt rec' recs{iRec} '.ev.txt']);
                    eval(['!mv file.eye.dat rec' recs{iRec} '.eye.dat']);
                    eval(['!mv file.hnd.dat rec' recs{iRec} '.hnd.dat']);
                    eval(['!mv file.mocap.dat rec' recs{iRec} '.mocap.dat']);
                    eval(['!mv file.audiosync.dat rec' recs{iRec} '.reward.dat']);
                    eval(['!mv file.state.dat rec' recs{iRec} '.state.dat']);
                elseif ~isfile(['rec' recs{iRec} '.comedi.dat'])
                    disp(['No Comedi file found.  Cannot process.'])
                end
                proc_raw_file_exists = 0;
                for j = 1:length(experiment.hardware.microdrive)
                    if isfile(['rec' recs{iRec} '.' experiment.hardware.microdrive(j).name '.raw.dat'])
                        display(['rec' recs{iRec} '.' experiment.hardware.microdrive(j).name '.raw.dat already processed']);
                        proc_raw_file_exists = 1;
                    end
                end
                if ~proc_raw_file_exists
                    if ~isempty(Nspike)
                        disp('Processing nspike dat files')
                        disp(['Running preprocNspike256_256 on ' MONKEYDIR '/' day '/' recs{iRec}]);
                        preprocNspike256_256(recs{iRec}, experiment);
                    end
                elseif ~isfile(['rec' recs{iRec} '.nspike.dat'])
                    disp(['No NSpike file found.  Cannot process.'])
                end
            else
                disp(['WARNING: ' recs{iRec} ' ' day ' Comedi and NSpike files differ in length by more than 1 second'])
                disp(['Moving ' recs{iRec} ' to s' recs{iRec}]);
                unix(['mv '  MONKEYDIR '/' day '/' recs{iRec} ' '  MONKEYDIR '/' day '/s' recs{iRec}]);
            end
        case {'Broker','Laminar_Broker','Si32_Broker'}
            disp(['Processing ' experiment.hardware.acquisition(1).type]);
            
            % engine path is used by acquire machine to reference software
            % in /mnt/raid. This path may not be available on data storage
            % machine.
            %             path_index = strfind(experiment.software.engine.path, '/');
            %             pipe_path = [experiment.software.engine.path(1:path_index(end)) 'pipe_preproc'];
            
            pipe_path = [MONKEYDIR '/' day '/C/current_version/pipe_preproc'];
            if ~isfile(['rec' recs{iRec} '.hnd.dat']) && isfile(['rec' recs{iRec} '.Rec.mat'])
                disp('Processing dat files')
                unix([ pipe_path ' < rec' recs{iRec} '.dat']);
                if(isfile('file.ev.txt'))
                    unix(['mv file.ev.txt rec' recs{iRec} '.ev.txt']);
                end
                if(isfile('file.eye.dat'))
                    unix(['mv file.eye.dat rec' recs{iRec} '.eye.dat']);
                end
                if(isfile('file.hnd.dat'))
                    unix(['mv file.hnd.dat rec' recs{iRec} '.hnd.dat']);
                end
                if(isfile('file.strobe.dat'))
                    unix(['mv file.strobe.dat rec' recs{iRec} '.strobe.dat']);
                end
                if(isfile('file.timecode.dat'))
                    unix(['mv file.timecode.dat rec' recs{iRec} '.timecode.dat']);
                end
                if(isfile('file.raw.dat'))
                    unix(['mv file.raw.dat rec' recs{iRec} '.raw.dat']);
                end
                if(isfile('file.display.txt'))
                    unix(['mv file.display.txt rec' recs{iRec} '.display.txt']);
                end
                if(isfile('file.display.dat'))
                    unix(['mv file.display.dat rec' recs{iRec} '.display.dat']);
                end
                if(isfile('file.state.dat'))
                    unix(['mv file.state.dat rec' recs{iRec} '.state.dat']);
                end
                if(isfile('file.mocap.dat'))
                    unix(['mv file.mocap.dat rec' recs{iRec} '.mocap.dat']);
                end
                if(isfile('file.stimpulse.dat'))
                    unix(['mv file.stimpulse.dat rec' recs{iRec} '.stimpulse.dat']);
                end
                if(isfile('file.stimraw.dat'))
                    unix(['mv file.stimraw.dat rec' recs{iRec} '.stimraw.dat']);
                end
                if(isfile('file.mocap.dat'))
                    unix(['mv file.stim.txt rec' recs{iRec} '.stim.txt']);
                end
            elseif ~isfile(['rec' recs{iRec} '.dat'])
                disp('No Comedi file found.  Cannot process.')
            else
                disp(['rec' recs{iRec} '.dat already processed'])
                
            end
            %new stuff to divide up tower data
            if strcmp(experiment.recording.type,'Recording')
                Raw = [];
                if isfile(['rec' recs{iRec} '.raw.dat'])
                    Raw = dir(['rec' recs{iRec} '.raw.dat']);
                end
                proc_raw_file_exists = 0;
                for j = 1:length(experiment.hardware.microdrive)
                    if isfile([MONKEYDIR '/' day '/' recs{iRec} '/' 'rec' recs{iRec}  '.' experiment.hardware.microdrive(j).name '.raw.dat'])
                        display(['rec' recs{iRec} '.' experiment.hardware.microdrive(j).name '.raw.dat already processed']);
                        proc_raw_file_exists = 1;
                    end
                end
                if ~proc_raw_file_exists
                    if ~isempty(Raw)
                        disp('Processing DoubleMT dat files')
                        disp(['Running preprocDoubleMT on ' MONKEYDIR '/' day '/' recs{iRec}]);
                        preprocDoubleMT(recs{iRec}, experiment);
                    end
                elseif ~isfile(['rec' recs{iRec} '.raw.dat'])
                    disp('No raw file found.  Cannot process.')
                end
            end
        case {'Broker_Blackrock'}
            disp(['Processing ' experiment.hardware.acquisition(1).type]);
            %path_index = strfind(experiment.software.engine.path, '/');
            %pipe_path = [experiment.software.engine.path(1:path_index(end)) 'pipe_preproc'];
            pipe_path = [MONKEYDIR '/' day '/C/current_version/pipe_preproc']; % added yvz 06/17/15
            
            if ~isfile(['rec' recs{iRec} '.hnd.dat']) && isfile(['rec' recs{iRec} '.Rec.mat'])
                disp('Processing dat files')
                unix([ pipe_path ' < rec' recs{iRec} '.dat']);
                if(isfile('file.ev.txt'))
                    unix(['mv file.ev.txt rec' recs{iRec} '.ev.txt']);
                end
                if(isfile('file.eye.dat'))
                    unix(['mv file.eye.dat rec' recs{iRec} '.eye.dat']);
                end
                if(isfile('file.hnd.dat'))
                    unix(['mv file.hnd.dat rec' recs{iRec} '.hnd.dat']);
                end
                if(isfile('file.strobe.dat'))
                    unix(['mv file.strobe.dat rec' recs{iRec} '.strobe.dat']);
                end
                if(isfile('file.timecode.dat'))
                    unix(['mv file.timecode.dat rec' recs{iRec} '.timecode.dat']);
                end
                if(isfile('file.raw.dat'))
                    unix(['mv file.raw.dat rec' recs{iRec} '.raw.dat']);
                end
                if(isfile('file.display.txt'))
                    unix(['mv file.display.txt rec' recs{iRec} '.display.txt']);
                end
                if(isfile('file.display.dat'))
                    unix(['mv file.display.dat rec' recs{iRec} '.display.dat']);
                end
                if(isfile('file.state.dat'))
                    unix(['mv file.state.dat rec' recs{iRec} '.state.dat']);
                end
                if(isfile('file.mocap.dat'))
                    unix(['mv file.mocap.dat rec' recs{iRec} '.mocap.dat']);
                end
                if(isfile('file.stimpulse.dat'))
                    unix(['mv file.stimpulse.dat rec' recs{iRec} '.stimpulse.dat']);
                end
                if(isfile('file.stimraw.dat'))
                    unix(['mv file.stimraw.dat rec' recs{iRec} '.stimraw.dat']);
                end
                if(isfile('file.mocap.dat'))
                    unix(['mv file.stim.txt rec' recs{iRec} '.stim.txt']);
                end
            elseif ~isfile(['rec' recs{iRec} '.dat'])
                disp('No file found.  Cannot process.')
            else
                disp(['rec' recs{iRec} '.dat already processed'])
                
            end
            %new stuff to divide up tower data
            if strcmp(experiment.recording.type,'Recording')
                Raw = [];
                if isfile(['rec' recs{iRec} '.raw.dat'])
                    Raw = dir(['rec' recs{iRec} '.raw.dat']);
                end
                proc_raw_file_exists = 0;
                for j = 1:length(experiment.hardware.microdrive)
                    if isfile([MONKEYDIR '/' day '/' recs{iRec} '/' 'rec' recs{iRec}  '.' experiment.hardware.microdrive(j).name '.raw.dat'])
                        display(['rec' recs{iRec} '.' experiment.hardware.microdrive(j).name '.raw.dat already processed']);
                        proc_raw_file_exists = 1;
                    end
                end
                if ~proc_raw_file_exists
                    if ~isempty(Raw)
                        disp('Processing Blackrock dat files')
                        disp(['Running preprocBlackrock on ' MONKEYDIR '/' day '/' recs{iRec}])
                        preprocBlackrock(day,recs{iRec}, experiment); % yvz 06/17/15 added input variable day
                        
                    end
                elseif ~isfile(['rec' recs{iRec} '.raw.dat'])
                    disp('No raw file found.  Cannot process.')
                end
            end
            
        case 'human_blackrock_cerebus'
            if strcmp(experiment.recording.type,'Recording')
                disp('Processing Blackrock dat files')
                disp(['Running preprocBlackrock on ' MONKEYDIR '/' day '/' recs{iRec}])
                preprocBlackrock(day,recs{iRec}, experiment);
            end
        otherwise
            % disp(['Processing software for acquisition hardware ' experiment.hardware.acquisition.type ' not found'])
            disp(['experiment.hardware.acquisition.type not found'])
            experiment.hardware.acquisition.type
            %             path_index = strfind(experiment.software.engine.path, '/');
            %             pipe_path = [experiment.software.engine.path(1:path_index(end)) 'pipe_preproc'];
            %
            %             if ~isfile(['rec' recs{iRec} '.hnd.dat']) && isfile(['rec' recs{iRec} '.Rec.mat'])
            %                 disp('Processing dat files')
            %                 unix([ pipe_path ' < rec' recs{iRec} '.dat']);
            %                 if(isfile('file.ev.txt'))
            %                     unix(['mv file.ev.txt rec' recs{iRec} '.ev.txt']);
            %                 end
            %                 if(isfile('file.eye.dat'))
            %                     unix(['mv file.eye.dat rec' recs{iRec} '.eye.dat']);
            %                 end
            %                 if(isfile('file.hnd.dat'))
            %                     unix(['mv file.hnd.dat rec' recs{iRec} '.hnd.dat']);
            %                 end
            %                 if(isfile('file.strobe.dat'))
            %                     unix(['mv file.strobe.dat rec' recs{iRec} '.strobe.dat']);
            %                 end
            %                 if(isfile('file.timecode.dat'))
            %                     unix(['mv file.timecode.dat rec' recs{iRec} '.timecode.dat']);
            %                 end
            %                 if(isfile('file.raw.dat'))
            %                     unix(['mv file.raw.dat rec' recs{iRec} '.raw.dat']);
            %                 end
            %                 if(isfile('file.display.txt'))
            %                     unix(['mv file.display.txt rec' recs{iRec} '.display.txt']);
            %                 end
            %                 if(isfile('file.display.dat'))
            %                     unix(['mv file.display.dat rec' recs{iRec} '.display.dat']);
            %                 end
            %                 if(isfile('file.state.dat'))
            %                     unix(['mv file.state.dat rec' recs{iRec} '.state.dat']);
            %                 end
            %             elseif ~isfile(['rec' recs{iRec} '.dat'])
            %                 disp('No Comedi file found.  Cannot process.')
            %             else
            %                 disp(['rec' recs{iRec} '.dat already processed'])
            %
            %             end
            %
            %             %new stuff to divide up tower data
            %             if strcmp(experiment.recording.type,'Recording')
            %                 Raw = [];
            %                 if isfile(['rec' recs{iRec} '.raw.dat'])
            %                     Raw = dir(['rec' recs{iRec} '.raw.dat']);
            %                 end
            %                 proc_raw_file_exists = 0;
            %                 for j = 1:length(experiment.hardware.microdrive)
            %                     if isfile([MONKEYDIR '/' day '/' recs{iRec} '/' 'rec' recs{iRec}  '.' experiment.hardware.microdrive(j).name '.raw.dat'])
            %                         display(['rec' recs{iRec} '.' experiment.hardware.microdrive(j).name '.raw.dat already processed']);
            %                         proc_raw_file_exists = 1;
            %                     end
            %                 end
            %                 if ~proc_raw_file_exists
            %                     if ~isempty(Raw)
            %                         disp('Processing DoubleMT dat files')
            %                         disp(['Running preprocDoubleMT on ' MONKEYDIR '/' day '/' recs{iRec}]);
            %                         preprocDoubleMT(recs{iRec}, experiment);
            %                     end
            %                 elseif ~isfile(['rec' recs{iRec} '.raw.dat'])
            %                     disp('No raw file found.  Cannot process.')
            %                 end
            %             end
            %
    end
end
cd(olddir);
