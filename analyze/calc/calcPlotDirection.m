function plot_direction = calcPlotDirection(trials,panelSort)
%
% plot_direction = calcPlotDirection(trials,CondParams)
%

plot_direction = zeros(1,length(trials));
matching_trials = zeros(1,length(trials));
for i = 1:length(panelSort.panel)
    criteria_match = ones(1,length(trials));
    if(length(panelSort.panel(i).sort))
        for j = 1:length(panelSort.panel(i).sort)
            if(isfield(trials,panelSort.panel(i).sort{j}{1}))
                matching_trials = ([trials.(panelSort.panel(i).sort{j}{1})] == panelSort.panel(i).sort{j}{2});
            else
                % Sort criteria is not in the Trials structure and needs to be
                % calculated
                if(strcmp(panelSort.panel(i).sort{j}{1},'Correct'))
                    matching_trials = calcCorrectChoice(trials, panelSort.panel(i).sort{j}{2});
                elseif(strcmp(panelSort.panel(i).sort{j}{1},'Movement'))
                    matching_trials = calcMovementDirection(trials, panelSort.panel(i).sort{j}{2});
                elseif(strcmp(panelSort.panel(i).sort{j}{1},'MaxReward'))
                    matching_trials = calcHighReward(trials, panelSort.panel(i).sort{j}{2});
                else
                    disp('No matching sort field');
                    matching_trials = ones(1,length(trials));
                end
            end
            criteria_match = criteria_match & matching_trials;
        end
    else
        disp('no sort defined for this panel')
        criteria_match = zeros(1,length(trials));
    end
    plot_direction = plot_direction + criteria_match*i;
end