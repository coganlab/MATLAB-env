function sortSpikesForAllRecs(day,sys,refRec,startRec);
%
%
%
day
recs = dayrecs(day);

diffRecs = setdiff(recs,refRec);
[tf,loc]=ismember(startRec,diffRecs);

for irec=loc:length(diffRecs)
 % irec
  for chan=1:32
    try
      procExtendSpikeSort(day,diffRecs{irec},sys,chan,refRec);          
    end
  end
end