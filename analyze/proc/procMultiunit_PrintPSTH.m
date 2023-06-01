function procMultiunit_PrintPSTH(day)
%script to find and print the cells with significant tuning during the
%control task (multiunit only)
%clear all
%close all
%calvin_ppc_sc32

%day = '110628'
Session = loadMultiunit_Database;
Days = sessDay(Session);

First = find(ismember(Days,day)==1);

if isempty(First)
  error(['No data on ' day]);
  return
end

Start = First(1);

CT = loadMultiunit_ControlTuning(Start:Start+31);

for i = 1:32
    P_MRF(i) = [CT(i).MemoryReachFix.Delay.Tuning.P];
    P_MST(i) = [CT(i).MemorySaccadeTouch.Delay.Tuning.P];
end

Channels_P = find(P_MRF<0.05 | P_MST<0.05)
Sessions_P = (Channels_P-1)+Start

for i = 1:length(Sessions_P)
    iSessions = Sessions_P(i);
    PDFFilename = ['ReachorSaccadeDelayTuned.PSTH.MRFandMST.' num2str(getSessionNumbers(Session{iSessions})) '.pdf'];
    sessPrintPDFPSTH(Session{iSessions},{'MemoryReachFix','MemorySaccadeTouch'},'TargsOn',[-500,2500],[],[],PDFFilename)
end

