%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script to first create reward variables, then 
% creat choices based on a certain probability
% and learning rate and then perform glmfit.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% x - covariates: 1 - reward, 2 - choices, (3 - side bias)
% y - observed responses


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate data

num_trials = 400;
block_size = 50;
block_variability = 10;

reward1 = [300, 200, 275, 225, 255, 245];
reward2 = [200, 300, 225, 275, 245, 255];
reward_variability = 20;

high_reward = max(reward1(1),reward2(1));
low_reward = min(reward1(1),reward2(1));

high_target_triangle = 1;

probability_correct = 0.85;

triangle_reward = zeros(num_trials,1);
circle_reward = zeros(num_trials,1);

target_choice = zeros(num_trials,1);

current_block_size = floor(block_size+rand(1)*block_variability);

learning_rate = 10;
j = 0;
% Generate reward values
% Generate choices 1 - triangle 0 -circl
for i = 1:num_trials
    if(j == current_block_size)
        j = 0;
        high_target_triangle = mod(high_target_triangle+1,2);
        current_block_size = floor(block_size+rand(1)*block_variability);
    end
    if(high_target_triangle)
        triangle_reward(i) = high_reward + (rand(1)-0.5)*reward_variability; 
        circle_reward(i) = low_reward + (rand(1)-0.5)*reward_variability; 
    else
        circle_reward(i) = high_reward + (rand(1)-0.5)*reward_variability; 
        triangle_reward(i) = low_reward + (rand(1)-0.5)*reward_variability; 
    end

    j = j+1;

    if(j < learning_rate)
        if(high_target_triangle)
            if(rand(1) < probability_correct/(learning_rate - j))
                target_choice(i) = 1;
            else
                target_choice(i) = 0;
            end
        else
            if(rand(1) < probability_correct/(learning_rate - j))
                target_choice(i) = 0;
            else
                target_choice(i) = 1;
            end
        end
    else
        if(high_target_triangle)
            if(rand(1) < probability_correct)
                target_choice(i) = 1;
            else
                target_choice(i) = 0;
            end
        else
            if(rand(1) < probability_correct)
                target_choice(i) = 0;
            else
                target_choice(i) = 1;
            end
        end
    end
end

figure
hold on;
%plot(circle_reward,'r')
plot(triangle_reward,'k')
plot(target_choice*high_reward,'b+')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create reward history

% First generate array of reward received.

reward_received = triangle_reward.*target_choice + circle_reward.*(~target_choice);

figure
plot(reward_received)

reward_history = [reward_received(3:end-1), reward_received(2:end-2), reward_received(1:end-3)];
reward_history = reshape(reward_history, length(reward_received)-3,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create choice history

choice_history = [target_choice(3:end-1), target_choice(2:end-2), target_choice(1:end-3)];
choice_history = reshape(choice_history,length(target_choice)-3,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[b,dev,stats] = glmfit([reward_history,choice_history],target_choice(4:end),'binomial','constant','off')

yfit = glmval(b,[reward_history,choice_history],'logit','constant','off');
plot(yfit,'x')
hold on;
plot(target_choice(4:end),'r+')

model_choice = yfit;
model_choice(find(model_choice > 0.5)) = 1;
model_choice(find(model_choice <= 0.5)) = 0;
plot(model_choice,'kx')


