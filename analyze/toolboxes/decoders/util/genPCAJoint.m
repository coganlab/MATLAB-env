function GenJoint = genPCAJoint(PCAGen, PCAParams);
%
%   GenJoint = reconPCAJoint(PCAGen, PCAParams);
%
%   Returns angles in degrees in original basis


    nJoint = size(PCAGen,1);
    PCAGen_Sequence = PCAGen;

%reconJoint_Sequence = PCAParams.s(1:nJoint,1:nJoint)*PCAParams.U'*PCAJoint_Sequence;
    
genJoint_Sequence = PCAParams.U*PCAGen_Sequence;
nT = size(genJoint_Sequence,2);
base_Sequence = PCAParams.Base;
mJoint_Sequence = PCAParams.Mean;
genCenteredJoint_Sequence = genJoint_Sequence + base_Sequence(:,ones(1,nT));
genOnCircleJoint_Sequence = tanh(genCenteredJoint_Sequence)*pi + mJoint_Sequence(:,ones(1,nT));


GenJoint = 180./pi*genOnCircleJoint_Sequence;


