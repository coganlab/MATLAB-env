function procDisplay(day,rec)
%
%   procDisplay(day,rec)
%

global MONKEYDIR MONKEYNAME



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

for iNum = num(1):num(2)
    disp(num2str(iNum))
    fid = fopen([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.display.dat']);
    events = load([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.ev.txt']);
    load([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.Rec.mat']);
    SAMPLING = Rec.Fs./1e3;
    if size(events,1)>1
        ind = find(events(:,2)==0);
        TrialStarts = events(ind,:);
        if isfield(Rec,'BinaryDataFormat')
            data = fread(fid,[inf],Rec.BinaryDataFormat); fclose(fid);
        else
            data = fread(fid,[inf],'ushort'); fclose(fid);
        end
        [n,x] = hist(data(1:min([1e6,end])),200);
        [a,b] = sort(n,'descend');
        levels = x(b(1:2));
        h = 10;
        data = smooth(data,h); data(1:h+1) = data(h+2);
        fd = zeros(1,length(data));
        levels;
        fd(find(data > 1.1*mean(levels)))=1;   % Define 0/1 vector
        clear data
        mean(levels);
        a = abs(diff(fd));                 % See when it changes
        %data = data(1:SAMPLING/4:end);
        %  Want to remove all elements of a that are within
        T = zeros(1,length(a)); T(find(a)) = 1;  %  Set change times to 1
        A = round(find(diff(T)>0)./SAMPLING);
        if size(A,2)>0
            d = zeros(length(A),2); d(:,2) = A;
            for iTr = 1:length(TrialStarts)-1
                ind = find(A>TrialStarts(iTr,3) & A<TrialStarts(iTr+1,3)) 
               % plot(data(TrialStarts(iTr,3)*20:TrialStarts(iTr+1,3)*20));
                title(num2str(iTr));
                %pause
                if length(ind)>6
                    disp(['Warning: ' num2str(length(ind)) ' display state changes on ' num2str(iTr)]);
                    pause
%                     fd(find((data>levels(1)+4) & (data<levels(1)+6)))=1;
%                     a = abs(diff(fd));
%                     T = zeros(1,length(a)); T(find(a)) = 1;  %  Set change times to 1
%                     A = round(find(diff(T)>0)./SAMPLING);
%                     bb = find(diff(A)>100);
%                     A = A(bb);
%                     dt = zeros(length(A),2); dt(:,2) = A;
%                     x = find(d(:,1)>0);
%                     if length(x)
%                         dt(1:x(length(x)),:) = d(1:x(length(x)),:);                      
%                     end
%                     d = dt;
%                     ind = find(A>TrialStarts(iTr,3) & A<TrialStarts(iTr+1,3))
%                     plot(data(TrialStarts(iTr,3)*20:TrialStarts(iTr+1,3)*20));
%                     if length(ind)>6
%                         %plot(data(TrialStarts(iTr,3)*20:TrialStarts(iTr+1,3)*20));
%                         ind
%                     end
                end
                d(ind,1) = TrialStarts(iTr,1);
            end
            ind = find(A>TrialStarts(end,3));
            if length(ind) d(ind,1) = TrialStarts(iTr,1); end
            fid = fopen([MONKEYDIR '/' day '/' recs{iNum}  '/rec' recs{iNum} '.display.txt'],'w');
            fprintf(fid,'%d\t%d\n',d');
            fclose(fid);
        end
    end
end
