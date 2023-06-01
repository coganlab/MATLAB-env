% This is
% for Vm (not spikes) and is a forward correlation (not reverse as
% for spikes.
%
% convert Vm to msecs by averaging over 10 values:
%
for i=10:10:length(Vm)
    temp = 0;
    for j=0:9
        temp = temp + Vm(i-j);
    end
    V(i/10) = temp/10;
end

%
% get the correct list and read it
%
ln = menu('Choose a list','1x1','3x3','5x5','7x7');
switch ln
    case 1
        listname = 'LIST1x1';
    case 2
        listname = 'LIST3x3';
    case 3
        listname = 'LIST5x5';
    case 4
        listname = 'LIST7x7';
    otherwise
        listname = 'LIST3x3';
end
fid = fopen(listname,'rb');
S = uint16(fread(fid,250*32*Nblocks,'uint16'));
fclose(fid);

% you must know what is the first block of stimuli and the last.
% I do it graphically, i.e., with ginput().  In the following, I
% assume you have Blocklow (usually 1) and Blockhi,

%
% get the frame width.  Sometimes, its off by 0.1 msec so allow
% for correction by user
%
FW      = round((Events(2,2) - Events(1,2))/10);
disp(['Frame width = ' num2str(FW) ' ms']);
q = input(['Is FW correct?  '],'s');
if q == 'n'
    FW = input('Submit correct FW  ');
end

%
% the forward correlation:
%
fc = zeros(4,16,16,41);                     % 4 luminance values
                                            % 16 x
                                            % 16 y
                                            % 200 msecs (5 ms steps)
counts = zeros(4,16,16);
WmB = zeros(16,16,41);                     % White minus Black
Vtmp= zeros(4,16,16,41);        % this should prolly be (1,1,1,41)?
tail = ceil(200/FW + 1);

    %... make table of the times of the first usable
    %    frame in each block 

for i=1:Nblocks
    fstarts(i) = E(250*(i-1)+1,2);
end

    %... do the forward correlation
    
for N = Blocklow:Blockhi                    % over all blocks
    disp(['Block no. ' num2str(N)]);
    for F = 1:250 - tail                    % all frames except slop at the end
        tE = fstarts(N)+FW*(F-1);           % time of ith frame
        f = 250*(N-1) + F;                  % ith frame in Stimulus List
        for i=0:40
            Vtmp(1,1,1,i+1) = V(tE+5*i);
        end
        for w=0:31                                          % 32 words per frame
            stimholder = S(32*f + w + 1);                   % get one word (8 pixels)
            row = 15 - floor(w/2) + 1;                      % row coordinate
            col = 8*rem(w,2) + 1;                           % col coordinate
            for j=0:7
                colmn = col + j;                            % final col coordinate
                k = rem(stimholder,4) + 1;                  % contrast this pixel
                fc(k,row,colmn,1:41) = fc(k,row,colmn,1:41) + Vtmp(1,1,1,1:41);            
                counts(k,row,colmn) = counts(k,row,colmn) + 1;
                stimholder = bitshift(stimholder,-2);
            end
        end
    end
end
    %... normalize by the number of stimuli

for k=1:4
    for r = 1:16
        for c = 1:16
            fc(k,r,c,:) = fc(k,r,c,:)/counts(k,r,c);
        end
    end
end

%
% calculate White - Black (you can also calculate White + Gray -
% Dark - Black but it usually looks basically the same)???
%
for t=1:41
    for i=1:16
        for j=1:16
            WmB(i,j,t) = fc(4,i,j,t) - fc(1,i,j,t);
        end
    end
end

%
% And, just for fun, one can easily do a statistical plot of WmB
% at some tau (provided by user in msecs or where the response is
% maximal or whatever.
%
    % first estimate the SD at unrealistic taus (here 0-15 ms)
for i=1:3
    Z(1:16,1:16) = WmB(1:16,1:16,i);
    SD(i) = mean(std(Z)); 
end
sd = mean(SD);

    % make a figure and plot at selected tau:
Z(1:16,1:16) = WmB(1:16,1:16,tau/5)/sd;
Mxs = max(max(Z));
mns = min(min(Z));
contourf(X,Y,Z);
caxis([mns Mxs]);
xlim([-Xexc/2 Xexc/2]);
ylim([-Xexc/2 Xexc/2]);
title([num2str(tau) ' ms, statistical plot'],'FontWeight','Bold');
colorbar()

% whoopee











