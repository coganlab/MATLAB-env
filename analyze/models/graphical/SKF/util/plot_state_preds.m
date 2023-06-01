% Plot of state predictions


figure;
clf,hold all;

mag_vel = sqrt(sum(X2(3:4,:).^2,1));
title('Probability of Model 1 by EM iteration');
ytick = [0.5];
for t=1:EM_iters
    ytick = [(0.5-t) ytick];
    l=line([-1000 50000],[1 1]*(1 - t),'linestyle','--','color','k','linewidth',1);
    %set(l,'Linespec','lineStyle',
end


plot(mag_vel);

labels = [];
labels = strvcat(labels, 'Vel');
for t=1:EM_iters
    %labels(t+1,:) = [' T' num2str(t)];
    labels = strvcat(labels,[' T' num2str(t)]);

    %subplot(EM_iters,1,t); 
    plot(tskf{t}.M(1,:)-t);
end

axis([0 1000 -EM_iters 1.3]);
set(gca,'YTick',ytick);
set(gca,'YTickLabel', flipud(labels));


