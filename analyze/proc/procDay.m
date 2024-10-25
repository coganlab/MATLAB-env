function procDay(day,startOn,rec)
%
%  procDay(day, startOn)
%
%   Inputs:  DAY = String.  Recording day.  For example '080926';
%
% StartOn specifies which step of procDay to begin with (can be used to
% complete a procDay that was interrupted by an error.)  See
% procErrorLog.txt in the day folder for error description.  Steps are :
% 
      

global MONKEYDIR
olddir = pwd;
load([MONKEYDIR '/mat/prototype.experiment.mat']);
if isfield(experiment.recording,'machine'); RECMACHINE = experiment.recording.machine; else RECMACHINE = ''; end
if ~isfield(experiment.recording,'species'); experiment.recording.species = 'Macaca'; end % backwards compatibility
base_dir = experiment.recording.base_path
if strcmp(experiment.recording.species,'Macaca') %% Monkey
    if ~isempty(RECMACHINE) 
        try
            disp('Copying day folder to raid drive.  This might take a while.');
            unix(['rsync --progress -rxvtzl ' RECMACHINE ':' base_dir '/' day ' ' MONKEYDIR '/'],'-echo'); % rsync data from the rig's dacq machine
            unix(['chown bijanadmin:bijanadmin ' MONKEYDIR '/' day]);
            disp([MONKEYDIR '/' day ' ownership set'])
        catch
            disp('failed to copy recording folder:')
            disp(lasterror.message);
            return;
        end
    end
elseif strcmp(experiment.recording.species,'Homo') %% Human
    % set up analyze style data directory
    ft=experiment.recording.rawfiletype;
    
    direc = dir(sprintf('%s/20%s*',base_dir,day));
    files = dir(sprintf('%s/%s/*.%s',base_dir,direc(1).name,ft)); % number of raw files
    for ifile = 1:numel(files)
        rec_dir = sprintf('%s/%s/%03d/',MONKEYDIR,day,ifile); % create a recording directory for every ns5 raw file
        mkdir(rec_dir)
        unix(sprintf('rsync --progress -rxvtzl %s/%s/%s %srec%03d.%s',base_dir,direc(1).name,files(ifile).name,rec_dir,ifile,ft),'-echo'); % rsync data from dacq machine
        unix(sprintf('rsync --progress -rxvtzl %s/%s/%s.nev %srec%03d.nev',base_dir,direc(1).name,files(ifile).name(1:end-4), rec_dir,ifile),'-echo'); % rsync data from dacq machine
        save(sprintf('%srec%03d.experiment.mat',rec_dir,ifile),'experiment') % create recording specific experiment.mat
        Rec = createRec(files(ifile).name,day,ifile,experiment);
        save(sprintf('%srec%03d.Rec.mat',rec_dir,ifile),'Rec') % create recording specific Rec.mat
    end
    unix(['chown bijanadmin:bijanadmin ' MONKEYDIR '/' day]);
    disp([MONKEYDIR '/' day ' ownership set'])
end


if nargin < 2 || startOn > 14 || startOn < 1
    startOn = 1;
end

recs = dayrecs(day);

load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat'])

stuffToDo = experiment.software.analyze;
disp('The following processing steps will be run:')
disp(char(stuffToDo));
%pause(10);
for i=startOn:length(stuffToDo)
    if nargin < 3
        try
            feval(stuffToDo{i},day);
        catch
            log = 'ERROR!\nSucceeded on the following steps:';
            if(i>1)
                for j=1:i-1;
                    log = [log  '\n' stuffToDo{j}];
                end
            end
            err = lasterror;
            log = [log '\nFailed on step ' stuffToDo{i} ' for reason:\n' err.message];

            s = err.stack;
            for j=1:length(s);
                log = [log '\n ...in ' s(j).name];
                log = [log '\n' s(j).file];
                log = [log '\n...at line ' num2str(s(j).line)];
            end

            fid = fopen([MONKEYDIR '/' day '/procErrorLog.txt'],'w');
            msg = sprintf(log);
            fwrite(fid,msg);
            fclose(fid);
            disp(msg);
            disp('Log saved.  Aborting.');
            cd(olddir);
            return;
        end
    else
        try
            feval(stuffToDo{i},day,rec);
        catch
            log = 'ERROR!\nSucceeded on the following steps:';
            if(i>1)
                for j=1:i-1;
                    log = [log  '\n' stuffToDo{j}];
                end
            end
            err = lasterror;
            log = [log '\nFailed on step ' stuffToDo{i} ' for reason:\n' err.message];

            s = err.stack;
            for j=1:length(s);
                log = [log '\n ...in ' s(j).name];
                log = [log '\n' s(j).file];
                log = [log '\n...at line ' num2str(s(j).line)];
            end

            fid = fopen([MONKEYDIR '/' day '/procErrorLog.txt'],'w');
            msg = sprintf(log);
            fwrite(fid,msg);
            fclose(fid);
            disp(msg);
            disp('Log saved.  Aborting.');
            cd(olddir);
            return;
        end
    end
    cd(olddir);
end



% delFiles(day);  In the past, when I automatically deleted files I deleted entire recording days
%                   by accident.  I think delFiles should be done manually unless there is
%                   a procedure for automatically determining that the preprocessing was successful.
