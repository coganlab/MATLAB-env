function h=semplotNoFig_1(sig1,t,cval)
%figure;
sig1M=mean(sig1);
sig1S=std(sig1)./sqrt(size(sig1,1));
%sig2M=mean(sig2);
%sig2S=std(sig2)./sqrt(size(sig2,1));
h = plot(t,sig1M,'color',cval);  set(h,'Linewidth',2);
h = patch([t,t(end:-1:1)],[sig1M + sig1S, ...
   sig1M(end:-1:1) - sig1S(end:-1:1)],0.5*cval);
set(h,'FaceAlpha',.5,'EdgeAlpha',0,'Linestyle','none');
%title('Lateral. Red - low, black - medium, blue - high')


