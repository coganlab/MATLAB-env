function procCheckPhaseSpace(day,rec)
%
%  procCheckPhaseSpace(day,rec)
%

global MONKEYDIR

MaxReachDuration = 800;

if nargin == 2
    Trials = dbSelectTrials(day, rec);
else
    Trials = dbSelectTrials(day);
end

Markers = which3DMarkers(Trials);
ReachDuration = [Trials.TargAq] - [Trials.ReachStart];
Trials = Trials(ReachDuration < MaxReachDuration);
ReachDuration = ReachDuration(ReachDuration < MaxReachDuration);
bn = [zeros(length(Trials),1) ReachDuration'];
Pos = [9,4,3,2,7,12,13,14,10,6];
Prop = zeros(length(Markers),10,10);
for iMarker = 1:length(Markers)
  Hand3D = trialHand3D(Trials,Markers(iMarker),'ReachStart',bn);
  clear Coverage
  for iTr = 1:length(Trials)
    if ~isempty(Hand3D{iTr});
      Coverage{iTr} = Hand3D{iTr}(1,:)./ReachDuration(iTr);
    else
      Coverage{iTr} = [];
    end
  end
  for iTarget = 1:10
    Ts = [];
    ind = find([Trials.Target]==iTarget);
    mRD = mean(ReachDuration(ind));
    for iTr = 1:length(ind)
      if ~isempty(Coverage{ind(iTr)})
        Ts = [Ts Coverage{ind(iTr)}];
      end
    end
    [n,x]=hist(Ts);  
    Prop(iMarker,iTarget,:) = 1e3.*n./mRD.*10./length(ind);
    figure(iMarker);
    if iTarget==1 clf; end
    subplot(3,5,Pos(iTarget));
    h = plot(x,sq(Prop(iMarker,iTarget,:)));
    set(gca,'YLim',[0,482]);
    set(h, 'Linewidth',2);
    if iTarget==10 xlabel('Fraction of the Reach'); ylabel('Effective sampling rate (Hz)'); end
  end
  supertitle([MONKEYDIR '/' day ' Marker ' num2str(Markers(iMarker))]);
end

