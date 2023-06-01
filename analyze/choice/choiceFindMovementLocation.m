% Use the threshold values to decide which target was chosen 
% location input code: 3 no movement, 1 right or up movement, 2 left or down movement

function choice = choiceFindMovementLocation(locationsx,locationsy)

for i = 1:length(locationsx)
    if(locationsx(i) == 3)
        if(locationsy(i) == 3)
            choice(i) = 0;
        elseif(locationsy(i) == 1)
            choice(i) = 3;
        else
            choice(i) = 7;
        end
    elseif(locationsx(i) == 1);
        if(locationsy(i) == 3)
            choice(i) = 1;
        elseif(locationsy(i) == 1)
            choice(i) = 2;
        else
            choice(i) = 8;
        end
    else
        if(locationsy(i) == 3)
            choice(i) = 5;
        elseif(locationsy(i) == 1)
            choice(i) = 4;
        else
            choice(i) = 6;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % simplified version just looking either left or right
% % for i = 1:length(locationsx)
% %     if(locationsx(i) == 3)
% %         choice = 0;
% %     elseif(locationsx(i) == 2)
% %         choice(i) = 5;
% %     else
% %         choice(i) = 1;
% %     end
% % end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

return