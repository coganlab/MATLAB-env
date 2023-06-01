
shuffvals=zeros(iC,nPerm);
nPerm=1000;
for iC=1:40 % number of points to shuffle
    tic
    for iPerm=1:nPerm
    testmatrix=zeros(20,50); % size of testmatrix to shuffle
    fill=shuffle(1:size(testmatrix,1)*size(testmatrix,2));
    fill=fill(1:iC);
    testmatrix(fill)=1;
    CC=bwconncomp(testmatrix);
    iM=zeros(1,length(CC.PixelIdxList));
    for ii=1:length(CC.PixelIdxList); % find size of all clusters)
        iM(ii)=length(CC.PixelIdxList{ii});
    end
    shuffvals(iC,iPerm)=max(iM); % record max of shuffled clusters for each iteration
    end
    toc
end
 



