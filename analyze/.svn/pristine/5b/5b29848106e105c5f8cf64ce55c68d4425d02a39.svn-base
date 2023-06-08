function [TrainSeg, TestSeg] = load_data(trial)
%LOAD_DATA Loads all training and testing data
% 
% [TrainSeg, TestSeg] = load_data(trial)
% 
% Inputs:
%   trial = Trial to load
% Outputs:
%   TrainSeg = Training data structure
%   TestSeg = Testing data structure

PLOT_TRIAL = 0;
MIN_VEL = 0.003;
WINSIZE = 725;
DELAY_TIME = 375;
JOY_OFFSET = - [32768, 32768];
JOY_SCALE = 1200;
[Mlfp,segs] = intMlfp(trial.day,trial.rec,trial.sys,trial.ch,trial.state,trial.bn);
[Joy,states] = intJoyTarget(segs,trial.day,trial.rec,trial.state,trial.bn, 300);
offset = ones(size(Joy{1}));
for i=1:length(Joy)
    offset = -32768*ones(size(Joy{i}));
    Joy{i} = (Joy{i} + offset)/JOY_SCALE;
end
%[rest, move] =  
num_segs = length(Mlfp);
idx = 0;
max_idx = 0;
lengths = [];
for i=1:length(Mlfp)
    lengths(i) = length(Mlfp{i});

    % Smooth joystick velocity
    JoyV = joyvel(Joy{i})';
    joy_raw{i} = JoyV;
    JoyF = filter(ones(1,WINSIZE)/WINSIZE,1,JoyV);
    joy_filt{i} = JoyF;

    % Compute move and rest states based on threshold of
    % smoothed joystick velocity
    joy_seq{i} = ones(1,length(Mlfp{i}));
    JoyF3 = JoyF(250:end);
    joy_seq{i}(JoyF3 > MIN_VEL) = 2;
end

% Train on largest segment, test on next large one
[Y,I] = sort(lengths, 'descend');

mend = round(Y(1)*.9);
train = 1:mend;
test = mend+1:Y(1);

if num_segs > 0
    TrainSeg.state_seq = states{I(1)}(train);
    TrainSeg.observ_matrix = Mlfp{I(1)}(train);
    TrainSeg.joy_raw = joy_raw{I(1)}(train);
    TrainSeg.joy_seq = joy_seq{I(1)}(train);
    TrainSeg.joy_filt = joy_filt{I(1)}(train);
    TrainSeg.joy = Joy{I(1)}(:,train);
    TrainSeg.ostate_seq = ones(1,length(train));
    TrainSeg.ostate_seq(DELAY_TIME+1:end) = states{I(1)}(1:train(end)-DELAY_TIME);

    TestSeg.state_seq = states{I(1)}(test);
    TestSeg.observ_matrix = Mlfp{I(1)}(test);
    TestSeg.joy_raw = joy_raw{I(1)}(test);
    TestSeg.joy_seq = joy_seq{I(1)}(test);
    TestSeg.joy_filt = joy_filt{I(1)}(test);
    TestSeg.joy = Joy{I(1)}(:,test);
    TestSeg.ostate_seq = ones(1,length(test));
    TestSeg.ostate_seq(DELAY_TIME+1:end) = states{I(1)}(mend+1:end-DELAY_TIME);


end

return
if num_segs > 1
    TestSeg.state_seq = states{I(2)};
    TestSeg.observ_matrix = Mlfp{I(2)};
    TestSeg.joy_raw = joy_raw{I(2)};
    TestSeg.joy_seq = joy_seq{I(2)};
    TestSeg.joy_filt = joy_filt{I(2)};
    TestSeg.joy = Joy{I(2)};
    TestSeg.ostate_seq = ones(1,Y(2));
    TestSeg.ostate_seq(DELAY_TIME+1:end) = states{I(2)}(1:end-DELAY_TIME);

else
    TestSeg = [];
end

if PLOT_TRIAL
clf
hold all
plot(TrainSeg.state_seq + 6);
plot(TrainSeg.joy_seq + 2);
plot(TrainSeg.ostate_seq + 4);
plot(TrainSeg.joy_raw/30);
axis([0 12000 0 9])
end
