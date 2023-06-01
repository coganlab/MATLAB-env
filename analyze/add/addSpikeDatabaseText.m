function outputflag = addSpikeDatabaseText(day, rec, tower, ch, contact, cl)
%
%  outputflag = addSpikeDatabaseText(day, rec, tower, ch, contact, cl)
%
%  This checks if session is already in Spike Database
%
%   Inputs: DAY = String.  Day string. ie '120714'
%           REC = String. Rec string. ie '002' or {'002','003','004'}
%           TOWER = String.  Tower string is 'MT1'
%           CH = Scalar.  Electrode number
%           CONTACT = Scalar. Contact number. Defaults to 1.
%           CL = Scalar.  Cell number.
%
%   Outputs:  OUTPUTFLAG = 0/1.  1 = Changed Spike database.
%                                0 = Unchanged

global MONKEYDIR

Session = loadSpike_Database;

if nargin < 5 || isempty(contact); contact = 1; end

Days = sessDay(Session);
Channels = sessElectrode(Session);
Contacts = sessContact(Session);
Towers = sessTower(Session);
Recs = sessRec(Session);
Cells = sessCell(Session);
if(iscell(Cells))
    Cells = cell2num(Cells);
end
if iscell(Contacts)
  nContacts = length(Contacts);
  NewContacts = zeros(1,nContacts);
  for iContact = 1:nContacts
    NewContacts(iContact) = Contacts{iContact};
  end
end
Contacts = NewContacts;

flag = 0;
rec_string = '';
if ~isempty(find(strcmp(Days,day),1))
    DayInd = find(strcmp(Days,day));
    if ~isempty(find(strcmp(Towers(DayInd), tower),1))
        TowerInd = find(strcmp(Towers(DayInd), tower));
        if ~isempty(find(intersect(Channels(DayInd(TowerInd)),ch),1))
            ChannelInd = find((Channels(DayInd(TowerInd))==ch));
            if ~isempty(find(intersect(Contacts(DayInd(TowerInd(ChannelInd))),contact),1))
                ContactInd = find((Contacts(DayInd(TowerInd(ChannelInd)))==contact));
                if ~isempty(find(intersect(Cells(DayInd(TowerInd(ChannelInd(ContactInd)))),cl),1))
                    CellInd = find((Cells(DayInd(TowerInd(ChannelInd(ContactInd))))==cl));
                    
                    r = Recs(DayInd(TowerInd(ChannelInd(ContactInd(CellInd)))));
                    clear R;
                    for iR = 1:length(r) R{iR} = r{iR}{1}; end
                    rec
                    if(iscell(rec))
                        flag = 0;
                        for iR = 1:length(rec)
                            flag = flag + length(find(strcmp(R,rec{iR}),1));
                            rec_string = [rec_string ',''' rec{iR} ''''];
                        end
                        rec_string(1) = []
                    else
                        flag = ~isempty(find(strcmp(R,rec),1));
                        rec_string = ['''' rec ''''];
                    end
                end
            end
        end
    end
end
if(length(rec_string) == 0)
    if(iscell(rec))
        for iR = 1:length(rec)
            rec_string = [rec_string ',''' rec{iR} ''''];
        end
        rec_string(1) = []
    else
        rec_string = ['''' rec ''''];
    end
end
if flag == 0
    disp('Not in Spike Database')
    SessNum = length(Session);
    eval(['Session{SessNum+1} = {''' day ''',{' rec_string '},{''' tower '''},{' num2str(ch) ',' num2str(contact) '},' num2str(cl) ',' num2str(SessNum+1) '};'])
    SpikeSessionString = ['Session{ind} = {''' day ''',{' rec_string '},{''' tower '''},{' num2str(ch) ',' num2str(contact) '},' num2str(cl) ',ind}; ind = ind+1; %% ' num2str(SessNum+1)];
    
    fid = fopen([MONKEYDIR '/m/Spike_Database.m'],'a+');
    fseek(fid,0,'eof');
    fprintf(fid,'\n');
    fprintf(fid,SpikeSessionString);
    fprintf(fid,'\n');
    fclose(fid);
    
    save([MONKEYDIR '/mat/Spike_Session.mat'],'Session');
else
    disp('Already in Spike Database')
    
end

outputflag = ~flag;
