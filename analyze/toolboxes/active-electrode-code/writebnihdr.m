function writebnihdr(bnihdrfile,bnifile,hdr,channels,labels)

% WRITEBNIHDR - writes the bni header file
%  writebnihdr(bnihdrfile,bnifile,hdrstruct,channels,labels)
sdate = hdr.datevec([2 3 1]);
stime = hdr.datevec(4:6);

if nargin < 4, channels = hdr.channels; end
if nargin < 5, labels = hdr.labels; end
nchan = size(channels,1);

%write bni header file
fid = fopen(bnihdrfile,'w');
fprintf(fid,'FileFormat = BNI-1\r\n');

[pa,fn,ext] = fileparts(bnifile);   % exclude path from .bni file
fprintf(fid,'Filename = %s\r\n',[fn ext]);
fprintf(fid,'Comment = \r\n');
[pa,fn,ext] = fileparts(bnifile);
fprintf(fid,'PatientName = %s\r\n',fn);
fprintf(fid,'PatientId = %s\r\n', hdr.comment);
fprintf(fid,'PatientDob = \r\n');
fprintf(fid,'Sex = \r\n');
fprintf(fid,'Examiner = \r\n');
fprintf(fid,'Date = %02d/%02d/%04d\r\n',sdate);
fprintf(fid,'Time = %02d:%02d:%02d\r\n',stime);
fprintf(fid,'Rate = %d Hz\r\n', hdr.rate);
fprintf(fid,'EpochsPerSecond = 1\r\n');
fprintf(fid,'NchanFile = %d\r\n',nchan);
fprintf(fid,'NchanCollected = %d\r\n',nchan);
fprintf(fid,'UvPerBit = ');
for i = 1:length(hdr.sens), fprintf(fid, '%f,',hdr.sens(i)); end
fprintf(fid,'\r\n');
str = [];
for k = 1:size(labels,1),
    str = [str deblank(char(labels(k,:))) ','];
end
fprintf(fid,'MontageRaw = %s\r\n',str);
fprintf(fid,'DataOffset = 0\r\n');
fprintf(fid,'eeg_number = %s\r\n',fn);                        
fprintf(fid,'technician_name = \r\n');
fprintf(fid,'last_meal = \r\n');
fprintf(fid,'last_sleep = \r\n');
fprintf(fid,'patient_state = \r\n');
fprintf(fid,'activations = \r\n');
fprintf(fid,'sedation = \r\n');
fprintf(fid,'impressions = \r\n');
fprintf(fid,'summary = \r\n');
fprintf(fid,'age = \r\n');
fprintf(fid,'medications = \r\n');
fprintf(fid,'history = \r\n');
fprintf(fid,'diagnosis = \r\n');
fprintf(fid,'interpretation = \r\n');
fprintf(fid,'correlation = \r\n');
fprintf(fid,'medical_record_number = \r\n');
fprintf(fid,'location = \r\n');
fprintf(fid,'referring_physician = \r\n');
fprintf(fid,'technical_info = \r\n');
fprintf(fid,'sleep = \r\n');
fprintf(fid,'indication = \r\n');
fprintf(fid,'RefName = \r\n');
fprintf(fid,'DCUvPerBit = 0\r\n');
fprintf(fid,'[Events]\r\n');
if ~isempty(hdr.montage),
    fprintf(fid,'0.000000\t0\t%d	Montage: Selected Lines: %d\n',nchan-1,nchan);
    %if we're clipping eeg, most likely not all the channels are being saved. 
    %In that case, we only want to save the montages that contain valid channel labels
    for k = 1:size(hdr.montage,1),
        if IsLabel(hdr.labels,deblank(hdr.montage(k,:))), %| k == size(hdr.montage,1),
            fprintf(fid,'%s\n',deblank(hdr.montage(k,:)));
        end
    end
end
for k = 1:size(hdr.events,1),
    fprintf(fid,'%s\n',deblank(hdr.events(k,:)));
end
L = length(hdr.mpginfo);
for k = 1:L,
    fprintf(fid,'%f\t%d\t%d\tMPEG File Start: %s DeltaStartMs: 0 IframeOffsetMs: 0\n',hdr.mpginfo(k).starttime,hdr.mpginfo(k).mpgfile);
    fprintf(fid,'%f\t%d\t%d\tMPEG File End: %s DeltaEndMs: 0\n',hdr.mpginfo(k).endtime,hdr.mpginfo(k).mpgfile);
end    
if ~isstr(hdr.nextfile),
    fprintf(fid,'NextFile = %s.%03d',fn,1);
else,
    fprintf(fid,'NextFile = %s',hdr.nextfile);
end
fclose(fid);

function islbl = IsLabel(labels,txt)
I = findstr(txt,',');
islbl = 0;
if ~isempty(I),
    txt = txt(1:I(1)-1); %got the montage labels
    I = findstr(txt,'-');
    if ~isempty(I), %there are two labels, i.e. bipolar montage
        lbl1 = txt(1:I(1)-1);
        lbl2 = txt(I(1)+1:end);
        for k = 1:size(labels,1),
            if strcmp(deblank(labels(k,:)),lbl1) | strcmp(deblank(labels(k,:)),lbl1), islbl = islbl + 1; end
        end
        islbl = islbl==2;
    else, %only one label, referential
        for k = 1:size(labels,1),
            if strcmp(deblank(labels(k,:)),txt), islbl = 1; end
        end
    end
end
