function [SVDParams] = feat_calc(AParams,trial)
day = trial.day;
rec = trial.rec;
state = trial.state;
ch = trial.ch;
sys = trial.sys;
bn = trial.bn;

Fs = AParams.Fs;
winwidth = AParams.winwidth; % Units in ms for 1 kHz sampling rate
NORMALIZE_FLAG = 0;
maxfreq = AParams.maxfreq;
tapers_time = AParams.tapers_time;


% Aligning LFPs to the Move State
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Mlfp = stateMlfp(day,rec,sys,ch,state,bn);
Joy = stateJoy(day,rec,state,bn);


[Mlfp, idx] = Lfp_artifact_remov(Mlfp);
Joy = Joy(idx,:,:);

JoyV = joyvel(Joy);

% Choosing MLFP segment for Rest
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if state == 'Move'
    init_Rest = -bn(1)-winwidth ; 
else
    init_Rest = -bn(1) + 1000;
end
%init_Rest = -bn(1)+ 650;
final_Rest = init_Rest + winwidth - 1;
Rest= Mlfp(:,(init_Rest:final_Rest));


%Rest Spectrum
%%%%%%%%%%%%%%%
Restspec = dmtspec(Rest,[tapers_time,5],Fs,maxfreq);
Num_Trials = size(Restspec,1);;

dt = winwidth/10; % 90% overlap



% Choosing MLFP segment for Move Training: Fixed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if state == 'Move'
    init_Move = -bn(1) + 525;
else
    init_Move = -bn(1) -winwidth;
end
final_Move = init_Move + winwidth - 1;

% Move Spectrum
%%%%%%%%%%%%%%%%%%%%%%%%
Move = Mlfp(:,(init_Move:final_Move));
Movespec = dmtspec(Move,[tapers_time,5],Fs,maxfreq); % Training at a fixed time point relative to Move onset


SVDParams = TrainTwoMixtureModels(Restspec,Movespec,AParams.modes,AParams.comps,AParams.max_modes);
