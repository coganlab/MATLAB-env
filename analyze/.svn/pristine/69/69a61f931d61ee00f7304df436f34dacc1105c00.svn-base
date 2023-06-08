function SpikeSession = extractSpike2Session(Session)
%
%  SpikeSession = extractSpike2Session(Session)
%

if length(Session{5}) == 2
        if Session{5}{2}(1) < 100
           SpikeSessionNum = Session{6}(2);
	   Session = loadSpike_Database;
	   SpikeSession = Session{SpikeSessionNum};
	end
end

