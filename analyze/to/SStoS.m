function Session = SStoS(InputSession)
%
%   Session = SStoS(InputSession,Chamber)
%
%	Chamber is the ID for the session to be linked to
%    


Session = splitSession(InputSession);


% Session = loadSpike_Database;
% SessNum = [];
% SpikeChamber = InputSession{3}{1};
% if strcmp(SpikeChamber,Chamber) || ...
%         (strcmp(SpikeChamber(1:2),Chamber(1:2)) && ...
%         strcmp(SpikeChamber(end),Chamber(end)))
%     SessNum = InputSession{6}(1);
% end
% 
% SpikeChamber = InputSession{3}{2};
% if (strcmp(SpikeChamber,Chamber) || ...
%         (strcmp(SpikeChamber(1:2),Chamber(1:2)) && ...
%         strcmp(SpikeChamber(end),Chamber(end))))
%     SessNum = [SessNum,InputSession{6}(2)];
% end
% 
% if length(SessNum)==1
%     Session = Session{SessNum};
% else
%     Session = Session(SessNum);
% end
% disp([num2str(length(SessNum)) ' Spike sessions'])
