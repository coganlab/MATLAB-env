
% create all possible subsamplings of 2/3 of the data
subN = nchoosek(1:size(eps,3),round(size(eps,3)* 0.66));


numX = size(eps,1);
numY = size(eps,2);
numRuns = 100;
numFeat = 2 * (numRow * numCol);        % delay and rms for each electrode 
training_data = zeros(numX, numY, numRuns, numFeat);

for i = 1:numRuns
which_subset = subN(randi(size(subN,1),1),:);
disp(['computing on trials' num2str(which_subset)])

[rmsVals, delay_map] = plot_sparse_noise_ep(eps(:,:,which_subset,:,:), filename, numRow, numCol, Fs, 0.04, 0.16, 'FALSE', 'FALSE');

featVec = cat(3,rmsVals, delay_map);
featVec = reshape(featVec, size(featVec,1),size(featVec,2), 1, size(featVec,3));

training_data(:,:,i,:) = featVec;

disp(['completed data point ' num2str(i) ' of ' num2str(numRuns)]);
end
