% For a sequence of trials, creates an array for a specific task
% type with a 1 for a correct trial a -1 for an incorrect trial and
% a 0 if the trial does not match the task type centered around the switch
% point

function [task_count,task_count_correct] = choiceCreateCorrectArraySwitch(task_code_array, task_code, correct_array, switch_point,points_to_analyze)


task_count = zeros(1,points_to_analyze*2);
task_count_correct = zeros(1,points_to_analyze*2);
max_points = length(correct_array);
length(switch_point)
for i = 1:length(switch_point)
    for j = -points_to_analyze+1:points_to_analyze
       global_index = switch_point(i) + j;
       local_index = j+points_to_analyze;
       if(global_index > 0 && global_index < max_points+1)
           % Flip the shape of the curve before the switch point
           if(j < 1)
               correct_value = -1;
           else
               correct_value = 1;
           end
           if(task_code_array(global_index) == task_code)
               if(correct_array(global_index) == 1)
                   task_count_correct(local_index) = task_count_correct(local_index) + correct_value;
               end
               task_count(local_index) = task_count(local_index) + 1;
           end
       end
    end
end



return