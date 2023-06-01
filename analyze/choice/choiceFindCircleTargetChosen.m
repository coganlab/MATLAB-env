function target_chosen = choiceFindCircleTargetChosen(task_code, circle_target_location, eyechoice, handchoice)

% TARGET_CHOSEN = CHOICEFINDCIRCLETARGETCHOSEN(TASK_CODE, TARGET_LOCATION,
% EYECHOICE, HANDCHOICE)
% Use the circle target placement and end hand or location to decide which target was
% chosen. 1 denotes that the circle was chosen, 0 denotes that the triangle
% was chosen.
%
% TASKCODE =
% CIRCLE_TARGET_LOCATION = Location of the circle target
% EYECHOICE =
% HANDCHOICE = 

global ReachCode
global SaccadeCode
global ReachSaccadeCode

handchoice(intersect(find(task_code ~= ReachCode), find(task_code ~= ReachSaccadeCode))) = 0;
eyechoice(find(task_code ~= SaccadeCode)) = 0;
choice = handchoice + eyechoice;
%%%% No error checking should go through zero trials and check correct
%%%% target being sleected
target_chosen = (choice == circle_target_location); 
target_chosen = target_chosen;
% 
% 
% target_chosen = zeros(length(task_code),1);
% 
% for i = 1:length(task_code)
%     if(task_code(i) == ReachCode)
%         if(target_location(i) == 0)
%             if(handchoice(i) == 1)
%                 target_chosen(i) = 0;
%             elseif(handchoice(i) == 5)
%                 target_chosen(i) = 1;
%             else
%                 disp('where did he go')
%                 pause
%             end
%         else
%             if(handchoice(i) == 1)
%                 target_chosen(i) = 1;
%             elseif(handchoice(i) == 5)
%                 target_chosen(i) = 0;
%             else
%                 disp('where did he go')
%                 pause
%             end
%         end
%     else
%         if(target_location(i) == 0)
%             if(eyechoice(i) == 1)
%                 target_chosen(i) = 0;
%             elseif(eyechoice(i) == 5)
%                 target_chosen(i) = 1;
%             else
%                 disp('where did he go')
%                 pause
%             end
%         else
%             if(eyechoice(i) == 1)
%                 target_chosen(i) = 1;
%             elseif(eyechoice(i) == 5)
%                 target_chosen(i) = 0;
%             else
%                 disp('where did he go')
%                 pause
%             end
%         end
%     end
% end

return