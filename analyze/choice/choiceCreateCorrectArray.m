% For a sequence of trials, creates an array for a specific task
% type with a 1 for a correct trial a -1 for an incorrect trial and
% a 0 if the trial does not match the task type

function [task_correct_array,task_average_correct,task_count,task_count_correct] = choiceCreateCorrectArray(task_code_array, task_code, correct_array, switch_point,max_block_size)

k = 0;


task_correct_array = zeros(1,length(correct_array));
task_average_correct = zeros(1,max_block_size);
task_count = zeros(1,max_block_size);
task_count_correct = zeros(1,max_block_size);
for i = 2:length(correct_array)
    try
        if(switch_point(i-1) == 0)
            k = k+1;
        else
            k = 1;
        end
    catch
        k = k+1;
    end

    if(task_code_array(i) == task_code)
        if(correct_array(i) == 1)
            task_correct_array(i) = 1;
            task_count_correct(k) = task_count_correct(k) + 1;
        else
            task_correct_array(i) = -1;
        end
        task_count(k) = task_count(k) + 1;
    else
        task_correct_array(i) = 0;
    end
    task_average_correct(k) = task_average_correct(k) + task_correct_array(i);
    % for i = 1:length(correct)
    %     try
    %         if(switch_point(i) == 0)
    %             k = k+1;
    %         else
    %             k = 1;
    %         end
    %     catch
    %         k = k+1;
    %     end
    %
    %
    %     if(task_code(i) == SaccadeCode)
    %        plot(i, correct(i), 'ro')
    %        if(correct(i) == 1)
    %         saccade_correct(i) = 1;
    %        else
    %         saccade_correct(i) = -1;
    %        end
    %        reach_correct(i) = 0;
    %        saccade_count(k) = saccade_count(k) + 1;
    %     else
    %        plot(i, correct(i), 'go')
    %        if(correct(i) == 1)
    %         reach_correct(i) = 1;
    %        else
    %         reach_correct(i) = -1;
    %        end
    %        saccade_correct(i) = 0;
    %        reach_count(k) = reach_count(k) + 1;
    %     end
    %
    %     average_reach_correct(k) = average_reach_correct(k) + reach_correct(i);
    %     average_saccade_correct(k) = average_saccade_correct(k) + saccade_correct(i);
    % end

end
return