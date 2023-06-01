function SpikeSession = extractSpike1Session(Session)
%
%  SpikeSession = extractSpike1Session(Session)
%

if length(Session{5}) == 2
        if Session{5}{1}(1) < 100
           SpikeSessionNum = Session{6}(1);
	   Session = loadSpike_Database;
	   SpikeSession = Session{SpikeSessionNum};
	end
end

