function createRewardschedules(labview, day, reward_range, reward_corr_thresh, overwrite_flag,rng_seed)
%
% createRewardschedules(labview, day, reward_range, reward_corr_thresh, overwrite_flag)


%%
global MONKEYNAME MONKEYDIR

if nargin < 1; labview = ''; end
if nargin < 2; day = ''; fprintf('WARNING: setting default date'); end
if nargin < 3; reward_range = [220 400]; end % ms
if nargin < 4; reward_corr_thresh = 1e-4; end
if nargin < 5; overwrite_flag = 0; end
if nargin < 6; rng_seed = str2num(day); end

base_path = ('/mnt/pesaranlab/LabVIEW Data/');
if ~exist([base_path labview])
    error('Unknown Labview folder')
end
filename_labview = sprintf('%s%s/RewardSchedules.%s.txt',base_path,labview,day);
filename_matlab = sprintf('%s%s/RewardSchedules.%s.mat',base_path,labview,day);
if exist(filename_labview,'file') && overwrite_flag == 0
    error('reward schedule file already exists for this date')
end
    

%% Parameters
ntrials = 3000; % number of trials, hardcoded in labview
%ntrials_analysis = 1000; % number of trials analyzed for pics. Most likely number of trials animal actually sees.
%2 = 2; % number of schedules
dmin = reward_range(1); % minimal value in ms
dmax = reward_range(2); % maximal value in ms

lambda = 0.9836;
theta = (dmax+dmin)/2; % decay center (dmax+dmin)/2
sd_walk = .05 .* theta; % standard deviation of the gaussian from which samples are drawn
sd_diffusion = .036 .* theta; % standard deviation of the noise .056 = 2.8/50
constant_pace = (1-lambda).*theta;

%% generate drifts
rng(rng_seed); % random generator seed

% preallocation of reward values
r = zeros(2,ntrials); % one pair of drifts

corr_chk = 1;
loopcount=0;
tic
while corr_chk 
    loopcount=loopcount+1;
    % Initial values drawn from flat distribution across possible value range
     r(:,1) = dmin+rand(2,1).*(dmax-dmin);
    for itrial=2:ntrials
        % calculate new mean for gaussian from which new sample is drawn
        mu = lambda.*r(:,itrial-1) + constant_pace + randn(2,1).*sd_diffusion;
        newval = mu+randn(2,1).*sd_walk;
                      
        % make sure new values are within range
        while any(newval<dmin | newval>dmax)
            idx_oor = find(newval<dmin | newval>dmax); % idx_oor = index of the value out of range
            for ioor = 1:numel(idx_oor)
                newval(idx_oor(ioor)) = mu(idx_oor(ioor))+randn.*sd_walk; % try a new step
            end
        end
                
        % update the reward values
        r(:,itrial) = newval;
    end

    rz=(r-repmat(mean(r,2),1,ntrials))./repmat(std(r,[],2),1,ntrials);
    reward_corr=(rz*rz')./ntrials;
    if abs(reward_corr(1,2)) <= reward_corr_thresh
        corr_chk = 0;
    end
%     fprintf('\rLoop Iteration %d, %.2fs reward correlations: %.3f ',loopcount,toc,reward_corr)
end
fprintf('success!\n')

% round to closest integer
r = round(r);

% make sure reward drifts can not have identical values, randomly add or
% subtract 1ms from either drift in that case.
id = find((r(1,:)./r(2,:))==1); shift = [1 -1];
for iid = 1:numel(id)
    driftswitch = round(rand); signswitch = round(rand);
    r(1+driftswitch,id(iid)) = r(1+driftswitch,id(iid)) + shift(1+signswitch);
end

% write out text file for LabVIEW
dlmwrite(filename_labview, r')
save(filename_matlab,'r','rng_seed')

% r=r(:,1:ntrials_analysis); % further analyze only trials that the animal will see
% 
% keyboard
% 
% % analyze stats and print figure
% % plot rewards
% subplot(1,3,1)
% rmax=max(rraw);
% rmax=cumsum(rmax);
% idx100ml = find(abs(rmax-100) == min(abs(rmax-100)));
% 
% plot(r')
% hold on
% plot(1:ntrials_analysis,theta_conv.*ones(1,ntrials_analysis),'k');
% plot(1:ntrials_analysis,dlow_conv.*ones(1,ntrials_analysis),'k');plot(1:ntrials_analysis,dhigh_conv.*ones(1,ntrials_analysis),'k');
% plot(ones(1,2).*idx100ml,ones(1,2).*[dmin_conv dmax_conv],'r')
% xlabel('Trials')
% ylabel('Reward Dur [ms]')
% axis tight square
% ylim([dmin_conv dmax_conv])
% tit = sprintf('l=%.4f,sw=%.1f,sd=%.1f',lambda,sd_walk./theta*100,sd_diffusion./theta*100); % title
% title(tit)
% 
% % number of crossings, length of stable differences, avg reward, avg
% % frantional income
% d = r(1,:)-r(2,:);
% 
% % average difference
% subplot(1,3,2)
% nhist=100;
% edges_ad = linspace(0,dmax_conv-dmin_conv,nhist);
% ad = histc(abs(d),edges_ad);
% ad_cumsum = cumsum(ad./ntrials_analysis*100);
% idx50 = find(abs((ad_cumsum-50)) == min(abs(ad_cumsum-50)));
% [AX,H1,H2] = plotyy(edges_ad,ad,edges_ad,ad_cumsum,'bar','plot');
% set(AX(2),'Ylim',[0 100]);set(AX(1),'Xlim',[0 dmax_conv-dmin_conv]); set(AX(2),'Xlim',[0 dmax_conv-dmin_conv]);
% hold on
% plot(ones(1,2).*edges_ad(idx50),[0 100],'r')
% xlabel('Reward Difference [ms]')
% ylabel(AX(1),'n of Trials')
% ylabel(AX(2),'Cumulative sum of trials [%]')
% axis(AX(1),'square');axis(AX(2),'square');
% title(sprintf('Median Diff: %.2f',edges_ad(idx50)))
% grid on
% 
% subplot(1,3,3)
% edges_nstable = round(linspace(1,ntrials_analysis,nhist));
% % binary difference
% db = d>0;
% % number of crossings
% ncross = numel(find(diff(db)~=0));
% % number of trials before crossing
% nstable = histc(diff(find(diff(db)~=0)),edges_nstable);
% maxnstable = max(diff(find(diff(db)~=0)));
% idxmax = find(abs(edges_nstable-maxnstable) == min(abs(edges_nstable-maxnstable)));
% bar(edges_nstable(1:idxmax),nstable(1:idxmax))
% idx20stable = min(find(edges_nstable>=20));
% %     set(gca,'YTick',[0 1 2 5 10 50 100])
% %     set(gca,'YTickLabel',[0 1 2 5 10 50 100])
% xlim([0 edges_nstable(idxmax+1)])
% xlabel('n of stable trials')
% ylabel('n of periods')
% title(sprintf('%d Crossings, %d longer than 20 trials',ncross,sum(nstable(idx20stable:end))))
% axis square tight
% grid on
% print(sprintf('%sRewardSchedules.%s.eps',RESDIR,day{id}),'-depsc')
% 
