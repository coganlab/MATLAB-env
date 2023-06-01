function  [digital_timecodes, timestamps] = parsePhasespaceTimeCode(timecode, strobe_threshold)
% 
% [digital_timecodes, timestamps] = parsePhasespaceTimeCode(timecode, strobe_threshold)
% 

global experiment

disp('In parsePhasespaceTimeCode')

ep = 2;

logicalcode = timecode > strobe_threshold;
trans = find(abs(diff(logicalcode)));
% negtrans = find(diff(logicalcode)<0);
% End time is detected by the signal going high for greater than 250 ms.
gapind = find(diff(trans)>250)+1
gaptime = trans(gapind)

timestamps = nan(1,length(gaptime)-2);
digital_timecodes = nan(1,length(gaptime)-2);
for iGap = 1:length(gaptime)-2
    if gaptime(iGap+1) - gaptime(iGap) > 1e3-ep
        timestamps(iGap) = gaptime(iGap+1);
        seq = logicalcode(gaptime(iGap+1):gaptime(iGap+2));
        timecodebits = seq(12:25:end);
        byte0 = timecodebits(2:9);
        byte1 = timecodebits(12:19);
        byte2 = timecodebits(22:29);
        byte3 = timecodebits(31:40);
%         sumcode = 0;
        if sum(byte3) == 10
            timecode0 = bin2dec(strcat(num2str(byte0))');
            timecode1 = bin2dec(strcat(num2str(byte1))')*2^8;
            timecode2 = bin2dec(strcat(num2str(byte2))')*2^16;
            digital_timecodes(iGap) = timecode0 + timecode1 + timecode2;
        else
            error('Error');
        end
    end
end

disp('Leaving parsePhasespaceTimeCode')