function h=semplotNoFig(sig1,sig2,t)
%figure;
sig1M=mean(sig1);
sig1S=std(sig1)./sqrt(size(sig1,1));
sig2M=mean(sig2);
sig2S=std(sig2)./sqrt(size(sig2,1));
h = plot(t,sig1M,'b');  set(h,'Linewidth',2);
h = patch([t,t(end:-1:1)],[sig1M + sig1S, ...
   sig1M(end:-1:1) - sig1S(end:-1:1)],0.5*[0,0,1]);
set(h,'FaceAlpha',.5,'EdgeAlpha',0,'Linestyle','none');
%title('Lateral. Red - low, black - medium, blue - high')
hold on;
h = plot(t,sig2M,'r');  set(h,'Linewidth',2);
h = patch([t,t(end:-1:1)],[sig2M + sig2S, ...
   sig2M(end:-1:1) - sig2S(end:-1:1)],0.5*[1,0,0]);
set(h,'FaceAlpha',.5,'EdgeAlpha',0,'Linestyle','none');
%title('Lateral. Red - low, black - medium, blue - high')

