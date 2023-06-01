function PSTH = sessPSTHTuning(Sess,Task,Field,bn,sm)
%
%   PSTH = sessPSTHTuning(Sess,Task,Field,bn)
%
%   SESS    =   Cell array.  Session information
%   TASK    =   String.  Task to average over.
%               'Free3T'
%               'Free1T'
%               'Fix1T'
%               'Sacc'
%               'IntSacc'
%   FIELD   =   String.  Alignment field
%                   Defaults to 'TargsOn'
%   BN      =   Vector.  Analysis interval in ms 
%                   Defaults to [-1e3,1e3]
%   SM      =   Scalar.  Smoothing parameter in ms
%                   Defaults to 40
%

global MONKEYDIR MONKEYNAME

if nargin < 3 Field = 'TargsOn'; end
if nargin < 4 bn = [-1e3,1e3]; end
if nargin < 5 sm =  40; end

Sys = Sess{3}; 
Ch = Sess{4}(1); 
Cl = Sess{5}(1);

if isstruct(Sess{1}
  Trials = TaskTrials(Sess{1},Task);
else
  Trials = sessTrials(Sess,Task);
end

if length(Trials) == 0
    disp('No Trials');
    return
end

%if strcmp(Field(1:2),'LR')
%    NumLRSacc = getNumLRSacc(Trials);
%    Trials = Trials(find(NumLRSacc));
%end
   
disp([num2str(length(Trials)) ' Trials'])
Target = [Trials.Target];

Spike = trialSpike(Trials, Sys, Ch, Cl, Field, bn);

for iDr = 1:8
  ind = find(Target==iDr);
  if length(ind)
    PSTH(iDr,:) = psth(Spike(ind),bn,sm);
  end
end
