function average_correct = choiceCalculateAverageCorrect(correct, switch_index, average_window)
%
% AVERAGE_CORRECT = CHOICECALCULATEAVERAGECORRECT(CORRECT, SWITCH_INDEX,
%AVERAGE_WINDOW)
% CORRECT = numerical array with 1 indicating correct choice and 0
% indicating incorrect choice
% Switch index = numerical array of reward value switch points
% AVERAGE_WINDOW


j = 1;
for i = 1:length(switch_index)
    try
        if(switch_index(i)+average_window < length(correct))
            average_correct = average_correct(:) + correct(switch_index(i):switch_index(i)+average_window);
            j = j+1;
        end
    catch
        average_correct = correct(1:average_window+1);
    end
end
average_correct = average_correct/j;

return