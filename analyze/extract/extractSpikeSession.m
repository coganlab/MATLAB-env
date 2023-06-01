function SpikeSession = extractSpikeSession(Sess)
%
%  SpikeSession = extractSpikeSession(Sess)
%

if length(Sess{5}) == 1
    if ~iscell(Sess{5})
        if Sess{5} > 100
        elseif Sess{5} < 100
            SpikeSession = Sess;
        end
    elseif iscell(Sess{5})
        if Sess{5}{1}(1) > 100
        elseif Sess{5}{1}(1) < 100
            SpikeSession = Sess;
        end
    end
elseif length(Sess{5}) == 2
    if Sess{5}{1}(1) < 100 & Sess{5}{1}(1) > 1
        SpikeSessionNum = Sess{6}(1);
        Session = loadSpike_Database;
        SpikeSession = Session{SpikeSessionNum};
    elseif Sess{5}{1}(1) == 1
        SpikeSessionNum = Sess{6}(1);
        Session = loadMultiunit_Database;
        SpikeSession = Session{SpikeSessionNum};
    end
end

