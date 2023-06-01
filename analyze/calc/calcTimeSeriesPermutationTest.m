function p = calcTimeSeriesPermutationTest(refSeries,testSeries,nPerm);

% The expected dimensionality of refSeries and testSeries is [ nTrials nTimePoints nFrequencies ]
% If the time series are not spectrograms, nFrequencies = 1

timeDim = size(refSeries,2);
freqDim = size(refSeries,3);

trueMeanSeriesDiff = mean(testSeries,1) - mean(refSeries,1);

pooledSeries1 = refSeries;
pooledSeries1(end+1:size(refSeries,1)+size(testSeries,1),:,:) = testSeries;
pooledSeries2 = pooledSeries1;

pooledSeries1 = pooledSeries1/size(refSeries,1);
pooledSeries2 = pooledSeries2/size(testSeries,1);

p = zeros(timeDim,freqDim);
parfor pInd=1:timeDim % for each time step
  rPerm1 = ceil(size(pooledSeries1,1)*rand(size(refSeries,1),nPerm)+eps);
  rPerm2 = ceil(size(pooledSeries2,1)*rand(size(testSeries,1),nPerm)+eps);
  pTotal = 0;
  for b=1:nPerm
    % Note: Summing over pre-normalized data here is significantly faster than calculating the mean.
    shufMeanSeriesDiff = sum(pooledSeries1(rPerm1(:,b),pInd,:),1) - ...
                         sum(pooledSeries2(rPerm2(:,b),pInd,:),1);
    pTotal = pTotal + single(shufMeanSeriesDiff>=trueMeanSeriesDiff(1,pInd,:));
  end
  p(pInd,:) = sq(pTotal);
end

p = p/nPerm;
