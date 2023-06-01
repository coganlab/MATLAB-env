function test = project(GMM,Test, SVDParams)
% PROJECT

tapers_time = GMM.tapers_time;
Fs = GMM.Fs;
maxfreq = GMM.maxfreq;
winwidth = GMM.winwidth;
NORMALIZE_FLAG = 0;%XXX: do not hardcode
Mlfp = Test.observ_matrix;
dt = winwidth/10;

true_state_seq = Test.ostate_seq;
true_joy_seq = Test.joy_seq;
state_seq = zeros(size(true_state_seq));
joy_seq = zeros(size(true_joy_seq));
joy_pos = zeros(2,length(true_joy_seq));

for i=1:2
    smooth_joy(i,:) = smooth(Test.joy(i,:),1000);
end

%keyboard
ridx = 1;
midx = 1;

rests = zeros(winwidth,15000);
moves = zeros(winwidth,15000);

feats = zeros(30000,GMM.modes);
% Speed up mode computation



M = zeros(winwidth,30000);
for t=1:dt:(length(true_state_seq)-winwidth)
    idx = (t-1)/dt+1;
    %if ~mod(idx,1000)
%	disp(idx);
%    end
    t_end = t + winwidth - 1;
    % find mode
    state_seq(idx) = mode(true_state_seq(t:t_end));
    joy_seq(idx) = mode(true_joy_seq(t:t_end));
    joy_pos(:,idx) = median(smooth_joy(:,t:t_end),2);
   % if state_seq(idx) == 1
   %     rests(:,ridx) = Mlfp(t:t_end);
   %     ridx = ridx + 1;
   % else
   %     moves(:,midx) = Mlfp(t:t_end);
   %     midx = midx + 1;
   % end
    M = Mlfp(t:t_end);
    spec = dmtspec(M,[tapers_time,5],Fs,[maxfreq]);
    lspec = log(spec);
    feature_matrix = lspec * SVDParams.V/SVDParams.S;
    norm_feat = zeros(1,GMM.modes);
    for iMode =1:GMM.modes
	MyMode = SVDParams.ModeInd(iMode);
	%norm_feat(MyMode) = (feature_matrix(MyMode)-SVDParams.MeanU(MyMode))/SVDParams.Norm_factor(MyMode);
	norm_feat(iMode) = (feature_matrix(MyMode)-mean(SVDParams.U(:,MyMode)))/SVDParams.Norm_factor(MyMode);
    end
    feats(idx,:) = norm_feat;
end
feats = feats(1:idx,:);
state_seq = state_seq(1:idx);
joy_seq = joy_seq(1:idx);
joy_pos = joy_pos(:,1:idx);
rests = find(state_seq == 1);
moves = find(state_seq == 2);

test.feats = feats;
test.rests = rests;
test.moves = moves;
test.state_seq = state_seq;
test.joy_seq = joy_seq;
test.joy_pos = joy_pos;
test.joy_vel = [diff(joy_pos,1,2) [0;0]];
test.joy_accel = [diff(test.joy_vel,1,2) [0;0]];

test.Y = feats';
test.X(1:2,:) = test.joy_pos;
test.X(3:4,:) = test.joy_vel;
test.X(5:6,:) = test.joy_accel;

%keyboard


