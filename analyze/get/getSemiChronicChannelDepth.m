function [depth,days,recs] = getSemiChronicChannelDepth(Session,refName)
%
%  [depth,days,recs] = getSemiChronicChannelDepth(SESSION,REFNAME)
%
%  Calculate the absolute depth of all electrodes during the days/recs specified by Session.
%  If REFNAME is specified, the depth is calculated using a reference registration map.

% Usage:   [ depth,days,recs] = getSemiChronicChannelDepth(Session,'PFC');


global MONKEYDIR MONKEYNAME

dirPath = [ MONKEYDIR '/mat/Alignment/'];
if exist('refName','var') & ~isempty(refName)
  if isequal(refName,'TOP') | isequal(refName,'BOTTOM')
    % for backward compatibility with decoding scripts used by (Markowitz, Wong, Gray and Pesaran, J Neurosci 2011)
    load([dirPath 'ChannelAlignment.mat']); 
  else
     load([dirPath refName '_RegistrationMap.mat']); 
  end
end

depth = [];
days = [];
recs = [];
dIndex = 1;
for s=1:length(Session)
  curDay = sessDay(Session{s});
  allRecs = sessRec(Session{s});
  if isempty(allRecs)
    allRecs = dayrecs(curDay);
    allRecs = allRecs{end};
  end
  for r=1:length(allRecs)
    curRec = allRecs{r};
    elogFName = [ MONKEYDIR '/' curDay '/' curRec '/rec' curRec '.electrodelog.txt' ];
    if exist(elogFName,'file')
      curDepth = load(elogFName); 
      ch = sessElectrode(Session{s});
      curDepth = curDepth(2:end);
      curDepth = curDepth(ch);
      
        if exist('refName','var')
            if isequal(refName,'TOP');
                curDepth = curDepth + topOffset(ch);
            elseif isequal(refName,'BOTTOM')
                curDepth = curDepth + botOffset(ch);
            else
                curDepth = regDepthMap(round(curDepth),ch); 
            end
        end
  
      depth = [ depth; curDepth ];
      days{dIndex} = curDay;
      recs{dIndex} = allRecs{r};
      dIndex = dIndex + 1;
    else
        error([elogFName ' not found.']);
    end
  end
end


