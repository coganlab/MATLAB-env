function outputflag = addMultiunitDatabaseMatFromField(sess)
%
%  outputflag = addMultiunitDatabaseMatFromField(sess)
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
length(Session);
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
                %  Need to add contact check
                r = Recs(DayInd(TowerInd(ChannelInd)));
                clear R rec_ind;
                
                d = Depth(DayInd(TowerInd(ChannelInd)),:);
                if(~isempty(d))
                    for iDepth = 1:size(d,1)
                        if(d(iDepth,1) == depth(1))
                            outputflag = 0;
                            disp([day ':' tower ':' num2str(ch) ':' num2str(contact) ' already in Multiunit Database'])
                        end
                    end
                end
                %                 end
            end
        end
    end
else
    %     outputflag = 1;
    outputflag = 1;
end
    

if outputflag == 1  %  Not in Multiunit Database.  Add.
    %Trials = sessTrials(sess);
    %if(~isempty(Trials))
    % Set to one for now
    min_AP_threshold = 1;
    % Calculate the AP threshold
    
    sys = sessTower(sess);
    if(iscell(sys))
        sys = sys{1};
    end
    recs = sessRec(sess);
    nRecs = length(recs);
    for iRecs = 1:nRecs
        rec = recs{iRecs};
        load([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.pk.mat']);
        if isfile([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat'])
            load([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat']);
            mtch = expChannelIndex(experiment,sys,ch,contact);
            if(iscell(mtch))
                mtch = mtch{1};
            end
        else
            mtch = ch;
        end
%         if exist([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.clu.mat'], 'file')
            load([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.clu.mat']);
%         else
%             disp('Clu file missing')
%             disp('Creating clu file with makeClu');
%             makeClu(day, rec, sys);
%             disp('Loading clu file')
%             load([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.clu.mat']);
%         end
        if isempty(clu{mtch}) 
            if ~isempty(pk{mtch})
            clu{mtch}(:,1) = pk{mtch}(:,1);
            clu{mtch}(:,2) = 1;
            else
                clu{mtch} = [];
            end
            save([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.clu.mat'],'clu')
        end
        
        % Finding multiunit spikes
        if ~isempty(clu{mtch})
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
        else
          pk{mtch} = [];
          Thres(iRecs) = nan;
        end
    end
    
    min_AP_threshold = 1;
    if(nanmean(Thres) < 0)
        min_AP_threshold = min(Thres);
    else
        min_AP_threshold = max(Thres);
    end
    disp([day ':' tower ':' num2str(ch) ':' num2str(contact) ' not in Multiunit Database'])
    SessNum = length(Session);
    
    
    Session{SessNum+1} = {day,recs,{tower},{ch,contact},{[depth(1),depth(2),min_AP_threshold]},SessNum+1,MONKEYNAME,{'Multiunit'}};
    
    save([MONKEYDIR '/mat/Multiunit_Session.mat'],'Session');
end
end
