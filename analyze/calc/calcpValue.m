function [p,D,PD] = calcpValue(Set1,Set2)


NPERM = 1e4;

ntr1 = length(Set1);
ntr2 = length(Set2);

D = sum(Set1)./ntr1 - sum(Set2)./ntr2;
GX = [Set1; Set2]; nGX = size(GX,1);
disp('Permutation calculation');
if matlabpool('size')
    parfor iPerm = 1:NPERM
        NP = randperm(nGX);
        N1 = NP(1:ntr1);
        N2 = NP(ntr1+1:end);
        PSet1 = sum(GX(N1))./ntr1;
        PSet2 = sum(GX(N2))./ntr2;
        PD(iPerm) = PSet1-PSet2;
    end
else
    for iPerm = 1:NPERM
        NP = randperm(nGX);
        N1 = NP(1:ntr1);
        N2 = NP(ntr1+1:end);
        PSet1 = sum(GX(N1))./ntr1;
        PSet2 = sum(GX(N2))./ntr2;
        PD(iPerm) = PSet1-PSet2;
    end
end
p = length(find(abs(PD)>abs(D)))./NPERM;


