function [X,Y,S] = sri_data(skf,T, H)

ntargets = round(T/120);
xbounds = [-5 5];
ybounds = [-5 5];

targets(1,:) = xbounds(1) + diff(xbounds).*rand(1,ntargets);
targets(2,:) = ybounds(1) + diff(ybounds).*rand(1,ntargets);

pos = [0 0]';
start_pos = pos;
t = 1;
X = zeros(4,10000);
S = zeros(1,10000);
for tgt=1:ntargets
    vel = (targets(:,tgt)-pos)/100;
    X(3:4,t:t+79) = repmat(vel,[1 80]);
    X(3:4,t+80:t+129) = repmat([0 0]',[1 50]);
    S(t:t+79)=1;
    S(t+80:t+129)=2;
    t = t + 130;
    pos = targets(:,tgt);
end
X(1:2,1) = start_pos;
for t=2:T
    X(1:2,t) = X(1:2,t-1)+X(3:4,t);
end

X(3:4,:) = X(3:4,:);
X = X(:,1:T);

Y = H*X;
S = S(1:T);
