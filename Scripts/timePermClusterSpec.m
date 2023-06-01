function [zValsRawAct pValsRaw actClust]=timePermClusterSpec(aSig,bSig,nPerm,numTails,zThresh)

%function [zValsRaw pValsRaw permval2]=timePermCluster(aSig,bSig,nPerm,numTails)

% Inputs:
% aSig = Active signal: trials x time
% bSig = Passive signal: trials x time
% nperm = Number of permutations: integer, default = 1000
% cTime = number of consecutive signals for significance: integer, default = 3
% sAlpha = alpha for significance: integer, default = 0.05
% cFdr = perform fdr?, 1= Yes, 0 = No, default = 1
% numTails = number of tails for test (1 or 2), defaults to 2
% cThresh=clusterThreshold (Z score)
%
% Outputs:
% sigVals = Time series vector of 1s and 0s for significant time points
% sigIdx = Index of significant values from sigVals
% sigMax = Maximum size of cluster
% pValsRaw = Raw P values from shuffle

if nargin < 2
    display('Not enough inputs')
end

if nargin < 3 || isempty(nPerm)
    nPerm = 1000;
end
if nargin < 4 || isempty(numTails)
    numTails = 1;
end


if size(aSig,2) ~= size(bSig,2)
    display('Signals have different time lengths')
end

% % compute actual difference, shuffle, and compute pvalues
%     actdiff=mean(aSig)-mean(bSig);
%     combval=cat(1,aSig,bSig);
% pValsRaw=zeros(size(aSig,2),1);
% for iTime=1:size(aSig,2)
%   %  actdiff=mean(aSig(:,iTime))-mean(bSig(:,iTime));
%   %  combval=cat(1,aSig(:,iTime),bSig(:,iTime));
%     permval=zeros(nPerm,1);
% 
%     for iPerm=1:nPerm
%     %    sIdx=shuffle(1:size(combval,1));
%         sIdx=randperm(size(combval,1));
%         permval(iPerm)=mean(combval(sIdx(1:size(aSig,1)),iTime))-mean(combval(sIdx(size(aSig,1)+1:length(sIdx)),iTime));
%     end
% 
% %    if numTails==1
%     pValsRaw(iTime)=length(find(permval>actdiff(iTime)))./nPerm;
% %    elseif numTails==2
%  %   pValsRaw(iTime)=length(find(abs(permval)>abs(actdiff(iTime))))./nPerm;
% %    end
% 
% end




% compute actual difference, shuffle, and compute pvalues
actdiff=sq(mean(aSig)-mean(bSig));
combval=cat(1,aSig,bSig);
%permval2=zeros(nPerm,size(combval,1),size(combval,2),size(aSig,3));
pValsRawOne=zeros(size(aSig,2),size(aSig,3));
pValsRawTwo=zeros(size(aSig,2),size(aSig,3));
idx1=1:size(aSig,1);
idx2=size(aSig,1)+1:size(combval,1);

%tic
%  actdiff=mean(aSig(:,iTime))-mean(bSig(:,iTime));
%  combval=cat(1,aSig(:,iTime),bSig(:,iTime));

permval=zeros(nPerm,size(aSig,2),size(aSig,3));
tic
for iPerm=1:nPerm
    sIdx=randperm(size(combval,1));
%     for iF=1:size(aSig,3)
%         for iTime=1:size(aSig,2)
%             permval(iPerm,iTime,iF)=mean(combval(sIdx(idx1),iTime,iF))-mean(combval(sIdx(idx2),iTime,iF));
%         end
%     end
%     
    permval(iPerm,:,:)=mean(combval(sIdx(idx1),:,:))-mean(combval(sIdx(idx2),:,:)); 
   % permval2(iPerm,:,:,:)=combval(sIdx,:,:);   
end
 for iF=1:size(aSig,3)
        for iTime=1:size(aSig,2)
                pValsRawOne(iTime,iF)=length(find(permval(:,iTime,iF)>actdiff(iTime,iF)))./nPerm;
                pValsRawTwo(iTime,iF)=length(find(abs(permval(:,iTime,iF))>abs(actdiff(iTime,iF))))./nPerm;
        end
 end
toc
ii=find(pValsRawOne==1);
pValsRawOne(ii)=1-1/nPerm;%.9999;
ii=find(pValsRawOne==0);
pValsRawOne(ii)=1/nPerm;
zValsRawActOne=norminv(1-pValsRawOne);
ii=find(pValsRawTwo==1);
pValsRawTwo(ii)=1-1/nPerm;%.9999;
ii=find(pValsRawTwo==0);
pValsRawTwo(ii)=1/nPerm;
zValsRawActTwo=norminv(1-pValsRawTwo);

tic
% idxA=1:size(aSig,1);
% idxB=size(aSig,1)+1:size(permval2,2);
% permval3=sq(mean(permval2(:,idxA,:,:),2)-mean(permval2(:,idxB,:,:),2));
pValsRawPermTOne=zeros(nPerm,size(permval,2),size(permval,3));
pValsRawPermTTwo=zeros(nPerm,size(permval,2),size(permval,3));

%actDiffT=zeros(nPerm,size(permval,2),size(permval,3));

for iPerm=1:size(permval,1)
 % tic
  %  idx1=setdiff(1:size(permval,1),iPerm);

    actDiffT=sq(permval(iPerm,:,:));

  %  permvalsT=permval(idx1,:,:);
    permvalsT=permval(setdiff(1:size(permval,1),iPerm),:,:);

    for iF=1:size(permval,3)
        for iTime=1:size(aSig,2)
          %  pValsRawPermTOne(iPerm,iTime,iF)=length(find(permvalsT(:,iTime,iF)>actDiffT(iTime,iF)))./(nPerm-1);
            pValsRawPermTOne(iPerm,iTime,iF)=sum(permvalsT(:,iTime,iF)>actDiffT(iTime,iF))./(nPerm-1);
            
        %    pValsRawPermTTwo(iPerm,iTime,iF)=length(find(abs(permvalsT(:,iTime,iF))>abs(actDiffT(iTime,iF))))./(nPerm-1);            
            pValsRawPermTTwo(iPerm,iTime,iF)=sum(abs(permvalsT(:,iTime,iF))>abs(actDiffT(iTime,iF)))./(nPerm-1);            

        end
    end
%toc
end

toc

ii=find(pValsRawPermTOne==1);
pValsRawPermTOne(ii)=1-1/nPerm;%.9999;
ii=find(pValsRawPermTOne==0);
pValsRawPermTOne(ii)=1/nPerm;
zValsRawPermOne=norminv(1-pValsRawPermTOne);

ii=find(pValsRawPermTTwo==1);
pValsRawPermTTwo(ii)=1-1/nPerm;%.9999;
ii=find(pValsRawPermTTwo==0);
pValsRawPermTTwo(ii)=1/nPerm;
zValsRawPermTwo=norminv(1-pValsRawPermTTwo);

actClust=[];
clear ii2
tmpA=zeros(size(zValsRawPermOne,2),size(zValsRawPermOne,3));
if numTails==1
ii=find(zValsRawActOne>zThresh);
elseif numTails==2
ii=find(zValsRawActTwo>zThresh);
end    
tmpA(ii)=1;
tmp=bwconncomp(tmpA);

if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);      
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
        actClust.Start{ii}=tmp.PixelIdxList{ii}(1);
        actClust.Size{ii}=length(tmp.PixelIdxList{ii});
        actClust.Location{ii}=tmp.PixelIdxList{ii};
        if numTails==1
        actClust.Z{ii}=sum(zValsRawActOne(tmp.PixelIdxList{ii})); % TWO OR ONE?
        elseif numTails==2
        actClust.Z{ii}=sum(zValsRawActTwo(tmp.PixelIdxList{ii})); % TWO OR ONE?  
        end
    end
else
    actClust.Start={NaN};
    actClust.Size={NaN};
    actClust.Z={NaN};    
end

tic
actClust.maxPermClust=zeros(nPerm,1);
for iPerm=1:nPerm;
    clear ii2
    clear ii3
    %tmpA=zeros(1,length(zValsRawP));
    tmpA=zeros(size(zValsRawPermOne,1),size(zValsRawPermOne,2));
    if numTails==1
        tmpB=sq(zValsRawPermOne(iPerm,:,:));
        ii=find(sq(zValsRawPermOne(iPerm,:,:))>zThresh);
    elseif numTails==2
        tmpB=sq(zValsRawPermTwo(iPerm,:,:));
        ii=find(sq(zValsRawPermTwo(iPerm,:,:))>zThresh);
    end
    tmpA(ii)=1;
    tmp=bwconncomp(tmpA);
    if size(tmp.PixelIdxList,2)>0
        for ii=1:size(tmp.PixelIdxList,2);          
                ii2(ii)=size(tmp.PixelIdxList{ii},1);
                ii3(ii)=sum(tmpB(tmp.PixelIdxList{ii}));
        end
    else
        ii2=0;
        ii3=0;
    end
    actClust.maxPermClust(iPerm)=max(ii2);
    actClust.maxPermZ(iPerm)=max(ii3);
    
end

actClust.maxPermClust=sort(actClust.maxPermClust);
actClust.perm95=actClust.maxPermClust(round(0.95*nPerm));
actClust.maxPermZ=sort(actClust.maxPermZ);
actClust.permZ95=actClust.maxPermZ(round(0.95*nPerm));
toc

%if numTails==1
    zValsRawAct=zValsRawActOne;
    pValsRaw=pValsRawOne;
%elseif numTails==2
%    zValsRawAct=zValsRawActTwo;
%    pValsRaw=pValsRawTwo;
%end