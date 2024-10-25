
global MONKEYDIR

MONKEYDIR = '/vol/sas3b/Spiff_Stable_M1_ECoG244/'%'/mnt/sraid/Spiff_Stable_M1_ECoG244/'; %'/mnt/sraid/Spiff_Stable_M1_ECoG244'; %;
fs = 14;

datType = 'nspike';
drive = 1;
Rec = 1;
Day = '150901';

disp('Loading data...')
dat = readTSdat(Day, Rec, drive, datType, 30);

disp('creating trials...')
dat.tsDat_tr = createArbitraryTrials(dat.tsDat, 2, 30000);

datParams.fileType = datType;
datParams.sigmaThreshold = -1; %don't reject outlier trials. too slow. 
[specDat, ~] = calcPowerSpec([], [], [], 'indChan_trAvg', struct([]), datParams, dat);


figure
subplot(2,2,[1 2])
plot(specDat(1).freq, sq(log(mean(specDat.PS,2)))')
set(gca, 'xlim', [0 100])
xlabel('Frequency (Hz)')
ylabel('Power')
set(gca, 'fontSize', fs)
hold on
plot(specDat(1).freq, sq(log(mean(mean(specDat.PS,2),1))), 'color', [0.1 0.1 0.1], 'lineWidth', 5)



%map electrodes
if isnumeric(Rec)
    tmp = cell(size(Rec));
    for iR=1:length(Rec)
        if Rec(iR)<10
            numTag = '00';
        elseif Rec(iR)<100
            numTag = '0';
        else
            numTag = '';
        end
        
        tmp{iR} = [numTag, num2str(Rec(iR))];
    end
    
    Rec = tmp;
end
load([MONKEYDIR, '/', Day, '/', Rec{:}, '/rec', Rec{:}, '.experiment.mat'], 'experiment');
%experiment.hardware.microdrive(1).pcbConfig = {'3a', '3b', '4a', '4b', '1a', '1b', '2a', '2b'};
experiment.hardware.microdrive(1).configFile = '/mnt/pesaranlab/People/Amy/ecog/channelMappings/JW_pt244ch';
[microdrive, row, col, ch_ind] = layoutDef_ECOG244_JWpt(experiment.hardware.microdrive(drive));


fMin = 20;
fMax = 30;
%average over time 
P = sq(mean(specDat(1).PS, 2)); 
f_inds = specDat(1).freq>fMin & specDat(1).freq < fMax;

P_band = sq(mean(log(P(:,f_inds)),2));

%reshape based on row/col
P_band_img = nan(max(row)+1, max(col)+1);
for i=1:length(P_band)
    if ~isnan(row(i))
    P_band_img(row(i)+1, col(i)+1) = P_band(ch_ind(i));
    end
end
subplot(2,2,3)
imagesc(P_band_img)
title(['mean log-power in ', num2str(fMin), ' - ', num2str(fMax), ' Hz range'], 'fontSize', fs)
set(gca, 'fontSize', fs)

%corr vs distance
disp('Calculating correlations...')
C = calcTScorr(dat.tsDat);
dist = computeElectrodeDistance(col, row);
    
%reshape into row vector 
C = C(:);
dist = dist(:);

nDist = 10;

[~,bins] = hist(dist, nDist);
bins = [0 bins];
for iB=1:nDist
        %all channels
        inds = dist >= bins(iB) & dist < bins(iB+1);
        mC(iB) = nanmean(C(inds),1);
        sdC(iB) = nanstd(C(inds),[],1);
        
end

D = bins(2:end)-diff(bins);

subplot(2,2,4)
plot(D, mC, 'b', 'lineWidth', 2)
hold on
plot(D, mC-sdC, 'b--', 'lineWidth', 2)
plot(D, mC+sdC, 'b--', 'lineWidth', 2)
xlabel('Electrode distance (row/col)', 'fontSize', fs)
ylabel('Mean Correlation', 'fontSize', fs)
set(gca, 'fontSize', fs)
