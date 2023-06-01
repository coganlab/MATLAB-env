function outputflag = addLaminarDatabaseText(day, rec, tower, ch, ncontact, depth, range)
%
%  outputflag = addLaminarDatabaseText(day, rec, tower, ch, ncontact, depth, range)
%
%  This checks if session is already in Laminar Database
%
%   Outputs:  OUTPUTFLAG = 0/1.  1 = Changed Laminar database.
%                                 0 = Unchanged

global MONKEYDIR MONKEYNAME

Session = loadLaminar_Database;

if nargin < 6 depth = 1e3; end
if nargin < 7 range = 100; end

SessionType = 'Laminar';

if length(Session)
    Days = sessDay(Session);
    Channels = sessElectrode(Session);
    Towers = sessTower(Session);
    Depths = sessDepth(Session);
    
    flag = 0;
    DayInd = find(strcmp(Days,day));
    if ~isempty(DayInd)
        
        TowerInd = find(strcmp(Towers(DayInd), tower));
        if ~isempty(TowerInd)
            
            ChannelInd = find(Channels(DayInd(TowerInd))==ch)';
            if ~isempty(ChannelInd)
                
                DepthInd = find(Depths(DayInd(TowerInd(ChannelInd))) > depth-range & ...
                    Depths(DayInd(TowerInd(ChannelInd))) < depth+range)';
                
                if ~isempty(DepthInd)
                    
                    flag = 1;
                    disp('Already in Laminar Database')
                end
            end
        end
    end
else
    flag=0;
end

if flag == 0
    disp('Not in Laminar Database')
    SessNum = length(Session);
    
    if iscell(rec)
        RecString = ['rec = {''' rec{1} ''''];
        for iRec = 2:length(rec)
            RecString = [RecString ',''' rec{iRec} ''''];
        end
        RecString = [RecString '};'];
        eval(['Session{SessNum+1} = {''' day ''',rec,{''' tower '''},{' num2str(ch) ',1:' num2str(ncontact) '},{[' num2str(depth) ',' num2str(range) ']},' num2str(SessNum+1) ',''' MONKEYNAME ''',{''' SessionType '''}};'])
        FieldSessionString = ['Session{ind} = {''' day ''',rec,{''' tower '''},{' num2str(ch) ',1:' num2str(ncontact) '},{[' num2str(depth) ',' num2str(range) ']},ind,''' MONKEYNAME ''',{''' SessionType '''}}; ind = ind+1; %% ' num2str(SessNum+1)];
    else
        eval(['Session{SessNum+1} = {''' day ''',{''' rec '''},{''' tower '''},{' num2str(ch) ',1:' num2str(ncontact) '},{[' num2str(depth) ',' num2str(range) ']},' num2str(SessNum+1) ',''' MONKEYNAME ''',{''' SessionType '''}};'])
        FieldSessionString = ['Session{ind} = {''' day ''',{''' rec '''},{''' tower '''},{' num2str(ch) ',1:' num2str(ncontact) '},{[' num2str(depth) ',' num2str(range) ']},ind,''' MONKEYNAME ''',{''' SessionType '''}}; ind = ind+1; %% ' num2str(SessNum+1)];
    end
    
    fid = fopen([MONKEYDIR '/m/Laminar_Database.m'],'a+');
    fseek(fid,0,'eof');
    if iscell(rec)
        fprintf(fid,'\n');
        fprintf(fid,RecString);
        fprintf(fid,'\n');
    end
    fprintf(fid,'\n');
    fprintf(fid,FieldSessionString);
    fprintf(fid,'\n');
    fclose(fid);
    
    save([MONKEYDIR '/mat/Laminar_Session.mat'],'Session');
    
end

outputflag = ~flag;
