function Buffer = InitBuffer
%
%   Buffer = InitBuffer
%
global SYSTEM SAMPLING DT

nCh = 0;
for iDrive = 1:length(SYSTEM)
    nCh = nCh + SYSTEM(iDrive).NumElectrodes;
end
%nCh = 4;
Buffer.Raw = zeros(nCh,SAMPLING*50);
Buffer.Mu = zeros(nCh,SAMPLING*50);
Buffer.Lfp = zeros(nCh,1e3*50);

Buffer.StimPulse = zeros(1,SAMPLING*50);
Buffer.StimVolt = zeros(1,SAMPLING*50);
Buffer.State = zeros(4,2000);
Buffer.State(4,:) = 1:2000;    %  Keep track of which element state is assigned/recalled to/from.

Buffer.Stim = zeros(2,1000);
Buffer.SpWave = zeros(nCh,1e4,33);
Buffer.SpTimes = zeros(nCh,1e4,2);
Buffer.Mu_Pos = 1;
Buffer.Raw_Pos = 1;
Buffer.Lfp_Pos = 1;

Buffer.StimPulse_Pos = 1;
Buffer.StimVolt_Pos = 1;
Buffer.State_Pos = 1;

Buffer.Stim_Pos = 1;
Buffer.SpWave_Pos = zeros(nCh,1)+1;
Buffer.SpTimes_Pos = zeros(nCh,1)+1;

%Buffer.Time = gettime;
Buffer.Time = clock;
    

