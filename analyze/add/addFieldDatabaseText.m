function outputflag = addFieldDatabaseText(day, rec, tower, ch, contact, depth, range)
%
%  outputflag = addFieldDatabaseText(day, rec, tower, ch, contact, depth, range)
%
%  This checks if session is already in Field Database
%
%   Outputs:  OUTPUTFLAG = 0/1.  1 = Changed Field database.
%                                0 = Unchanged

global MONKEYDIR MONKEYNAME

Session = loadField_Database;

SessionType = 'Field';

if nargin < 6 depth = 1e3; end
if nargin < 7 range = 100; end

depth
range

if length(Session)
    Days = sessDay(Session);
    Channels = sessElectrode(Session);
    Contacts = sessContact(Session);
    Towers = sessTower(Session);
    Recs = sessRec(Session);
    Depths = sessDepth(Session);
    
    if iscell(Contacts)
        nContacts = length(Contacts);
        NewContacts = zeros(1,nContacts);
        for iContact = 1:nContacts
            NewContacts(iContact) = Contacts{iContact};
        end
    end
    Contacts = NewContacts;
    
    flag = 0;
    DayInd = find(strcmp(Days,day));
    if ~isempty(DayInd)
        
        TowerInd = find(strcmp(Towers(DayInd), tower));
        if ~isempty(TowerInd)
            
            ChannelInd = find(Channels(DayInd(TowerInd))==ch)';
            if ~isempty(ChannelInd)
                
                ContactInd = find(Contacts(DayInd(TowerInd(ChannelInd)))==contact)';
                if ~isempty(ContactInd)
                    
                    DepthInd = find(Depths(DayInd(TowerInd(ChannelInd(ContactInd)))) > depth-range & ...
                        Depths(DayInd(TowerInd(ChannelInd(ContactInd)))) < depth+range)';
                    if ~isempty(DepthInd)
                        flag = 1;
                        disp('Already in Field Database')
                    end
                end
            end
        end
    end
else
    flag=0;
end

if flag == 0
    disp('Not in Field Database')
    SessNum = length(Session);
    
    if iscell(rec)
        RecString = ['rec = {''' rec{1} ''''];
        for iRec = 2:length(rec)
            RecString = [RecString ',''' rec{iRec} ''''];
        end
        RecString = [RecString '};'];
        eval(['Session{SessNum+1} = {''' day ''',rec,{''' tower '''},{' num2str(ch) ',' num2str(contact) '},{[' num2str(depth) ',' num2str(range) ']},' num2str(SessNum+1) ',''' MONKEYDIR ''',{''' SessionType '''}};'])
        FieldSessionString = ['Session{ind} = {''' day ''',rec,{''' tower '''},{' num2str(ch) ',' num2str(contact) '},{[' num2str(depth) ',' num2str(range) ']},ind,''' MONKEYDIR ''',{''' SessionType '''}}; ind = ind+1; %% ' num2str(SessNum+1)];
    else
        eval(['Session{SessNum+1} = {''' day ''',{''' rec '''},{''' tower '''},{' num2str(ch) ',' num2str(contact) '},{[' num2str(depth) ',' num2str(range) ']},' num2str(SessNum+1) ',''' MONKEYDIR ''',{''' SessionType '''}};'])
        FieldSessionString = ['Session{ind} = {''' day ''',{''' rec '''},{''' tower '''},{' num2str(ch) ',' num2str(contact) '},{[' num2str(depth) ',' num2str(range) ']},ind,''' MONKEYDIR ''',{''' SessionType '''}}; ind = ind+1; %% ' num2str(SessNum+1)];
    end
    
    fid = fopen([MONKEYDIR '/m/Field_Database.m'],'a+');
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
    
    save([MONKEYDIR '/mat/Field_Session.mat'],'Session');
    
end

outputflag = ~flag;
