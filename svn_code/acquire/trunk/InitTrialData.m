function TrialData = InitTrialData(trialBufferSize)

% maxspikes is 1000 * number of seconds to buffer spikes

global MAXCOND TASKCELL

TrialData.currentTrial = 0;

TrialData.TaskCode = zeros(1,trialBufferSize);
TrialData.JoystickCode = zeros(1,trialBufferSize);
TrialData.HandCode = zeros(1,trialBufferSize);

TrialData.StartHand = zeros(1,trialBufferSize);
TrialData.StartEye = zeros(1,trialBufferSize);
TrialData.Target = zeros(1,trialBufferSize);

TrialData.StartOn = zeros(1,trialBufferSize);
TrialData.StartAq = zeros(1,trialBufferSize);
TrialData.TargetOn = zeros(1,trialBufferSize);
TrialData.Go = zeros(1,trialBufferSize);
TrialData.TargetAq = zeros(1,trialBufferSize);
TrialData.Microstimulation = zeros(1,trialBufferSize);
TrialData.End = zeros(1,trialBufferSize);

TrialData.bufferSize = trialBufferSize;
TrialData.CurrentTr = zeros(MAXCOND,1);
