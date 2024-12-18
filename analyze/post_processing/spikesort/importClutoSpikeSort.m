function importClutoSpikeSort(day,rec,tower,ch)
%
% importClutoSpikeSort(day,rec,tower,ch)
%

global MONKEYDIR
        load([MONKEYDIR '/' day '/' rec '/rec' rec '.Rec.mat']);
IsoWin = 100e3;
        if exist('experiment','var')
            if isfield(experiment,'hardware')
                if isfield(experiment.hardware,'microdrive')
                    mtch = expChannelIndex(experiment,mt,ch,contact);
                else
                    mtch = ch;
                end
            else
                mtch = ch;
            end
        else
            mtch = ch;
        end


load([MONKEYDIR '/' day '/' rec '/rec' rec '.' tower '.sp.mat']);
load([MONKEYDIR '/' day '/' rec '/rec' rec '.' tower '.clu.mat']);
nCh=length(sp);
sp = sp{mtch};
clu = clu{mtch};
sptimes = sp(:,1);
if isfile([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat'])
    load([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat'])
    RecDuration  = expRecDuration(experiment,day,rec);
else
    RecDuration = max(sptimes);
end
T = [0:IsoWin:RecDuration RecDuration];
nFrames = length(T)-1;
disp([num2str(nFrames) ' frames']);
MAXFRAME = nFrames;

filename = [MONKEYDIR '/' day '/' rec '/rec' rec '.' tower '.iso.mat'];
if isfile(filename)
  load(filename);
else
  iso = cell(1,length(nCh));
  isoch = zeros(nFrames,14);
  isoch(:,1)=1;
  for iCh = 1:nCh
    iso{iCh}=isoch;
  end
end

N = zeros(1,nFrames+1);
for i = 2:nFrames+1
    N(i) = find(sptimes<T(i), 1, 'last' );
end
if length(sptimes) ~= N(2) %added by RAS on 12/12/12 to be able to sort 1 frame recordings
    N(end) = N(end)+1; %was originally there without if-end
end
 sp_seg = sp(N(1)+1:N(1+1),2:end);
    [U_seg,pcold,eigvalues] = spikepcs(sp(N(1)+1:N(2),:));
    MovieData(1).Sp = sp(N(1)+1:N(2),2:end);
    MovieData(1).U = U_seg;
    MovieData(1).SpTimes = sp(N(1)+1:N(2),1);
    SortData(1).Clu(:,1) = clu(N(1)+1:N(2),1);;
    SortData(1).Clu(:,2) = clu(N(1)+1:N(2),2);
    MovieData(1).PC=pcold;
    MovieData(1).EigFrac=(eigvalues.^2)/sum(eigvalues.^2); %fractional sum of squares
    MovieData(1).TempInclude = ones(size(U_seg,1),1);

for iFrame = 2:nFrames
    disp(['Frame ' num2str(iFrame) ' has ' num2str(N(iFrame+1)-N(iFrame)-1) ' spikes'] )
    if N(iFrame+1)-(N(iFrame)+1);
        [U_seg,pc,eigvalues] = spikepcs(sp(N(iFrame)+1:min(N(iFrame+1),end),:),pcold);
        U_old=sp(N(iFrame-1)+1:N(iFrame),2:end)*pcold;
        U_new=sp(N(iFrame-1)+1:N(iFrame),2:end)*pc;
        MovieData(iFrame).U = U_seg;
        MovieData(iFrame).PC=pc;
        MovieData(iFrame).EigFrac=(eigvalues.^2)/sum(eigvalues.^2); %fractional sum of squares
        MovieData(iFrame).Sp = sp(N(iFrame)+1:min(N(iFrame+1),end),2:end);
        MovieData(iFrame).SpTimes = sp(N(iFrame)+1:min(N(iFrame+1),end),1);
        SortData(iFrame).Clu(:,1) = clu(N(iFrame)+1:min(N(iFrame+1),end),1);
        SortData(iFrame).Clu(:,2) = clu(N(iFrame)+1:min(N(iFrame+1),end),2);

        MovieData(iFrame).TempInclude = ones(size(U_seg,1),1);

        pcold = pc;
    else
        MovieData(iFrame).Sp = [];
        MovieData(iFrame).SpTimes = [];
    end
end

filename=[MONKEYDIR '/' day '/' rec '/rec' rec '.' tower '.' num2str(mtch) '.MovieData.mat'];
save(filename,'MovieData');

MAXFRAME=length(MovieData);

for iFrame = 1:MAXFRAME
    sptimes = MovieData(iFrame).SpTimes;
    sp_seg = MovieData(iFrame).Sp;
    SortData(iFrame).Iso = zeros(1,14);
    SortData(iFrame).TempInclude = ones(size(sptimes,1),1);
    SortData(iFrame).RemCell=zeros(1,14);
    SortData(iFrame).RemIso=SortData(1).RemCell;
    [U_seg,pc] = spikepcs([sptimes sp_seg],pcold);
    pcold = pc;
    U_seg = U_seg(:,1:3);
    SortData(iFrame).U = U_seg;
    for c = 1:14
      ind = find(SortData(iFrame).Clu(:,2)==c);
      if ~isempty(ind)
         SortData(iFrame).Waveform(c,:) = ...
                mean(MovieData(iFrame).Sp(ind,:));
         SortData(iFrame).Iso(c) = 1;
         iso{mtch}(iFrame,c) = 1;
      end
    end
end
filename=[MONKEYDIR '/' day '/' rec '/rec' rec '.' tower '.' num2str(mtch) '.SortData.mat'];
save(filename,'SortData');
filename=[MONKEYDIR '/' day '/' rec '/rec' rec '.' tower '.iso.mat'];
save(filename,'iso');
