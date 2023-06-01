figure;
t=linspace(-.5,1,30);
sig1=sin(2*pi*1*t);
plot(t,sig1)
% make 10 to 20 significant
hold on;
plot(t(10:20),min(sig1)*ones(11,1),'k-','LineWidth',10);