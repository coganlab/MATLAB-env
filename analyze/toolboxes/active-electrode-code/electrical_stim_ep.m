

start_ep = 1.0;
stop_ep = 1.3;

% average all stims
avg_eps2 = reshape(mean(eps,3),size(eps,4),size(eps,5));

% take 0 to 30 ms
avg_eps2 = avg_eps2(1:numRow*numCol,round(Fs * start_ep):round( Fs * stop_ep));

% max - min 
avg_eps3 = max(avg_eps2,[],2) - min(avg_eps2,[],2);

% reshape to 2d
avg_eps3 = reshape(avg_eps3, numRow, numCol);

% plot       
imagesc(avg_eps3)
colorbar
