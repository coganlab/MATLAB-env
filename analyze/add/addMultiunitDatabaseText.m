function outputflag = addMultiunitDatabaseText(day, rec, tower, ch, contact)
%
%  outputflag = addMultiunitDatabaseText(day, rec, tower, ch, contact)
%
%  This checks if session is already in Multiunit Database
%
%   Outputs:  OUTPUTFLAG = 0/1.  1 = Changed Multiunit database.
%                                0 = Unchanged

global MONKEYDIR

Session = loadMultiunit_Database;

if nargin < 5; contact = 1; end

Days = sessDay(Session);
Channels = sessElectrode(Session);
Contacts = sessContact(Session);
Towers = sessTower(Session);
Recs = sessRec(Session);

if iscell(Contacts)
  nContacts = length(Contacts);
  NewContacts = zeros(1,nContacts);
  for iContact = 1:nContacts
    NewContacts(iContact) = Contacts{iContact};
  end
end
Contacts = NewContacts;

flag = 0;
if ~isempty(find(strcmp(Days,day),1))
    DayInd = find(strcmp(Days,day));
    if ~isempty(find(strcmp(Towers(DayInd), tower),1))
        TowerInd = find(strcmp(Towers(DayInd), tower));
        if ~isempty(find(intersect(Channels(DayInd(TowerInd)),ch),1))
          ChannelInd = find((Channels(DayInd(TowerInd))==ch));
          if ~isempty(find(intersect(Contacts(DayInd(TowerInd(ChannelInd))),contact),1))
            ContactInd = find((Contacts(DayInd(TowerInd(ChannelInd)))==contact));

            r = Recs(DayInd(TowerInd(ChannelInd(ContactInd))));
            clear R;
            for iR = 1:length(r) R{iR} = r{iR}{1}; end
            if ~isempty(find(strcmp(R,rec),1))
                flag = 1;
                disp('Already in Multiunit Database')
            end
	  end
        end
    end
end



if flag == 0  
    disp('Not in Multiunit Database')
    SessNum = length(Session);
    eval(['Session{SessNum+1} = {''' day ''',{''' rec '''},{''' tower '''},{' num2str(ch) ',' num2str(contact) '},1,' num2str(SessNum+1) '};'])
    MultiunitSessionString = ['Session{ind} = {''' day ''',{''' rec '''},{''' tower '''},{' num2str(ch) ',' num2str(contact) '},1,ind}; ind = ind+1; %% ' num2str(SessNum+1)];

    fid = fopen([MONKEYDIR '/m/Multiunit_Database.m'],'a+');
    fseek(fid,0,'eof');
    fprintf(fid,'\n');
    fprintf(fid,MultiunitSessionString);
    fprintf(fid,'\n');
    fclose(fid);

    save([MONKEYDIR '/mat/Multiunit_Session.mat'],'Session');
    
end

outputflag = ~flag;
