
field = Field_Database;

condParams.HighPassFlag = 1;
condParams.Field = 'TargsOn';
condParams.FilterLength = 200;
condParams.bn = [-1e3,2e3];
figure

for j = 1:3

    if(j == 1)
        condParams.Task = 'DelReachFix';
    elseif(j ==2)
        condParams.Task = 'DelSaccadeTouch';
    else
        condParams.Task = 'DelReachSaccade';
    end

    for i = 1:length(field)
        try
            file_name = [MONKEYDIR '/fig/Evoked/High_Pass_Evoked_Response_' condParams.Task '_' num2str(field{i}{6})]

            if(~isfile([file_name '.jpg']))
                [mlfp, num_trials] = sessEvokedLFP(field{i},condParams);
                plot(mlfp)
                whos mlfp
                box off;
                axis([0 3000 -400 400])
                title(['Day: ' char(field{i}{1}) ' field: ' num2str(field{i}{6}) ' Task: ' condParams.Task ' Align: ' condParams.Field ' Interval: ' num2str(condParams.bn) ' ' num2str(num_trials) ' trials']);
                disp(['Saving ' file_name]);
                saveas(gcf,file_name,'jpg')
            else
                disp([file_name ' already exists']);
            end
        end
    end

end
