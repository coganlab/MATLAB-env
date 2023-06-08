function plotChoice(Sess, Trials_to_Plot)
% Takes in Trial data and plots choice of circle vs reward magnitude.
%
% plotChoice(session, trials_to_plot)
%
%   SESS    =   Cell array.  Session information
%   TRIALS_TO_PLOT = Numerical array of the subset of trials to plot e.g. [1:200]
%


global saccades_trials_after_reach
global switch_index
global task_code
global ReachCode
global SaccadeCode
global ReachSaccadeCode
global correct
global Rt
global St_1
global block_trial_num
global MONKEYDIR

ReachCode = 10;
SaccadeCode = 12;
ReachSaccadeCode = 13;


THRESHOLD = 5;
Trials_all = sessTrials(Sess);
choice_task = [Trials_all.Choice];
task_code = [Trials_all.TaskCode];

% Find the choice trials that we are interested in
trial_indexes = (choice_task == 2) + (task_code == ReachCode) + ...
    (task_code == SaccadeCode) + (task_code == ReachSaccadeCode);
Trials = Trials_all(find(trial_indexes == 2));

if nargin < 2
    Trials_to_Plot = [1:length(Trials)];
end



Trials_choice = Trials(Trials_to_Plot);

% Further break the trials down into target directions


for targ = 1:4
    disp(['Now processing choice trials in direction ' num2str(targ)]);
    Trials = Trials_choice(union(find([Trials_choice.Target] == targ),find([Trials_choice.Target] == targ+4)));

    number_trials = length(Trials)
    if(number_trials > 80)
        task_code = [Trials.TaskCode];
        total_number_trials = number_trials;
        %Find circle target location 1, 2,4 - triangle right, circle left; 1,3 - triangle
        %left, circle right For target 5 2,4  triangle left; 1,3 triangle right
        reward_config = [Trials.RewardConfig];

        if(isfield(Trials,'SaccadeCircleTarget'))
            Saccade_Circle_Target_Placement = [Trials.SaccadeCircleTarget];
            Reach_Circle_Target_Placement = [Trials.ReachCircleTarget];
            Saccade_Circle_Target_Placement(find(task_code ~= SaccadeCode)) = 0;
            Saccade_Circle_Target_Placement(find(task_code ~= ReachSaccadeCode)) = 0;
            Reach_Circle_Target_Placement(find(task_code ~= ReachCode)) = 0;
            Circle_Target_Placement = Saccade_Circle_Target_Placement...
                + Saccade_Circle_Target_Placement + Reach_Circle_Target_Placement;
        else
            %Change array so that the location of the circle target is indicated
            hand_target = [Trials.Target];
            eye_target = [Trials.EyeTarget];
            Circle_Target_Placement = choiceFindCircleTargetPlacement(reward_config,hand_target,eye_target,task_code);
        end

        if(isfield(Trials,'ReachChoice'))
            eyechoice = [Trials.ReachChoice];
            handchoice = [Trials.SaccadeChoice];
        else
            % Get the hand and eye end locations
            [handlocx handlocy eyelocx eyelocy] = getHandEyeLoc(Trials);

            % Threshold the data
            handlocx = choiceThresholdMovements(handlocx,THRESHOLD);
            handlocy = choiceThresholdMovements(handlocy,THRESHOLD);
            eyelocx = choiceThresholdMovements(eyelocx,THRESHOLD);
            eyelocy = choiceThresholdMovements(eyelocy,THRESHOLD);

            % Use the threshold values to decide which coordinate was chosen
            % Hacked to
            % go either left or right

            eyechoice = choiceFindMovementLocation(eyelocx,eyelocy);
            handchoice = choiceFindMovementLocation(handlocx,handlocy);
        end

        average_times_right_reach_chosen = (length(find(handchoice == targ)))/number_trials
        average_times_left_reach_chosen = (length(find(handchoice == targ+4)))/number_trials
        average_times_right_sacc_chosen = (length(find(eyechoice == targ)))/number_trials
        average_times_left_sacc_chosen = (length(find(eyechoice == targ+4)))/number_trials

        % Use the target placement and end hand location to decide which target was
        % chosen - 1 means the circle was chosen

        Target_Chosen = choiceFindCircleTargetChosen(task_code, Circle_Target_Placement, eyechoice, handchoice);
        average_circle_target_chosen = mean(Target_Chosen)

        %         reward = [Trials.RewardDur];
        %         reward = reshape(reward,4,length(reward)/4);
        %         reward = reward';
        %         reward1 = reward(:,1);
        %         reward2 = reward(:,2);
        %
        %         plot(reward1,'b')
        %         hold
        %         plot(reward2,'r')
        %         figure
        %
        %         % Correct for noisy reward
        %         diff_reward = reward1-reward2;
        %         diff_reward = filter([1/3,1/3,1/3],[1],diff_reward);
        %         plot(diff_reward)
        %         diff_reward(find(diff_reward > 0)) = 1;
        %         diff_reward(find(diff_reward < 0)) = -1;
        %         switch_point = diff(diff_reward);
        % %         size(diff_reward)
        % %         tmp_reward = filter([1/3,1/3,1/3],[1],[diff_reward(1);diff_reward])';
        % %         figure
        % %         plot(tmp_reward)
        % %         filt_reward = tmp_reward(diff_reward(2:end));
        % %         filt_reward(find(diff_reward == 0)) = filt_reward(find(diff_reward == 0)-1)
        %          plot(diff_reward)
        % %         hold on;
        % %         plot(filt_reward,'r')
        %         switch_index = find(switch_point ~= 0);
        %         correct = zeros(number_trials,1);
        %
        %         for i = 1:number_trials
        %             if(Target_Chosen(i) == 0)
        %                 if(reward1(i) > reward2(i))
        %                     correct(i) = 0;
        %                 else
        %                     correct(i) = 1;
        %                 end
        %             else
        %                 if(reward1(i) > reward2(i))
        %                     correct(i) = 1;
        %                 else
        %                     correct(i) = 0;
        %                 end
        %             end
        %         end

        correct = calcCorrectChoice(Trials);

        reward_dist = [Trials.RewardDist];
        reward_dist = reshape(reward_dist, 4, length(Trials))';
        diff_reward = reward_dist(:,1) - reward_dist(:,2);
        diff_reward(find(diff_reward > 0)) = 1;
        diff_reward(find(diff_reward < 0)) = 0;
        switch_point = diff(diff_reward);
        switch_index = find(switch_point ~= 0);

        average_correct = zeros(1,length(Trials_to_Plot));
        average_correct(:) = mean(correct);
        average_correct_trials = average_correct(1)


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Plot correct choices
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        plot_correct = 0;
        saccade_trials = task_code == SaccadeCode;
        reach_trials = task_code == ReachCode;
        reachsaccade_trials = task_code == ReachSaccadeCode;
        tmp_correct = correct;
        tmp_correct(tmp_correct == 0) = -1;
        if(plot_correct)
            figure;
            hold on;
            bar((tmp_correct' .* saccade_trials),'r')
            bar((tmp_correct' .* reach_trials),'g')
            bar((tmp_correct' .* reachsaccade_trials),'y')

            axis tight
        end

        window = 8;
        filter_coeff = zeros(1,window);
        filter_coeff(:) = 1/window;
        window2 =20;
        filter_coeff2 = zeros(1,window2);
        filter_coeff2(:) = 1/window2;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Plot handchoice
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        plot_hand_choice = 0;
        if(plot_hand_choice == 1)
            figure

            y = filter(filter_coeff,1,handchoice);
            plot(y)
            title('Filtered hand choice (5 = right)')
            hold on;
            y =  filter(filter_coeff2,1,handchoice);
            plot(y,'r')
            for i = 1:length(switch_point)
                if(switch_point(i) == 0)
                else
                    plot([i,i], [0,5],'g','LineWidth',4);
                end
            end
            axis tight
        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Plot shape choice
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        plot_shape_choice = 0;
        if(plot_shape_choice == 1)
            figure;
            y = filter(filter_coeff,1,Target_Chosen);
            plot(y)
            title('Filtered shape choice (1 = circle)')
            hold on;
            y =  filter(filter_coeff2,1,Target_Chosen);
            plot(y,'r')
            plot(average_correct,'k');
            for i = 1:length(switch_point)
                if(switch_point(i) == 0)
                else
                    plot([i,i], [0,1],'g','LineWidth',4);
                end
            end
            axis tight
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Plot number correct
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        plot_correct_choice = 0;
        if(plot_correct_choice)
            figure;
            y = filter(filter_coeff,1,correct);
            plot(y,'b')
            title('Filtered correct choices (1 = correct)')
            hold on;
            y =  filter(filter_coeff2,1,correct);
            plot(y,'r')
            plot(average_correct,'g');
            for i = 1:length(switch_point)
                if(switch_point(i) == 0)
                else
                    plot([i,i], [0,1],'g','LineWidth',4);
                end
            end
            axis tight
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Plot number correct saccade trials
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        plot_saccades = 0;
        if(plot_saccades)
            figure
            saccades_only = correct(find(task_code == SaccadeCode));
            average_saccades = mean(saccades_only)
            y = filter(filter_coeff,1,saccades_only);
            plot(y)
            hold on;
            y = filter(filter_coeff2,1,saccades_only);
            plot(y,'r')
            title('Correct saccade only trials')
            ave_saccades = zeros(1,length(saccades_only));
            ave_saccades(:) = average_saccades;
            plot(ave_saccades,'k')
            axis tight;
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Plot number correct reach trials
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        plot_reach = 0;
        if(plot_reach)
            figure;
            reach_only = correct(find(task_code == ReachCode));
            average_reach = mean(reach_only)
            y = filter(filter_coeff,1,reach_only);
            plot(y)
            hold on;
            y = filter(filter_coeff2,1,reach_only);
            plot(y,'r')
            title('Correct reach only trials')
            ave_reach = zeros(1,length(reach_only));
            ave_reach(:) = average_reach;
            plot(ave_reach,'k')
            axis tight;
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Plot number correct saccade reach trials
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        plot_reach = 0;
        if(plot_reach)
            figure;
            reach_saccade = correct(find(task_code == ReachSaccadeCode));
            average_reach_saccade = mean(reach_saccade)
            y = filter(filter_coeff,1,reach_saccade);
            plot(y)
            hold on;
            y = filter(filter_coeff2,1,reach_saccade);
            plot(y,'r')
            title('Correct reach saccade trials')
            ave_reach_saccade  = zeros(1,length(reach_saccade));
            ave_reach_saccade(:) = average_reach_saccade ;
            plot(ave_reach_saccade ,'k')
            axis tight;
        end
        %find the longest block size

        if(~sum(switch_point))
            max_block_size = length(switch_point);
        else
            tmp = find(switch_point ~= 0);
            n = [1:length(tmp)-1];
            max_block_size = max(tmp(n(:)+1)-tmp(n(:)))+2;
        end
        [reach_correct,average_reach_correct,reach_count, reach_count_correct] = choiceCreateCorrectArray(task_code, ReachCode, correct, switch_point,max_block_size);
        [saccade_correct,average_saccade_correct,saccade_count,saccade_count_correct] = choiceCreateCorrectArray(task_code, SaccadeCode, correct, switch_point,max_block_size);
        [reach_sacc_correct,average_reach_sacc_correct,reach_sacc_count,reach_sacc_count_correct] = choiceCreateCorrectArray(task_code, ReachSaccadeCode, correct, switch_point,max_block_size);


        % Average then get rid of spots where there are no trials
        average_reach_correct = average_reach_correct./reach_count;
        average_reach_correct(find(reach_count == 0)) = 0;
        average_saccade_correct = average_saccade_correct./saccade_count;
        average_saccade_correct(find(saccade_count == 0)) = 0;
        average_reach_sacc_correct = average_reach_sacc_correct./reach_sacc_count;
        average_reach_sacc_correct(find(reach_sacc_count == 0)) = 0;

        plot_average_choices = 1;
        if(plot_average_choices)
            figure;
            y = filter(filter_coeff,1,reach_correct);
            plot(y,'b')
            hold on;
            y = filter(filter_coeff,1,saccade_correct);
            plot(y,'r')
            hold on;
            y = filter(filter_coeff,1,reach_sacc_correct);
            plot(y,'y')
            for i = 1:length(switch_point)
                if(switch_point(i) == 0)
                else
                    plot([i,i], [-1,1],'g','LineWidth',4);
                end
            end
            title('Blue is reach correct, Red saccade correct, Yellow reach Sacccade')




            figure
            subplot(6,1,6)
            bar(saccade_count_correct,'r')
            hold on;
            bar(saccade_count_correct - saccade_count,'k')
            axis([0 max_block_size min(saccade_count_correct - saccade_count) max(saccade_count_correct)+1])


            subplot(6,1,5)
            bar(reach_count_correct,'g')
            hold on;
            bar(reach_count_correct - reach_count,'k')
            axis([0 max_block_size min(reach_count_correct - reach_count) max(reach_count_correct)+1])
            subplot(6,1,4)
            bar(reach_sacc_count_correct,'y')
            hold on;
            bar(reach_sacc_count_correct - reach_sacc_count,'k')
            axis([0 max_block_size min(reach_sacc_count_correct - reach_sacc_count) max(reach_sacc_count_correct)+1])
            subplot(2,1,1)
            y = average_reach_correct;
            y = filter(filter_coeff,1,average_reach_correct);
            plot(y,'g')
            axis([0 max_block_size -1 1])
            hold on;
            y = average_saccade_correct;
            y = filter(filter_coeff,1,average_saccade_correct);
            plot(y,'r')
            y = average_reach_sacc_correct;
            y = filter(filter_coeff,1,average_reach_sacc_correct);
            plot(y,'y')
            pid = plot([0,max_block_size],[0,0],':','Color',[0.1,0.1,0.1])
            %plot([0,max_block_size],[0.5,0.5],':','Color',[0.1,0.1,0.1])
            %plot([0,max_block_size],[-0.5,-0.5],':','Color',[0.1,0.1,0.1])
            pid = title([Sess{1} ' Ave filt correct choice, Red Sacc, Blue Reach, Yellow Reach+Sacc, Targ' num2str(targ)])

            filename = [MONKEYDIR,'/','fig/Behavior','/',num2str(Sess{6}),'_Average_Correct_Target',num2str(targ)]
            saveas(pid, [filename,'.jpg'],'jpg')
            saveas(pid, [filename,'.eps'],'eps')
            saveas(pid, [filename,'.tif'],'tif')
        end

        points_to_analyze = 25;
        [reach_count_switch, reach_count_correct_switch] = choiceCreateCorrectArraySwitch(task_code, ReachCode, correct, switch_index,points_to_analyze);
        [saccade_count_switch,saccade_count_correct_switch] = choiceCreateCorrectArraySwitch(task_code, SaccadeCode, correct, switch_index,points_to_analyze);
        [reach_sacc_count_switch,reach_sacc_count_correct_switch] = choiceCreateCorrectArraySwitch(task_code, ReachSaccadeCode, correct, switch_index,points_to_analyze);


        polarity_shift = [zeros(1,points_to_analyze)-1,ones(1,points_to_analyze)];
        average_reach_correct_switch = ((reach_count_correct_switch + (abs(reach_count_correct_switch) - reach_count_switch).*polarity_shift))./reach_count_switch;
        average_reach_correct_switch(find(reach_count_switch == 0)) = 0;
        average_saccade_correct_switch = ((saccade_count_correct_switch + (abs(saccade_count_correct_switch) - saccade_count_switch).*polarity_shift))./saccade_count_switch;
        average_saccade_correct_switch(find(saccade_count_switch == 0)) = 0;
        average_reach_sacc_correct_switch = ((reach_sacc_count_correct_switch + (abs(reach_sacc_count_correct_switch) - reach_sacc_count_switch).*polarity_shift))./reach_sacc_count_switch;
        average_reach_sacc_correct_switch(find(reach_sacc_count_switch == 0)) = 0;

        if(plot_average_choices)
            window = 5;
            filter_coeff = zeros(1,window);
            filter_coeff(:) = 1/window;
            figure
            subplot(6,1,6)
            bar(saccade_count_correct_switch,'r')
            hold on;
            tmp_array = (abs(saccade_count_correct_switch) - saccade_count_switch).*polarity_shift;
            bar(tmp_array,'k')
            axis([window 2*(points_to_analyze)-window min(min(tmp_array,saccade_count_correct_switch)) max(max(tmp_array,saccade_count_correct_switch))+1])
            set(gca,'XTickLabel',[-points_to_analyze+ window:5:points_to_analyze - window])

            subplot(6,1,5)
            bar(reach_count_correct_switch,'g')
            hold on;
            tmp_array = (abs(reach_count_correct_switch) - reach_count_switch).*polarity_shift;
            bar(tmp_array,'k')
            axis([window 2*(points_to_analyze)-window min(min(tmp_array,reach_count_correct_switch)) max(max(tmp_array,reach_count_correct_switch))+1])

            set(gca,'XTickLabel',[-points_to_analyze+window:5:points_to_analyze-window])
            subplot(6,1,4)
            bar(reach_sacc_count_correct_switch,'y')
            hold on;
            tmp_array = (abs(reach_sacc_count_correct_switch) - reach_sacc_count_switch).*polarity_shift;
            bar(tmp_array,'k')
            axis([window 2*(points_to_analyze) - window min(min(tmp_array,reach_sacc_count_correct_switch)) max(max(tmp_array,reach_sacc_count_correct_switch))+1])
            set(gca,'XTickLabel',[-points_to_analyze + window:5:points_to_analyze - window])

            subplot(2,1,1)
            y = average_reach_correct_switch;
            y = filter(filter_coeff,1,average_reach_correct_switch);
            plot(y,'g')
            set(gca,'XTickLabel',[-points_to_analyze + window:5:points_to_analyze - window])
            hold on;
            y = average_saccade_correct_switch;
            y = filter(filter_coeff,1,average_saccade_correct_switch);
            plot(y,'r')
            y = average_reach_sacc_correct_switch;
            y = filter(filter_coeff,1,average_reach_sacc_correct_switch);
            plot(y,'y')
            pid = plot([0,2*points_to_analyze],[0,0],':','Color',[0.1,0.1,0.1]);
            axis([window 2*(points_to_analyze) - window -1.1 1.1])
            set(gca,'XTickLabel',[-points_to_analyze + window:5:points_to_analyze - window])
            %plot([0,max_block_size],[0.5,0.5],':','Color',[0.1,0.1,0.1])
            %plot([0,max_block_size],[-0.5,-0.5],':','Color',[0.1,0.1,0.1])
            pid = title([Sess{1} ' Aver filt correct choice, Red Sacc, Blue Reach, Yellow Reach+Sacc Targ' num2str(targ)]);

            filename = [MONKEYDIR,'/','fig/Behavior','/',num2str(Sess{6}),'_Average_Correct_Switch_Target',num2str(targ)]
            saveas(pid, [filename,'.jpg'],'jpg')
            saveas(pid, [filename,'.eps'],'eps')
            saveas(pid, [filename,'.tif'],'tif')
        end
        [reward_values, percentageCorrect, number_trials] = choicePercentageCorrect(correct, reward_dist)



        % Find percentage correct for each trial type
        saccade_correct = correct(find(task_code == SaccadeCode));
        saccade_reward_dist = reward_dist(find(task_code == SaccadeCode),:);
        [saccade_reward_values, saccade_percentageCorrect, saccade_number_trials] = choicePercentageCorrect(saccade_correct, saccade_reward_dist)

        reach_correct = correct(find(task_code == ReachCode));
        reach_reward_dist = reward_dist(find(task_code == ReachCode),:);
        [reach_reward_values, reach_percentageCorrect, reach_number_trials] = choicePercentageCorrect(reach_correct, reach_reward_dist)

        reachsaccade_correct = correct(find(task_code == ReachSaccadeCode));
        reachsaccade_reward_dist = reward_dist(find(task_code == ReachSaccadeCode),:);
        [reachsaccade_reward_values, reachsaccade_percentageCorrect, reachsaccade_number_trials] = choicePercentageCorrect(reachsaccade_correct, reachsaccade_reward_dist)

        % convert to percent circle choice
        percentageCorrect(1:length(percentageCorrect)/2) = 1 - percentageCorrect(1:length(percentageCorrect)/2)
        reach_percentageCorrect(1:length(reach_percentageCorrect)/2) = 1 - reach_percentageCorrect(1:length(reach_percentageCorrect)/2)
        saccade_percentageCorrect(1:length(saccade_percentageCorrect)/2) = 1 - saccade_percentageCorrect(1:length(saccade_percentageCorrect)/2)
        reachsaccade_percentageCorrect(1:length(reachsaccade_percentageCorrect)/2) = 1 - reachsaccade_percentageCorrect(1:length(reachsaccade_percentageCorrect)/2)

        figure
        plot(percentageCorrect,'x','MarkerSize',10)
        hold
        plot(reach_percentageCorrect,'+','MarkerSize',10)
        plot(saccade_percentageCorrect,'o','MarkerSize',10)

        for p = 1:length(reward_values)
            %            xlabelstring{p} = [num2str(reward_values(p)) '/' num2str(reward_values(length(reward_values) + 1- p))]; xlabelstring{p} = [num2str(reward_values(p)) '/' num2str(reward_values(length(reward_values) + 1- p))];
            xlabelstring{p} = num2str(reward_values(p));
        end
        set(gca,'XTickLabel', xlabelstring);
        xlabel('Relative Circle Reward')
        ylabel('Percentage Circle Choice')
        figure

        saccade.correct = saccade_percentageCorrect;
        reach.correct = reach_percentageCorrect;
        reachsaccade.correct = reachsaccade_percentageCorrect;
        saccade.n = saccade_number_trials;
        reach.n = reach_number_trials;
        reachsaccade.n = reachsaccade_number_trials;
        x1 = reach_reward_values;
        x2 = fliplr(reach_reward_values);

        saccade.x = x1./(x1+x2);
        saccade.x = x1-x2;
        reach.x = x1 - x2;
        reachsaccade.x = x1 - x2;

        %f = fittype('1./(1 + exp(-(x-b)./a))');
        %
        %f = fittype('a./(b*exp(-d*x)+c)');
        %
        %options = fitoptions('Method', 'NonlinearLeastSquares','Algorithm','Levenberg-Marquardt');
        %
        %reachfit = fit((x1-x2)',reach_correct',f,options);
        %
        %saccadefit = fit((x1-x2)',saccade_correct',f,options);

        saccade.y = [round(saccade.correct.*saccade.n)' saccade.n'];
        [saccade.b,dev,saccade.stats] = glmfit(saccade.x', saccade.y, 'binomial', 'link', 'logit');
        saccade.xfit = linspace(-200,200,40);
        [saccade.yfit,saccade.dlow,saccade.dhi] = glmval(saccade.b,saccade.xfit,'logit',saccade.stats,'size',100);

        reach.y = [round(reach.correct.*reach.n)' reach.n'];
        saccade.y
        [reach.b,dev,reach.stats] = glmfit(reach.x', reach.y, 'binomial', 'link', 'logit');
        reach.xfit = linspace(-200,200,40);
        [reach.yfit,reach.dlow,reach.dhi] = glmval(reach.b,reach.xfit,'logit',reach.stats,'size',100);

        if(length(reachsaccade_percentageCorrect) == length(reach_percentageCorrect))
            reachsaccade.y = [round(reachsaccade.correct.*reachsaccade.n)' reachsaccade.n'];
            [reachsaccade.b,dev,reachsaccade.stats] = glmfit(reachsaccade.x', reachsaccade.y, 'binomial', 'link', 'logit');
            reachsaccade.xfit = linspace(-200,200,40);
            [reachsaccade.yfit,reachsaccade.dlow,reachsaccade.dhi] = glmval(reachsaccade.b,reachsaccade.xfit,'logit',reachsaccade.stats,'size',100);
        end
        
        clf; hold on;
        h = plot(reach.xfit,reach.yfit./100,'g--');
        set(h,'Linewidth',2);
        h = plot(saccade.xfit,saccade.yfit./100,'r--');
        set(h,'Linewidth',2);
        h = plot(reach.x, reach.correct,'gx');
        set(h,'Markersize',10);
        h = plot(saccade.x, saccade.correct,'rx');
        set(h,'Markersize',10);
        if(length(reachsaccade_percentageCorrect) == length(reach_percentageCorrect))
            h = plot(reachsaccade.xfit,reachsaccade.yfit./100,'y--');
            set(h,'Linewidth',2);
            h = plot(reachsaccade.x, reachsaccade.correct,'yx');
            set(h,'Markersize',10);
        end
        set(gca,'Fontsize',14);
        xlabel('Circle reward - Triangle reward (ms)');
        ylabel('Probability choose circle');
        axis square
        title([Sess{1} ' Cell: ' num2str(Sess{5}), ', Number Trials: ' num2str(total_number_trials)]);
        plot(reach.xfit,(reach.yfit - reach.dlow)./100,'g');
        plot(reach.xfit,(reach.yfit + reach.dhi)./100,'g');
        plot(saccade.xfit,(saccade.yfit - saccade.dlow)./100,'r');
        pid = plot(saccade.xfit,(saccade.yfit + saccade.dhi)./100,'r');
        filename = [MONKEYDIR,'/','fig/Behavior','/',num2str(Sess{6}),'_Choice_Behaviour',num2str(targ)]
        saveas(pid, [filename,'.jpg'],'jpg')
        saveas(pid, [filename,'.eps'],'eps')
        saveas(pid, [filename,'.tif'],'tif')

        %
        %         % Calculate the average correct trials after the switch point
        %         average_window = 30;
        %         ave_correct = choiceCalculateAverageCorrect(correct, switch_index, average_window);
        %         figure
        %         y = filter(filter_coeff,1,ave_correct);
        %         % plot(y);
        %         % title('Average correct trials')
        %         % axis([0 99 0 1])
        %
        %
        %         % Indices of saccade trials and reach trials
        %         saccades_trials_after_reach = intersect(find(task_code(1:end) == SaccadeCode),find(task_code(1:end) == ReachCode)+1);
        %         % Calculate relativetrial numbers from the switch index
        %         block_trial_num2 = choiceFindRelativeTrialNumbers(length(correct), switch_index);
        %         block_trial_num  = block_trial_num2(saccades_trials_after_reach);
        %
        %         Rt_1=correct(saccades_trials_after_reach-1);
        %         St=correct(saccades_trials_after_reach);
        %         P_St_Rt1 = length(find((Rt_1 & St) == 1))/sum(Rt_1)
        %         P_St_inRt1 = length(find((~Rt_1 & St) == 1))/sum(~Rt_1)
        %
        %         % Find probabilities in the first 80 trials
        %         y = block_trial_num.*Rt_1'.*St';
        %         y = y(find(y<80));
        %         y(find(y>0)) = 1;
        %         z = block_trial_num.*Rt_1';
        %         z = z(find(z <80));
        %         z(find(z > 0)) = 1;
        %         P_St_Rt1_init = sum(y)/sum(z)
        %
        %         % Find probabilities in the first 80 trials
        %         y = block_trial_num.*~Rt_1'.*St';
        %         y = y(find(y<80));
        %         y(find(y>0)) = 1;
        %         z = block_trial_num.*~Rt_1';
        %         z = z(find(z <80));
        %         z(find(z > 0)) = 1;
        %         P_St_inRt1_init = sum(y)/sum(z)
        %
        %         figure
        %         subplot(4,1,1)
        %         hist(block_trial_num.*Rt_1'.*St',length(block_trial_num),'b');
        %         axis([1 200 0 5])
        %         ylabel('St Rt(n-1)')
        %         hold on;
        %         subplot(4,1,2)
        %         hist(block_trial_num.*~Rt_1'.*St',length(block_trial_num),'r');
        %         % y = block_trial_num.*Rt'.*St_1';
        %         % mean(y(find(y > 0)))
        %         axis([1 200 0 5])
        %         ylabel('St ~Rt(n-1)')
        %         subplot(4,1,3)
        %         hist(block_trial_num.*Rt_1'.*St',length(block_trial_num),'b');
        %         axis([1 200 0 5])
        %         ylabel('~St Rt(n-1)')
        %         hold on
        %         subplot(4,1,4)
        %         hist(block_trial_num.*~Rt_1'.*~St',length(block_trial_num),'r');
        %         axis([1 200 0 5])
        %         ylabel('~St ~Rt(n-1)')
        %
        %
        %         %%%%%%%%%
        %         % Prob reach trials correct after saccade trials
        %         %
        %         %%%%%%%%%
        %
        %         reach_trials_after_saccade = intersect(find(task_code(1:end) == ReachCode),find(task_code(1:end) == SaccadeCode)+1);
        %         block_trial_num  = block_trial_num2(reach_trials_after_saccade);
        %
        %
        %         Rt =correct(reach_trials_after_saccade);
        %         St_1 =correct(reach_trials_after_saccade-1);
        %         P_Rt_St1 = length(find((Rt & St_1) == 1))/sum(St_1)
        %         P_Rt_inSt1 = length(find((Rt & ~St_1) == 1))/sum(~St_1)
        %         figure
        %         subplot(4,1,1)
        %         hist(block_trial_num.*Rt'.*St_1',length(block_trial_num),'b');
        %         axis([1 200 0 5])
        %         ylabel('Rt St(n-1)')
        %         hold on;
        %         subplot(4,1,2)
        %         hist(block_trial_num.*Rt'.*~St_1',length(block_trial_num),'r');
        %         axis([1 200 0 5])
        %         ylabel('Rt ~St(n-1)')
        %         subplot(4,1,3)
        %         hist(block_trial_num.*~Rt'.*St_1',length(block_trial_num),'b');
        %         axis([1 200 0 5])
        %         ylabel('~Rt St(n-1)')
        %         hold on
        %         subplot(4,1,4)
        %         hist(block_trial_num.*~Rt'.*~St_1',length(block_trial_num),'r');
        %         axis([1 200 0 5])
        %         ylabel('~Rt ~St(n-1')
        %
        %         % Find probabilities in the first 80 trials
        %         y = block_trial_num.*Rt'.*St_1';
        %         y = y(find(y<80));
        %         y(find(y>0)) = 1;
        %         z = block_trial_num.*St_1';
        %         z = z(find(z <80));
        %         z(find(z > 0)) = 1;
        %         P_Rt_St1_init = sum(y)/sum(z)
        %         Rt_80 = Rt(find(block_trial_num < 80));
        %         St_1_80 = St_1(find(block_trial_num < 80));
        %         correct_reach_80 = Rt_80(find(St_1_80 == 1));
        %         P_Rt_St1_80 = mean(correct_reach_80)%length(find((Rt_80 & St_1_80) == 1))/sum(St_1_80)
        %         P_Rt_St1_80_var = var(correct_reach_80)
        %         correct_saccade_80 = Rt_80(find(St_1_80 == 0));
        %         P_Rt_inSt1_80 = mean(correct_saccade_80)%length(find((Rt_80 & ~St_1_80) == 1))/sum(~St_1_80)
        %         P_Rt_inSt1_80_var = var(correct_saccade_80)
        %
        %         test_stat = (P_Rt_St1_80 - P_Rt_inSt1_80)/...
        %             sqrt(P_Rt_St1_80_var/length(correct_reach_80) + P_Rt_inSt1_80_var/length(correct_saccade_80))
        %
        %         [h,p] = ttest2(correct_reach_80,correct_saccade_80,0.05)
        %         length(correct_reach_80)%
        %
        %         saccade_trials_after_saccade = intersect(find(task_code(1:end) == SaccadeCode),find(task_code(1:end) == SaccadeCode)+1);
        %         St=correct(saccade_trials_after_saccade);
        %         St_1=correct(saccade_trials_after_saccade-1);
        %         P_St_St = length(find((St_1 & St) == 1))/sum(St)
        %
        %
        %         %%%%%%%%%
        %         % Prob reach trials correct after reach saccade trials
        %         %
        %         %%%%%%%%%
        %
        %         reach_trials_after_reachsaccade = intersect(find(task_code(1:end) == ReachCode),find(task_code(1:end) == ReachSaccadeCode)+1);
        %         block_trial_num  = block_trial_num2(reach_trials_after_saccade);
        %
        %
        %         Rt =correct(reach_trials_after_reachsaccade);
        %         RSt_1 =correct(reach_trials_after_reachsaccade-1);
        %         P_Rt_St1 = length(find((Rt & RSt_1) == 1))/sum(RSt_1)
        %         P_Rt_inSt1 = length(find((Rt & ~RSt_1) == 1))/sum(~RSt_1)
    end
end
return
