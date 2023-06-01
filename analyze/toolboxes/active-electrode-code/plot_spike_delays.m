


% plot examples from each cluster
numSubplot = 36;


count = 0;
for i=1:size(spikeDelays,1)
    
    metric(i) = median(rmsVals(i,:)) / max(rmsVals(i,:));
    
    if metric(i) > 0.4
        count = count + 1;
        if (count > numSubplot)
            count = 1;
            pause
        end
        
        
        %%% Data hack
        iso = spikeDelays(i,:);
        sorted = sort(iso(:));
        
        % saturate min
        minVal = sorted(round(size(sorted,1) * 0.05));
        iso(iso < minVal) = minVal;
        
        maxVal = sorted(round(size(sorted,1) * 0.95));
        iso(iso > maxVal) = maxVal;
        
        % remove min
        %corr_val = iso - min(corr_val(:));
        
        
        figure(1)
        subplot(sqrt(numSubplot),sqrt(numSubplot),count)
        % plot the source data
        %imagesc(reshape(spikeDelays(i,:),numRow,numCol))
        imagesc(reshape(iso,numRow,numCol))
         title([num2str(spikeTimes(i)) ' s']);
         
        
%         count = count + 1;
%         if (count > numSubplot)
%             count = 1;
%             pause
%         end
%         
%         subplot(sqrt(numSubplot),sqrt(numSubplot),count)
%         % plot the source data
%         imagesc(reshape(rmsVals(i,:),numRow,numCol))
%         title([num2str(spikeTimes(i)) ' s']);
%         
%         count = count + 1;
%         if (count > numSubplot)
%             count = 1;
%             pause
%         end
%         
%         subplot(sqrt(numSubplot),sqrt(numSubplot),count)
%         % plot the source data
%         hist(rmsVals(i,:), 50)
        
        
        
        %hist(spikeDelays(i,:), 50)
        %hist(iso,50)
        
        
        %title(num2str(metric(i)));
        
    end
    
    
    
end

