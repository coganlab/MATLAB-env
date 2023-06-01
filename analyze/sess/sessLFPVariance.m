function [lfpVar] = sessLFPVariance(Sess, CondParams, AnalParams)
%
%   [lfpVar] = sessLFPVariance(Sess, CondParams, AnalParams)
%
%   Returns the variance of LFPs in recordings specified by CondParams.Rec
%   If no recs are specified, the variance is estimated for every rec.
%   
%   SESS    =   Cell array. Session information for a single day.
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

Fk = [ 1 300 ];
if nargin >= 3 & isfield(AnalParams,'Fk');
  Fk = AnalParams.Fk;
end

Day = Sess{1};
Sys = sessTower(Sess);
Ch = Sess{4};

aWin = 600; % (sec)

winLen = 10; % (sec)
shiftInc = 1; % (sec)

lfpSamplingRate = 1e3;

% N = 1;
% W = 4;
% dn = 1;
% fk = 200;
% pad = 2;

% Placeholder for AnalParams code.
% User may want to specify duration of LFP to analyze, how to filter out
% noise artifacts, which frequency bands to study, etc.
% ? = 0;
% if nargin >= 3 & isfield(AnalParams,'?');
%   ? = AnalParams.?;
% end

lfpVar = [];
for k = 1:length(iRec)
    rec = recs{iRec(k)};
    fName = [MONKEYDIR '/' Day '/' rec '/rec' rec '.' Sys '.clfp.dat'];
    fNameAlt = [MONKEYDIR '/' Day '/' rec '/rec' rec '.' Sys '.mlfp.dat'];
    f = -1;
    if exist(fName,'file')
      f = fopen(fName);
    elseif exist(fNameAlt,'file')
%       disp(['Couldn''''t load: ' fName]);
%       disp('Running procClfp...');        
%       procClfp(Day,rec);
%       if exist(fName,'file')
%         f = fopen(fName);
%       else
        f = fopen(fNameAlt); 
%       end    
    end
    if f>-1
      lfp = fread(f,[32,aWin*lfpSamplingRate],'float=>single');
      fclose(f);
      if size(lfp,1)>=max(Ch)
        lfp = double(lfp(Ch,:));
        
        [c,d] = butter(2, Fk/(lfpSamplingRate/2));
        for j=1:numel(Ch)
          filtlfp  =  filtfilt(c,d,lfp(j,:));
%           [val,ind] = sort(abs(filtlfp));
%           thresh95 = val(round(0.95*numel(val)));
%           filtlfp = max(-thresh95,min(thresh95,filtlfp));
          lfp(j,:) = filtlfp;
        end
        
        winVar = [];
        for g=1:max(1,round((size(lfp,2)-winLen*lfpSamplingRate)/(shiftInc*lfpSamplingRate)))
          temp = lfp(:,(g-1)*(shiftInc*lfpSamplingRate)+1:min(size(lfp,2),g*(shiftInc*lfpSamplingRate)));
          winVar = [ winVar var(temp,0,2) ];
        end
        recVar = [ median(winVar,2) ]';
        
%         recVar = var(lfp,0,2)';
        lfpVar(k).recVar = recVar;
        lfpVar(k).rec = rec;
      else
%          procClfp(Day,rec);
%          f = fopen(fName);
%          if f>-1
%            lfp = fread(f,[32,aWin*lfpSamplingRate],'float=>single');
%            fclose(f);
%            if size(lfp,1)>=max(Ch)
%              lfp = lfp(Ch,:);
%              recVar = var(lfp,0,2)';
%              lfpVar(k).recVar = recVar;
%              lfpVar(k).rec = rec;
%            end
%          end
      end      
      
%       padLen = lfpSamplingRate-mod(size(lfp,2),N*lfpSamplingRate);
%       lfp = [ lfp zeros(length(ch),padLen) ];
%       lfp = reshape(lfp',N*lfpSamplingRate,length(lfp)/(N*lfpSamplingRate));
%       absLfp = abs(lfp);
%       absMaxLfp = max(absLfp,[],1);
% 
%       vThresh = 2*mean(absMaxLfp);
%       artifactLocs = find(absMaxLfp>vThresh);
%       lfp(:,artifactLocs) = [];
%       lfp = reshape(lfp,size(lfp,1)*size(lfp,2),1)';
    
%     chData(ch).depth = [ chData(ch).depth depthVal ];
%     chData(ch).lfpVar = [ chData(ch).lfpVar var(lfp) ];
    end
    
end
