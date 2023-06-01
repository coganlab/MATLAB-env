function dometric(data,sv)

X=makemetric(data,sv);

opts.clustering_exponent = -2;
opts.unoccupied_bins_strategy = 0;
opts.metric_family = 0;
opts.parallel = 1;

opts.shift_cost = [0 2.^(-2:9)];
opts.start_time = 0;
opts.end_time = 0.475;

clear out out_unshuf shuf out_unjk jk;
clear info_plugin info_tpmc info_jack info_unshuf info_unjk;
clear temp_info_shuf temp_info_jk;

figure;
set(gcf,'name',['Metric out']); 

subplot(221);
staraster(X,[opts.start_time opts.end_time]);
title('Raster plot');

opts.entropy_estimation_method = {'plugin','tpmc','jack'};
[out,opts_used] = metric(X,opts);

for q_idx=1:length(opts.shift_cost)
  info_plugin(q_idx) = out(q_idx).table.information(1).value;
  info_tpmc(q_idx) = out(q_idx).table.information(2).value;
  info_jack(q_idx) = out(q_idx).table.information(3).value;
end

subplot(222);
[max_info,max_info_idx]=max(info_plugin);
imagesc(out(max_info_idx).d);
xlabel('Spike train index');
ylabel('Spike train index');
title('Distance matrix at maximum information');

subplot(223);
plot(1:length(opts.shift_cost),info_plugin);
hold on;
plot(1:length(opts.shift_cost),info_tpmc,'--');
plot(1:length(opts.shift_cost),info_jack,'-.');
hold off;
set(gca,'xtick',1:length(opts.shift_cost));
set(gca,'xticklabel',opts.shift_cost);
set(gca,'xlim',[1 length(opts.shift_cost)]);
set(gca,'ylim',[-0.5 2.5]);
xlabel('Temporal precision (1/sec)');
ylabel('Information (bits)');
legend('No correction','TPMC correction','Jackknife correction',...
       'location','best');
   
opts.entropy_estimation_method = {'plugin'};
rand('state',0);
S=10;
[out_unshuf,shuf,opts_used] = metric_shuf(X,opts,S);
shuf = shuf';
for q_idx=1:length(opts.shift_cost)
  info_unshuf(q_idx)= out_unshuf(q_idx).table.information.value;
  for s=1:S
    temp_info_shuf(s,q_idx) = shuf(s,q_idx).table.information.value;
  end
end
info_shuf = mean(temp_info_shuf,1);
info_shuf_std = std(temp_info_shuf,[],1);

%%% leave-one-out Jackknife 

[out_unjk,jk,opts_used] = metric_jack(X,opts);
P_total = size(jk,1);
temp_info_jk = zeros(P_total,length(opts.shift_cost));
for q_idx=1:length(opts.shift_cost)
  info_unjk(q_idx)= out_unjk(q_idx).table.information.value;
  for p=1:P_total
    temp_info_jk(p,q_idx) = jk(p,q_idx).table.information.value;
  end
end
info_jk_sem = sqrt((P_total-1)*var(temp_info_jk,1,1));

%%% Plot results

subplot(224);
errorbar(1:length(opts.shift_cost),info_unjk,2*info_jk_sem);
hold on;
errorbar(1:length(opts.shift_cost),info_shuf,2*info_shuf_std,'r');
hold off;
set(gca,'xtick',1:length(opts.shift_cost));
set(gca,'xticklabel',opts.shift_cost);
set(gca,'xlim',[1 length(opts.shift_cost)]);
set(gca,'ylim',[-0.5 2.5]);
xlabel('Temporal precision (1/sec)');
ylabel('Information (bits)');
legend('Original data (\pm 2 SE via Jackknife)','Shuffled data (\pm 2 SD)',...
       'location','best');

scalefig(gcf,2);