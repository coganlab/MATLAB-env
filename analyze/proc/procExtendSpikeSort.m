function procExtendSpikeSort(day, rec, sys, ch, targetrec, targetframe, NClus)
%  Apply sort from one recording to another
%
%  procExtendSpikeSort(day, rec, sys, ch, targetrec, targetframe, NClus)
%
%   DAY     = String.  Day you want to sort.
%   REC     = String.  Recording you want to sort.
%   SYS     = String.  System you want to sort.
%   CH      = Scalar. Channel you want to sort.
%   TARGETREC = String.  Recording you have already sorted
%   TARGETFRAME     = Scalar.  Frame number in original sort to start from.
%                       Defaults to 1.
%   NCLUS       = Scalar.  Number of clusters for initial sort
%                       Defaults to 6
%

global MONKEYDIR

%targetrec = '005';
%rec = '004';
%day = '100518';
%sys = 'FEF';
%ch = 6;
if nargin < 6 || isempty(targetframe); targetframe = 1; end
if nargin < 7; NClus = 6; end

OrigMovieData = load([MONKEYDIR '/' day '/' targetrec '/rec' targetrec '.' sys '.' num2str(ch) '.MovieData.mat']);
OrigSortData = load([MONKEYDIR '/' day '/' targetrec '/rec' targetrec '.' sys '.' num2str(ch) '.SortData.mat']);

if exist([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.' num2str(ch) '.sp.mat'],'file');
load([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.' num2str(ch) '.sp.mat']);
spch= sp;
else
load([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.sp.mat']);
spch = sp{ch};
end
load([MONKEYDIR '/' day '/' rec '/rec' rec '.Rec.mat']);

%  First create the new MovieData file
IsoWin = 100e3;
NumChannels = getSysNumChannels(day,sys,MONKEYDIR);
sptimes = spch(:,1);
% figure;
% plot(sp([1:500],[2:end])')
T = [0:IsoWin:max(sptimes) max(sptimes)];
nFrames = length(T)-1;
disp([num2str(nFrames) ' frames']);
MAXFRAME = nFrames;

N = zeros(1,nFrames+1);
for i = 2:nFrames+1
    N(i) = find(sptimes<T(i), 1, 'last' );
end
N(end) = N(end)+1;
sp_seg = spch(N(1)+1:N(1+1),2:end);
[U_seg,pcold,eigvalues] = spikepcs(spch(N(1)+1:N(2),:));
MovieData(1).Sp = spch(N(1)+1:N(2),2:end);
MovieData(1).U = U_seg;
MovieData(1).SpTimes = spch(N(1)+1:N(2),1);
MovieData(1).PC=pcold;
MovieData(1).EigFrac=(eigvalues.^2)/sum(eigvalues.^2); %fractional sum of squares
MovieData(1).TempInclude = ones(size(U_seg,1),1);

for iFrame = 2:nFrames
    disp(['Frame ' num2str(iFrame) ' has ' num2str(N(iFrame+1)-N(iFrame)-1) ' spikes'] )
    if N(iFrame+1)-(N(iFrame)+1);
        [U_seg,pc,eigvalues] = spikepcs(spch(N(iFrame)+1:N(iFrame+1),:),pcold);
        U_old = spch(N(iFrame-1)+1:N(iFrame),2:end)*pcold;
        U_new = spch(N(iFrame-1)+1:N(iFrame),2:end)*pc;
        MovieData(iFrame).U = U_seg;
        MovieData(iFrame).PC = pc;
        MovieData(iFrame).EigFrac = (eigvalues.^2)/sum(eigvalues.^2); %fractional sum of squares
        MovieData(iFrame).Sp = spch(N(iFrame)+1:N(iFrame+1),2:end);
        MovieData(iFrame).SpTimes = spch(N(iFrame)+1:N(iFrame+1),1);
        MovieData(iFrame).TempInclude = ones(size(U_seg,1),1);
        pcold = pc;
    end
end

%  Now create SortData
NDim = 3; nT = size(MovieData(1).Sp,2);
for iFrame = 1:MAXFRAME
    SortData(iFrame).Iso = zeros(1,14); SortData(iFrame).Iso(1:NClus) = 1;
    SortData(iFrame).Clu = ones(length(MovieData(iFrame).SpTimes),2);
    SortData(iFrame).Clu(:,1) = MovieData(iFrame).SpTimes;
    SortData(iFrame).TempInclude = ones(length(MovieData(iFrame).SpTimes),1);
    SortData(iFrame).RemCell = zeros(1,14);
    SortData(iFrame).RemIso = zeros(1,14);
end

pcold = OrigMovieData.MovieData(end).PC;
firstFrame = 1;
disp(['Frame ' num2str(firstFrame)]);
in = [MovieData(firstFrame).SpTimes MovieData(firstFrame).Sp];
[dum,pcold] = spikepcs(in,pcold);
U_seg = MovieData(firstFrame).U(:,1:NDim);
SortData(firstFrame).U = U_seg;
[centres,options,post] = kmeans(U_seg,NClus);
[dum,cind] = sort(sqrt(sum(centres'.^2)));
centres = centres(cind,:);
options(14) = 1;
[centres,options,post] = kmeans(U_seg,NClus,centres,options);

for c = 1:NClus
    ind = post(:,c)>0;
    if sum(ind)
        SortData(firstFrame).Clu(ind,2) = c;
        SortData(firstFrame).Waveform(c,:) = mean(MovieData(firstFrame).Sp(ind,:));
    end
end

%Merge
OrigCenter = OrigSortData.SortData(targetframe).Waveform;
OrigIso = OrigSortData.SortData(targetframe).Iso;
for iC = 1:size(OrigCenter,1)
    OrigCenter(iC,:) = OrigIso(iC)*OrigCenter(iC,:);
end
Center = SortData(1).Waveform;
Iso = SortData(1).Iso;
ID = Iso;
OrigID = OrigIso;
newID = zeros(1,14);
for c = 1:14
    dd = zeros(1,14);
    if ID(c)
        for Origc = 1:14
            if OrigID(Origc)
                dd(Origc) = sum((Center(c,:)-OrigCenter(Origc,:)).^2).^0.5;
            end
        end
        IDs = find(OrigID);
        [dum,n] = min(dd(IDs));
        newID(c) = IDs(n);
    end
end
Clu = SortData(1).Clu;
for c = 1:14
    ind = find(Clu(:,2) == c);
    if ~isempty(ind)
        SortData(1).Clu(ind,2) = newID(c);
    end
end
SortData(1).Waveform = zeros(14,nT);
for c = 1:14
    ind = find(SortData(1).Clu(:,2) == c);
    if ~isempty(ind)
        SortData(1).Waveform(c,:) = ...
            mean(MovieData(1).Sp(ind,:));
        SortData(1).Iso(c) = 1;
    else
        SortData(1).Iso(c) = 0;
        SortData(1).Waveform(c,:) = zeros(1,nT);
    end
end

for iFrame = 2:MAXFRAME
    disp(['Frame ' num2str(iFrame)])
    %disp('Getting data')
    sp_seg = MovieData(iFrame).Sp;
    sptimes = MovieData(iFrame).SpTimes;
    SortData(iFrame).Clu(:,1) = sptimes;
    SortData(iFrame).Iso(1:NClus) = 1;
    SortData(iFrame).TempInclude = ones(size(sptimes,1),1);
    SortData(iFrame).RemCell = zeros(1,14);
    SortData(iFrame).RemIso = SortData(iFrame).RemCell;
    if(length(sptimes)>10)
        %disp('Getting pcs')
        [U_seg,pc] = spikepcs([sptimes sp_seg],pcold);
        U_old = MovieData(iFrame-1).Sp*pcold;
        U_new = MovieData(iFrame-1).Sp*pc;
        %disp('Getting mean waveform projs');
        for c = 1:NClus
            ind = post(:,c)>0;
            c_old(c,:) = mean(U_old(ind,1:NDim));
            c_new(c,:) = mean(U_new(ind,1:NDim));
        end
        %disp('getting distances')
        %disp('Dist statement')
        dmat = zeros(NClus,NClus);
        for ki = 1:NClus
            for kj = 1:NClus
                dmat(ki,kj)=sum((c_new(ki,:)-c_old(kj,:)).^2).^0.5;
            end
        end
        %dmat = dist(c_new,c_old');
        for c = 1:NClus
            [a,cind(c)] = min(dmat(c,:));
        end
        %disp('Transforming pcs')
        if NClus>2
            if cind(1)~=1 || cind(2)~=2 || cind(3)~=3
                pc(:,2) = -pc(:,2); U_seg(:,2) = -U_seg(:,2);
            end
        elseif NClus==2
            if cind(1)~=1 || cind(2)~=2
                pc(:,2) = -pc(:,2); U_seg(:,2) = -U_seg(:,2);
            end
        end
        %disp('Saving U_seg')
        U_seg = U_seg(:,1:NDim);
        SortData(iFrame).U = U_seg;
        
        %disp('Do sort')
        ocentres = centres;
        if size(U_seg,1) > NClus
            [centres,options,post] = kmeans(U_seg,NClus);
        end
        [dum,cind] = sort(sqrt(sum(centres'.^2)));
        newpost = zeros(size(post));
        for c = 1:NClus
            ind = post(:,cind(c))>0;
            newpost(ind,c) = 1;
        end
        post = newpost;
        %disp('Assigning cluster ids')
        for c = 1:NClus
            ind = find(post(:,c));
            if ~isempty(ind)
                SortData(iFrame).Clu(ind,2) = c;
                SortData(iFrame).Waveform(c,:) = ...
                    mean(MovieData(iFrame).Sp(ind,:));
            end
        end
        %disp('Merge sort')
        %  Reassign elements
        OrigCenter = SortData(iFrame-1).Waveform;
        OrigIso = SortData(iFrame-1).Iso;
        Center = SortData(iFrame).Waveform;
        Iso = SortData(iFrame).Iso;
        OrigID = zeros(1,14);
        OrigID(sum(OrigCenter,2)~=0)=1;
        ID = Iso;
        OrigID = OrigIso;
        newID = zeros(1,14);
        for c = 1:14
            dd = zeros(1,14);
            if ID(c)
                for Origc = 1:14
                    if OrigID(Origc)
                        dd(Origc) = sum((Center(c,:)-OrigCenter(Origc,:)).^2).^0.5;
                    end
                end
                IDs = find(OrigID);
                [dum,n] = min(dd(IDs));
                newID(c) = IDs(n);
            end
        end
        Clu = SortData(iFrame).Clu;
        Iso = SortData(iFrame).Iso;
        for c = 1:14
            ind = find(Clu(:,2) == c);
            if ~isempty(ind)
                SortData(iFrame).Clu(ind,2) = newID(c);
            end
        end
        SortData(iFrame).Waveform = zeros(14,nT);
        for c = 1:14
            ind = find(SortData(iFrame).Clu(:,2)==c);
            if ~isempty(ind)
                SortData(iFrame).Waveform(c,:) = ...
                    mean(MovieData(iFrame).Sp(ind,:));
                SortData(iFrame).Iso(c) = 1;
            else
                SortData(iFrame).Waveform(c,:) = zeros(1,nT);
                SortData(iFrame).Iso(c) = 0;
            end
        end
    end
end
    
for iFrame = 1:length(SortData)
    SortData(iFrame).Iso = OrigSortData.SortData(targetframe).Iso;
end

save([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.' num2str(ch) '.MovieData.mat'],'MovieData');
save([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.' num2str(ch) '.SortData.mat'],'SortData');

Iso = []; Clu = [];
for iFrame = 1:length(SortData);
    FrClu = SortData(iFrame).Clu;
    Clu = [Clu;FrClu];
    FrIso = SortData(iFrame).Iso;
    Iso = [Iso;FrIso];
end

disp('Saving data to disk');
[MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.clu.mat']
if isfile([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.clu.mat'])
    load([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.clu.mat'],'clu');
    load([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.iso.mat'],'iso');
    clu{ch} = Clu; iso{ch} = Iso;
    save([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.clu.mat'],'clu');
    save([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.iso.mat'],'iso');
    
else
    clu = cell(1,NumChannels); clu{ch} = Clu;
    iso = cell(1,NumChannels); iso{ch} = Iso;
    save([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.clu.mat'],'clu');
    save([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.iso.mat'],'iso');
end
