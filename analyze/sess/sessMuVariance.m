function [muVar] = sessMVariance(Sess, CondParams, AnalParams)
%
%   [muVar] = sessMuVariance(Sess, CondParams, AnalParams)
%
%   Returns the variance of MUA in recordings specified by CondParams.Rec
%   If no recs are specified, the variance is estimated for every rec.
%   
%   SESS    =   Cell array.  Field Session information for a single day.
%   CONDPARAMS =   Data structure.  Parameter information for
%   condition information
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   CondParams.Rec    =   String/Cell.  Recs to analyze.

global MONKEYDIR

% Ignore rec data in Sess, which deals with post-movement recs only.
% We're interested in all recs, before, during and after movement.
% recs = dayrecs(Sess{1});
recs = Sess{2};

iRec = 1;
if nargin >= 2 & isfield(CondParams,'Rec');
  [yn,iRec] = ismember(recs,CondParams.Rec);
  iRec = find(iRec);
end

Day = Sess{1};
Sys = sessTower(Sess);
Ch = Sess{4};

aWin = 600; % (sec)
muSamplingRate = 3e4;

% downSamplingRate = 1e3;
% dt = 1000/muSamplingRate;
% dsDt = 1000/downSamplingRate;

% N = 1;
% W = 4;
% dn = 1;
% fk = 200;
% pad = 2;

% Placeholder for AnalParams code.
% User may want to specify duration of MUA to analyze, how to filter out
% noise artifacts, which frequency bands to study, etc.
% ? = 0;
% if nargin >= 3 & isfield(AnalParams,'?');
%   ? = AnalParams.?;
% end

muVar = [];
for k = 1:length(iRec)
    rec = recs{k};
    fName = [MONKEYDIR '/' Day '/' rec '/rec' rec '.' Sys '.mu.dat'];
    f = -1;
    if exist(fName,'file')
      f = fopen(fName);
    else
        disp(['Couldn''''t load: ' fName]);
        disp('Running procMu...');
        try
          procMu(Day,rec);
          f = fopen(fName);
        catch end
    end
    if f>-1
      mu = fread(f,[32,aWin*muSamplingRate],'short=>single');
      fclose(f);
      if size(mu,1)>=max(Ch)
        mu = mu(Ch,:);
        recVar = var(mu,0,2)';
        muVar(k).recVar = recVar;
        muVar(k).rec = rec;
      else
         procMu(Day,rec);
         f = fopen(fName);
         if f>-1
           mu = fread(f,[32,aWin*muSamplingRate],'short=>single');
           fclose(f);
           if size(mu,1)>=max(Ch)
             mu = mu(Ch,:);
             recVar = var(mu,0,2)';
             muVar(k).recVar = recVar;
             muVar(k).rec = rec;
           end
         end
      end
    end
    
%       padLen = muSamplingRate-mod(size(mu,2),N*muSamplingRate);
%       mu = [ mu zeros(length(ch),padLen) ];
%       mu = reshape(mu',N*muSamplingRate,length(mu)/(N*muSamplingRate));
%       absLfp = abs(mu);
%       absMaxLfp = max(absLfp,[],1);
% 
%       vThresh = 2*mean(absMaxLfp);
%       artifactLocs = find(absMaxLfp>vThresh);
%       mu(:,artifactLocs) = [];
%       mu = reshape(mu,size(mu,1)*size(mu,2),1)';
    
%     chData(ch).depth = [ chData(ch).depth depthVal ];
%     chData(ch).muVar = [ chData(ch).muVar var(mu) ];
    end
end
