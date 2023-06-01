clear
[data,t,x] = load_open_ephys_data('u.continuous');

%data=smooth(data,200);
fs = 30000 %30000; %open ephys sampling frequency used
numframes = 1; %frames per bit on display
refresh = 1/60; %refresh period of monitor
bitsperpacket = 8; %number of bits for each data packet
bitperiod = numframes*refresh*fs;


nyq = fs/2;

% filtorder=1000;
%  m = [0 0 1 1 0 0];
%  fvals = [0 3/nyq 6/nyq 1000/nyq 1050/nyq 1] ;
% m = [1 1 0 0];
% fvals = [0 500/nyq 550/nyq 1];
% filtery = firls(filtorder,fvals,m);
% dataFIR=filtfilt(filtery,1,data);

 [b,a]=butter(2,50/nyq,'low');
 dataIIR=filter(b,a,data);

data=dataIIR;

data = data(266001:1860000);

%smooth?
%data=abs(smooth(data,200));
cutoff =28900 % 0.16; % 0.15
filtereddata=zeros(1,length(data));
ii=find(data>cutoff);
filtereddata(ii)=1;
%data2(ii)=1;
%filtereddata=data2;
risingedgetimes = find(diff(filtereddata)>0);
risingedges=zeros(1,length(data));
risingedges(risingedgetimes) = 1;
% the beginning!
startbittime = risingedgetimes(1);

%risingedges=cat(2,risingedges,zeros(1,5000));


figure(4)
plot(risingedges)
axis([0 size(risingedges,2) -0.2 1.2]);



%Loop for extracting the data
finaldata = [];
    counter=0;

while (1)
    for (n = 1:bitsperpacket) %extract one byte(arbitrary size, packet) at a time flanked by start/stop bits
         %uses average value of signal during each bit period to allow for
         %error
        val = round(mean(filtereddata(startbittime+(n)*bitperiod:startbittime+(1+n)*bitperiod)));
        %finaldata = [finaldata,val];
        testval(counter+1,n)=val;
    end
    counter=counter+1;
    %Getting the next start bit after the end of the previous stop bit
    newrisingedges = risingedgetimes(find(risingedgetimes>(startbittime+(bitsperpacket+1)*bitperiod)));
    if (isempty(newrisingedges))
        break;
    end
    startbittime = newrisingedges(1);
end
%fprintf('%d',finaldata)

figure(5);imagesc(testval)

for i=1:size(testval,1);
    testval_dec(i)=bi2de(fliplr(testval(i,:)));
end

testval_dec
    
   
close all
