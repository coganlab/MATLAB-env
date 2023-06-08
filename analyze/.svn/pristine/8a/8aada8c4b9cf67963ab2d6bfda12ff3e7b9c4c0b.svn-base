function [EventTrials, NullTrials] = calcSimpleOnsetTrials(Session, InputParams)
%
%  [EventTrials, NullTrials] = calcSimpleOnsetTrials(Session, InputParams)
%

InputParams1 = InputParams.Event;
InputParams2 = InputParams.Null;

InputParams1.conds = {InputParams1.Target};
InputParams2.conds = {InputParams2.Target};

EventTrials = Params2Trials(Session, InputParams1);
NullTrials = Params2Trials(Session, InputParams2);
