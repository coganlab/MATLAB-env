function [X,Y,S,T] = load_neural_data(data_dir,rec,data_name,xdims,ydims,T)
%LOAD_NEURAL_DATA


if nargin > 5
    Y = zeros(ydims, T);
else
    T = Inf;
end

for ch=1:length(rec.chs)
    if ch*rec.feats > ydims
       break
   end       
    fn = fullfile(data_dir,rec.day,['rec' rec.rec 'ch' num2str(rec.chs(ch)) '.mat']);
    load(fn);
    data = eval(data_name);
    Td = size(data.feats,1);
    if Td < T
	if T ~= Inf
	    fprintf('Warning: Not enough data. Requested %d, loaded %d\n', T,Td);
	end
	T = Td;
	Y = zeros(ydims,T);
    end
    Y(rec.feats*ch-2:rec.feats*ch,:) = data.feats(1:T,1:rec.feats)';
end
% True joystick features the same for all channels
X = data.X(1:xdims,1:T);

%state_seq == 2 for move state, need to reverse
S = 3-data.state_seq(1:T);

%window = ones(1,WIDTH)/WIDTH;
%joy_pos = donorm(Train.joy);
%joy_posx = conv(joy_pos(1,:),window,'same');
%%joy_posy = conv(joy_pos(2,:),window,'same'); joy_pos = [joy_posx(1:T); joy_posy(1:T)];

%joy_pos = donorm(Train.joy(:,1:30:end));
%joy_pos = joy_pos(:,1:T);
%joy_vel = diff(joy_pos,1,2);
%joy_accel = diff(joy_vel,1,2);

%mag_vel = sqrt(sum(joy_vel.^2,1));
%state = mag_vel < 0.01;
%state = [1 state];
%S = state+1;

%X(1:2,:) = joy_pos;
%X(3:4,2:T) = joy_vel;
%keyboard
%Y = obs.feats';
%Y = H*X;
%Y = Y + randn(size(Y))*noise;
end



function X = donorm(X)
X = X - abs(min(X(:)));
X = 1000*X / max(X(:));
end


