function plotSelectionTrialAveragePerformance(Onset, FA, DetectType, MinST)
%
%  plotSelectionTrialAveragePerformance(Onset, FA, DetectType, MinST)
%
%   Inputs: Onset      = Data structure
%           FA         = Scalar.  False alarm rate
%           DetectType = String. 'Hit' or 'Correct'
%                           Defaults to 'Hit'
%           MinST      = Scalar.  Minimum selection time in ms.
%                           Defaults to 50ms
%


if nargin < 3 || isempty(DetectType)
    DetectType = 'Hit';
end
if nargin < 4 || isempty(MinST)
    MinST = 50;
end

Results = Onset.Results;
MaxTime = Onset.Params.MaximumTimetoOnsetDetection;
NumTrials = Results.NoHist.InputParams.TrialAvNumTrials;

figure;
Type = 'NoHist';
eval(['AccLLRNull = Results.' Type '.Null.AccLLR;'])
eval(['AccLLREvent = Results.' Type '.Event.AccLLR;'])

for iNumTrials = 1:length(NumTrials)
    %  NoHist across Trial Averages
    Type = 'NoHist';
    AccLLREvent = Onset.Results.NoHist.TrialAv.AccLLREvent{iNumTrials};
    AccLLRNull = Onset.Results.NoHist.TrialAv.AccLLRNull{iNumTrials};
    [p, ST, Levels] = performance_levels(AccLLREvent, AccLLRNull, DetectType);
    [Opt_p(iNumTrials), Opt_ST(iNumTrials), Opt_FA(iNumTrials)] = ...
        optimal_performance(p, ST, DetectType);
    [Con_p(iNumTrials), Con_ST(iNumTrials), Con_FA(iNumTrials)] = ...
        controlled_performance(p, ST, FA, DetectType);
end

subplot(3,1,1)
h = plot(NumTrials,Con_p,'k-'); set(h, 'Linewidth',2);
h = plot(NumTrials,Opt_p,'k--'); set(h, 'Linewidth',2);
set(gca,'Fontsize',14);
xlabel('Number of Trials'); ylabel([DetectType 'Probability']);

subplot(3,1,2)
h = plot(NumTrials,Con_FA,'k-'); set(h, 'Linewidth',2);
h = plot(NumTrials,Opt_FA,'k--'); set(h, 'Linewidth',2);
set(gca,'Fontsize',14);
xlabel('Number of Trials'); ylabel('Alarm Probability');

subplot(3,1,3)
h = plot(NumTrials,Con_ST,'k-'); set(h, 'Linewidth',2);
h = plot(NumTrials,Opt_ST,'k--'); set(h, 'Linewidth',2);
set(gca,'Fontsize',14);
xlabel('Number of Trials'); ylabel('Selection Time (ms)');


