function procDisplay(day,rec)
%
%   procDisplay(day,rec)
%

global MONKEYDIR

olddir = pwd;

recs = dayrecs(day);
nRecs = length(recs);

if nargin < 2
    num = [1,nRecs];
elseif ischar(rec)
    num = [find(strcmp(recs,rec)),find(strcmp(recs,rec))];
elseif length(rec)==1
    num = [rec,rec];
elseif length(rec)==2
    num = rec;
end
num;
for iNum = num(1):num(2)
    % disp(num2str(iNum))
    recs{iNum}
    fid = fopen([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.display.dat']);
    events = load([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.ev.txt']);
    %load([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.Rec.mat']);
    if isfile([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.experiment.mat'])
        load([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.experiment.mat']);
        SAMPLING =  experiment.hardware.acquisition(1).samplingrate./1e3;
        FORMAT = experiment.hardware.acquisition(1).data_format;
    elseif isfile([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.Rec.mat'])
        load([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.Rec.mat']);
        SAMPLING = Rec.Fs;
        if isfield(Rec,'BinaryDataFormat')
            FORMAT = Rec.BinaryDataFormat;
        else
            FORMAT = 'short';
        end
    end
    NEWFS = SAMPLING./5;
    if size(events,1)>1
        ind = find(events(:,2)==0);
        TrialStarts = events(ind,:);
        data = fread(fid,[inf],FORMAT); fclose(fid);
        data = data(1:SAMPLING/NEWFS:end);
        data = mymedfilt1(data,5);
        switch FORMAT
            case 'short'
                newdata = zeros(size(data))+2048;
                newdata(data>2500)=4095;
                data = newdata; clear newdata
        end
        [n,x] = hist(data,200);
        [a,b] = sort(n,'descend');
        levels = x(b(1:2));
        switch FORMAT
            case 'ushort'
                midlevel = 4e4;
            case 'short'
                midlevel = 3e3;
        end
        if max(levels) < midlevel
            disp('No display state changes')
             fid = fopen([MONKEYDIR '/' day '/' recs{iNum}  '/rec' recs{iNum} '.display.txt'],'w');
             fprintf(fid, ' ');
             fclose(fid);
        else
            h = 10;
            data = smooth(data,h); data(1:h+1) = data(h+2);
            fd = zeros(1,length(data));
            fd(find(data > 1.1*mean(levels)))=1;   % Define 0/1 vector
            mean(levels)
            a = find(abs(diff(fd)));                 % See when it changes
            %  Want to remove all elements of a that are within
            %         T = zeros(1,length(a)); T(find(a)) = 1;  %  Set change times to 1
            %A = round(find(diff(T)>0)./NEWFS);
            min(diff(a))
            A = round(a./NEWFS);
            disp('Entering trial loop');
            if size(A,2)>0 & size(TrialStarts,1)>1
                d = zeros(length(A),2); d(:,2) = A;
                for iTr = 1:size(TrialStarts,1)-1
                    ind = find(A>TrialStarts(iTr,3) & A<TrialStarts(iTr+1,3))
                    plot(data(TrialStarts(iTr,3)*NEWFS:TrialStarts(iTr+1,3)*NEWFS));
                    title(num2str(iTr));
                    % disp(num2str(iTr))
                    %pause
                    if length(ind)>6
                        disp(['Warning: ' num2str(length(ind)) ' display state changes on ' num2str(iTr)]);
                        pause
                    end
                    d(ind,1) = TrialStarts(iTr,1);
                end
                ind = find(A>TrialStarts(end,3));
                if ~isempty(ind) d(ind,1) = TrialStarts(iTr,1); end
                fid = fopen([MONKEYDIR '/' day '/' recs{iNum}  '/rec' recs{iNum} '.display.txt'],'w');
                fprintf(fid,'%d\t%d\n',d');
                fclose(fid);
            end
        end
    end
end
