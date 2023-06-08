function [peakloc,peakmag] = myfpeaks(input)
%
%  [peakloc,peakmag] = myfpeaks(input)
%  

dspec = diff(input);
ind = find(dspec(1:end-1) > 0 & dspec(2:end)< 0);

peakloc = ind;
peakmag = input(ind);

[speakmag,sind] = sort(peakmag,'descend');
sspeakmag = speakmag(1:min(4,end));
sspeakloc = peakloc(sind(1:min(4,end)));

[peakloc,lastind] = sort(sspeakloc,'ascend');
peakmag = sspeakmag(lastind);
