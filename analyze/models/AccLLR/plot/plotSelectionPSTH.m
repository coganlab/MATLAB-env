function plotSelectionPSTH(Onset, DetectType)
%
%  plotSelectionPSTH(Onset, DetectType)
%
%   Inputs: Onset      = Data structure
%           DetectType = String. 'Hit' or 'Reject'
%                           Defaults to 'Hit'
%

if nargin < 2 || isempty(DetectType)
    DetectType = 'Hit';
end

Results = Onset.Results;
Data = Onset.Data;
MaxTime = Onset.Params.MaximumTimetoOnsetDetection - Onset.Params.StartofAccumulation;
GoCue = Onset.Params.GoCue;
Eventbn = Onset.Params.Event.bn;
Nullbn = Onset.Params.Null.bn;
Smoothing = Onset.Params.Smoothing;

EventST = calcOptimalSelectionTime(Onset,'Hit');
NullST = calcOptimalSelectionTime(Onset,'Reject');

GoodEventTrials = find(~isnan(EventST) & EventST<MaxTime-200);
[ST,ind] = sort(EventST(GoodEventTrials),'ascend');
SpikesEvent_ST = Data.Event(GoodEventTrials(ind));

Spikets = sp2ts(SpikesEvent_ST,[0,diff(Eventbn(1:2)),1]);
clear EventSpikestsAligned EventSpikeAligned_ST
for iST = 1:length(ST)
  EventSpikestsAligned_ST(iST,:)= Spikets(iST,ST(iST)+GoCue+[-200:200]);
  EventSpikeAligned_ST{iST} = find(EventSpikestsAligned_ST(iST,[1:201 203:end]))';
end

GoodNullTrials = find(~isnan(NullST) & NullST<MaxTime-200);
[ST,ind] = sort(NullST(GoodNullTrials),'ascend');
SpikesNull_ST = Data.Null(GoodNullTrials(ind));

Spikets = sp2ts(SpikesNull_ST,[0,diff(Nullbn(1:2)),1]);
clear NullSpikestsAligned NullSpikeAligned_ST
for iST = 1:length(ST)
  NullSpikestsAligned_ST(iST,:)= Spikets(iST,ST(iST)+GoCue+[-200:200]);
  NullSpikeAligned_ST{iST} = find(NullSpikestsAligned_ST(iST,[1:201 203:end]))';
end

t = [-200:200];
mNullAligned = psth(NullSpikeAligned_ST,[-200,200],3,100);
sdNullAligned = sqrt(mNullAligned);
mEventAligned = psth(EventSpikeAligned_ST,[-200,200],3,100);
sdEventAligned = sqrt(mEventAligned);

figure;
h = plot(t,mEventAligned,'k-');  set(h,'Linewidth',2);
h = patch([t,t(end:-1:1)],[mEventAligned+2*sdEventAligned,mEventAligned(end:-1:1)-2*sdEventAligned(end:-1:1)],0.7*[1,1,1]);
set(h,'FaceAlpha',.5,'EdgeAlpha',0,'Linestyle','none');
hold on;
h = plot(t,mNullAligned,'k-');  set(h,'Linewidth',2);
h = patch([t,t(end:-1:1)],[mNullAligned+2*sdNullAligned,mNullAligned(end:-1:1)-2*sdNullAligned(end:-1:1)],0.7*[1,1,1]);
set(h,'FaceAlpha',.5,'EdgeAlpha',0,'Linestyle','none');

Nullt = [Nullbn(1):Nullbn(2)];
mNull = psth(Data.Null,Nullbn(1:2),Smoothing);
sdNull = sqrt(mNull);
Eventt = [Eventbn(1):Eventbn(2)];
mEvent = psth(Data.Event,Eventbn(1:2),Smoothing);
sdEvent = sqrt(mEvent);

figure;
h = plot(Eventt,mEvent,'k-');  set(h,'Linewidth',2);
h = patch([Eventt,Eventt(end:-1:1)],[mEvent+1*sdEvent, mEvent(end:-1:1)-1*sdEvent(end:-1:1)],0.7*[1,1,1]);
set(h,'FaceAlpha',.5,'EdgeAlpha',0,'Linestyle','none');
hold on;
h = plot(Nullt,mNull,'k--');  set(h,'Linewidth',2);
h = patch([Nullt,Nullt(end:-1:1)],[mNull+1*sdNull, mNull(end:-1:1)-1*sdNull(end:-1:1)],0.7*[1,1,1]);
set(h,'FaceAlpha',.5,'EdgeAlpha',0,'Linestyle','none');



a = get(gca,'YLim'); maxY = a(2); box off;
set(gca,'XLim',[-100,100],'Ylim',[-10,maxY]); 
set(gca,'Fontsize',14);
xlabel('Time from ST (ms)'); ylabel('Firing Rate (sp/s)');

