

function generatePSTH(start_trial,end_trial)
global MONKEYDIR
session = Spike_Database;

for i = start_trial:end_trial
    
    filename = [MONKEYDIR '/fig/PSTHs/' session{i}{1} '_' num2str(i) '.pdf']
    try sessPrintPDFPSTH(session{i},{'DelReachFix','DelSaccadeTouch'},'TargsOn',[-1000,2000],40,[],filename)
        close all
    catch
    end
end