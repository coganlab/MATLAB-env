function outputflag = addMultiunitDatabaseTextFromField(sess)
%
%  outputflag = addMultiunitDatabaseTextFromField(sess)
%
%  This checks if session is already in Multiunit Data base
%   Inputs:   sess = Field Session
%   Outputs:  OUTPUTFLAG = 0/1.  1 = Changed Multiunit database.
%                                0 = Unchanged
%
%  Initialization is wonky.

global MONKEYDIR MONKEYNAME

SessionType = 'Multiunit';

if(~strcmp(sessType(sess),'Field'))
    outputflag = 0;
    disp('Session is not a field session')
    return;
end

Session = loadMultiunit_Database;
length(Session)
% cmdstr = ['cd ' MONKEYDIR '/m'];
% eval(cmdstr)
% Session = Multiunit_Database;
%Session
%pause
day = sessDay(sess);
if(iscell(day))
    day = day{1};
end

ch = sessElectrode(sess);
contact = sessContact(sess);
if(iscell(contact))
    contact = contact{1};
end
tower = sessTower(sess);
if(iscell(tower))
    tower = tower{1};
end
rec = sessRec(sess);
depth = sessDepthField(sess);
if(~isempty(Session))
    Days = sessDay(Session);
    Channels = sessElectrode(Session);
     Contacts = sessContact(Session);
%Contacts=sessContact(sess);
    Towers = sessTower(Session);
    Recs = sessRec(Session);
    Depth = sessDepthField(Session);
    
    outputflag = 1;
    if ~isempty(find(strcmp(Days,day),1))
        DayInd = find(strcmp(Days,day));
        if ~isempty(find(strcmp(Towers(DayInd), tower),1))
            TowerInd = find(strcmp(Towers(DayInd), tower));
            if ~isempty(find(intersect(Channels(DayInd(TowerInd)),ch),1))
                ChannelInd = find((Channels(DayInd(TowerInd))==ch));
                if ~isempty(find(intersect(Channels(DayInd(TowerInd(ChannelInd))),contact),1))
                    ContactInd = find((cell2num(Contacts(DayInd(TowerInd(ChannelInd))))==(contact)));
                    r = Recs(DayInd(TowerInd(ChannelInd(ContactInd))));
                    clear R rec_ind;
                    d = Depth(DayInd(TowerInd(ChannelInd(ContactInd))),:);
                    if(~isempty(d))
                        for iDepth = 1:size(d,1)
                            if(d(iDepth,1) == depth(1))
                                outputflag = 0;
                                disp('Already in Multiunit Database')
                            end
                        end
                    end
                end
            end
        end
    end
else
    outputflag = 1;
end

if outputflag == 1  %  Not in Multiunit Database.  Add.
    %Trials = sessTrials(sess);
    %if(~isempty(Trials))
    % Set to one for now
    min_AP_threshold = 1;
    % Calculate the AP threshold
    
    sys = sessTower(sess);
    recs = sessRec(sess);
    nRecs = length(recs);
    if(iscell(sys))
        sys = sys{1};
    end
    
    for iRecs = 1:nRecs
        rec = recs{iRecs}
        if exist([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.sp.mat']);
        load([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.sp.mat']);
        else
            procSp(day,ch,rec);
        end
        if exist([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.pk.mat'])
        load([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.pk.mat']);
        else
            disp('Pk file missing')
            disp('Creating pk file with makePk');
            makePk(day, rec);
            disp('Loading pk file')
            load([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.pk.mat']);
        end
        if exist([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat'])
            load([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat']);
            mtch = expChannelIndex(experiment,sys,ch,contact);
        else
            mtch = ch;
        end
        if exist([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.clu.mat'])
            load([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.clu.mat']);
        else
            disp('Clu file missing')
            disp('Creating clu file with makeClu');
            makeClu(day, rec, sys);
            disp('Loading clu file')
            load([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.clu.mat']);
        end
        
        if(iscell(mtch))
            mtch = mtch{1};
        end
        
%         if isempty(clu{mtch}) && isempty(pk{mtch}) %added by Josh
%             clu{mtch}(:,1)=NaN;
%             pk{mtch}(:,1)=NaN;
%         end %added by Josh

%                   or


     if isempty(pk{mtch}) %&& isempty(clu{mtch}) %added by Josh
%               if mtch<length(pk)
         %mtch=mtch+1
         pk{mtch}=NaN(1,2);
%               else if mtch=length(pk) && sys
           end %added by Josh  

         if isempty(clu{mtch}) %&& ~isempty(pk{mtch})
            clu{mtch}(:,1) = pk{mtch}(:,1);
            clu{mtch}(:,2) = 1;
            save([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.clu.mat'],'clu')
        end
        
        % Finding multiunit spikes
        clu1ind = find(clu{mtch}(:,2) == 1);
        if ~(size(pk{mtch},1) == size(clu{mtch},1)) %If all clusters are 1, just resize
            disp('Fixing clu = missing spikes');
            fixClu(day, rec, sys, mtch);
            load([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.clu.mat']);
            clu1ind = find(clu{mtch}(:,2) == 1);
        end
        pk{mtch} = pk{mtch}(clu1ind,:);
        
        if(sum(pk{mtch}(:,2) < 0))
            Thres(iRecs) = max(pk{mtch}(:,2));
        else
            Thres(iRecs) = min(pk{mtch}(:,2));
        end
    end
    
    min_AP_threshold = 1;
    if(nanmean(Thres) < 0)
        min_AP_threshold = min(Thres);
    else
        min_AP_threshold = max(Thres);
    end
    
    disp('Not in Multiunit Database')
    SessNum = length(Session);
    
    if(iscell(recs))
        rec_string = '';
        for iRec = 1:length(recs)
            rec_string = [rec_string ' ''' recs{iRec} ''''];
        end
    else
        rec_string = recs;
    end

eval(['Session{SessNum+1} = {''' day ''',{' rec_string '},{''' tower '''},{' num2str(ch) ',' num2str(contact) '},{[' num2str(depth(1)) ',' num2str(depth(2)) ',' num2str(min_AP_threshold) ']},' num2str(SessNum+1) ',''' MONKEYNAME ''',{''' SessionType '''}};']);

MultiunitSessionString = ['Session{ind} = {''' day ''',{' rec_string '},{''' tower '''},{' num2str(ch)  ',' num2str(contact) '},{[' num2str(depth(1)) ',' num2str(depth(2)) ',' num2str(min_AP_threshold) ']}, ind,''' MONKEYNAME ''',{''' SessionType '''}}; ind = ind+1; %% ' num2str(SessNum+1)];
    
    fid = fopen([MONKEYDIR '/m/Multiunit_Database.m'],'a+');
    fseek(fid,0,'eof');
    fprintf(fid,'\n');
    fprintf(fid,MultiunitSessionString);
    % fprintf(fid,'\n');
    fclose(fid);
    
    save([MONKEYDIR '/mat/Multiunit_Session.mat'],'Session');
    %end
end
