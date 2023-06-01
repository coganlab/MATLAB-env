function Write2BNI(data,outname,srate,stime,sdate,labels,sens,comment,path)

% WRITE2BNI - Writes data chunk to BNI file
%	Write2BNI(data,outputfilename,sampling_rate,start_time,start_date,labels,sens)
%	data - nchan x npts matrix
%	outputfilename - basename of output file
%	sampling_rate - duh
%	start_time - 1 x 3 vector of clock time at start of file ([hrs mins secs])
%	start_date - 1 x3 vector of date at start of file ([year month day]), use 4 digit year
%	labels - nchan x ? matrix of labels (as strings, use strvcat to create)
%	sens - sensitivity of recording in uV/bit
%
%	USAGE:
%		On first pass, include all input parameters (there are no defaults): 
%			Write2BNI(data,outputfilename,sampling_rate,start_time,start_date,labels,sens);
%		On subsequent passes, only input data matrix: 
%			Write2BNI(data);
%		On last pass (EOF), input an empty matrix for data
%			Write2BNI([]);

%	CREATED: 5/26/2004 (SDC)
%	MODIFIED: 5/26/2004 (SDC)

% use globals so that the file can be kept open until last chunk
global FILEID NPTS SEQNUM OUTFILE FILEHDR

if nargin > 2, %first time through, start new session
	outname = [outname '.eeg'];
	OUTFILE = fullfile(path, outname);
	FILEID = fopen(OUTFILE ,'w');
	NPTS = 0;
	SEQNUM = 1;
	% create hdr struct
	FILEHDR = eeghdrstruct;
	FILEHDR.rate = srate;
	FILEHDR.nchan = size(labels,1);
	FILEHDR.labels = labels;
	FILEHDR.sens = sens;
	FILEHDR.datevec = [sdate stime];
    FILEHDR.comment = comment;
elseif isempty(data), %close session
	fclose(FILEID);
	WriteBNIHdr;
	clear global FILEID NPTS SEQNUM OUTFILE FILEHDR
else, % new chunk for open session
	NPTS = NPTS + size(data,2);
	fwrite(FILEID,data,'int16');
	nbytes = NPTS*FILEHDR.nchan*2;
	% check that we haven't written too much and open new file if so
	% and write the header
	if nbytes > 650e6,
		fclose(FILEID);
		WriteBNIHdr;
		[pa,fn,ext] = fileparts(OUTFILE);
		OUTFILE = fullfile(pa,sprintf('%s.%03d',fn,SEQNUM));
		FILEID = fopen(OUTFILE,'w');
		SEQNUM = SEQNUM + 1;
		% ugh, I need to change the header datevec, not too hard
		FILEHDR.datevec(6) = FILEHDR.datevec(6) + NPTS/FILEHDR.rate;
		FILEHDR.datevec = round(datevec(datenum(FILEHDR.datevec)));
		NPTS = 0;
	end
end


function WriteBNIHdr
global OUTFILE FILEHDR SEQNUM
[pa,fn,ext] = fileparts(OUTFILE);
if strcmp(lower(ext),'.eeg'),
	bnihdrfile = fullfile(pa,[fn '.bni']);
else,
	bnihdrfile = fullfile(pa,[fn ext '.bni']);
end
hdr.nextfile = fullfile(pa,sprintf('%s.%03d',fn,SEQNUM));
%writebnihdr(bnihdrfile,OUTFILE,hdr,hdr.channels,hdr.labels);
writebnihdr(bnihdrfile,OUTFILE,FILEHDR,FILEHDR.labels,FILEHDR.labels);
	