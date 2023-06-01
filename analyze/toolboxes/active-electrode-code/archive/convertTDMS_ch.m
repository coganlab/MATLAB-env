
function [ob]=convertTDMS_ch(filename, whichChan)

%convertTDMS - function to convert Labview TDMS data files into .mat files.
%   If called with no input, user selects from file open dialog box.  A
%   .mat file with the same filename as the TDMS file is automatically
%   written to the same directory (warning - will over write .mat file of
%   the same name.
%
%   TDMS format is based on information provided by National Instruments
%   at:    http://zone.ni.com/devzone/cda/tut/p/id/5696
%
% convertTDMS(filename)
%
%       Inputs:
%               filename - filename to be converted.  If not supplied, user
%                 is provided dialog box to open file.  Can be a cell array
%                 of files for bulk conversion.
%
%       Outputs:
%               ob - structure with all of the data objects
%               index - index of the information in ob
%

%---------------------------------------------
%Brad Humphreys - v1.0 2008-04-23
%ZIN Technologies
%---------------------------------------------
%---------------------------------------------
%Brad Humphreys - v1.1 2008-07-3
%ZIN Technologies
%-Added abilty for timestamp to be a raw data type, not just meta data.
%-Addressed an issue with having a default nsmaples entry for new objects.
%-Added Error trap if file name not found.
%-Corrected significant problem where it was assumed that once an object
%    existsed, it would in in every subsequent segement.  This is not true.
%---------------------------------------------

%---------------------------------------------
%Grant Lohsen - v1.2 2009-11-15
%Georgia Tech Research Institute
%-Converts TDMS v2 files
%Folks, it's not pretty but I don't have time to make it pretty. Enjoy.
%---------------------------------------------

conver='1.3';    %conversion version number

startingdir=cd; %Get the starting directory

if nargin==0                %If file is not provided,prompt user
    [filename,pathname,filterindex] = uigetfile({'*.*',  'All Files (*.*)'},'Choose File');
    filename=fullfile(pathname,filename);
end

%Create filelist
if iscell(filename)         %If it is a group of files
    numfiles=max(size(filename));
    infilename=filename;
else
    numfiles=1;             %If only one file name is provided
    infilename{1}=filename;
end



for fnum=1:numfiles
    disp([datestr(now,13) ' Begining conversion of:  '  infilename{fnum}])
    
    bytesInfile = dir(infilename{fnum});    %Get size of file.  Needed for later estimation of variable size.
    
    if isempty(bytesInfile)
        error(['Error: ' infilename{fnum} ' not Found']);
    end
    filesize = bytesInfile.bytes;
    
    %Initialize variables for each file conversion
    index.names=[];
    ob=[];
    %firstRawData=1;
    segCnt=0;
    
    fid=fopen(infilename{fnum});
    rawDataInThisSeg = [];
    fseek(fid, 0, 1);
    eoff = ftell(fid)
    fseek(fid, 0, -1);
    while (ftell(fid) ~= eoff)
 %   while ~feof(fid) %does not work
        
       
        
        
        
        Ttag=fread(fid,1,'uint8');
        Dtag=fread(fid,1,'uint8');
        Stag=fread(fid,1,'uint8');
        mtag=fread(fid,1,'uint8');
        if Ttag==84 & Dtag==68 & Stag==83 & mtag==109
            segCnt=segCnt+1;
            if ~isempty(rawDataInThisSeg)
            rawDataInThisSeg(1:length(rawDataInThisSeg))=0;      % Reset the raw data indicator
            end
            
            %ToC Field
            Toc=fread(fid,1,'uint32');
            kTocMetaData=bitget(Toc,2);
            kTocNewObject=bitget(Toc,3);
            kTocRawData=bitget(Toc,4);
            
            %Segment
            vernum=fread(fid,1,'uint32');
            segLength=fread(fid,1,'uint64');
            
            metaRawLength=fread(fid,1,'uint64');
            
            % Process Meta Data
            if kTocMetaData                                     %If there is meta data in this segment
                numNewObjInSeg=fread(fid,1,'uint32');
                
                for q=1:numNewObjInSeg
                    
                    obLength=fread(fid,1,'uint32');             %Get the length of the objects name
                    obname=[fread(fid,obLength,'uint8=>char')]';%Get the objects name
                    
                    %Fix Object Name
                    if strcmp(obname,'/')
                        obname='Root';
                    else
                        obname=fixcharformatlab(obname);
                    end
                    
                    if ~isfield(ob,obname)                         %If the object does not already exist, create it
                        index.names{end+1}=obname;
                        ob.(obname)=[];
                        obnum=max(size(index.names));               %Get the object number
                        newob(obnum)=1;                             %Brand new object
                    else                                            %if it does exist, get it's index and object number
                        newob(obnum)=0;
                        obnum=find(strcmp(index.names,obname)==1,1,'last');
                    end
                    
                    rawdataindex=fread(fid,1,'uint32');             %Get the raw data Index
                    if rawdataindex==0                              %No raw data assigned to this object in this segment
                        index.entry(obnum)=0;
                        index.dataType(obnum)=1;
                        index.arrayDim(obnum)=0;
                        index.nValues(obnum)=0;
                        index.byteSize(obnum)=0;
                        rawDataInThisSeg(obnum)=0;
                    elseif rawdataindex+1==2^32                     %Objects raw data index matches previous index - no changes
                        if ~isfield(index,'entry')                   %The root object will always have a FFFFFFFF entry
                            rawDataInThisSeg=0;
                        else
                            if max(size(index.entry))<obnum         %In case an object besides the root is added that has no dat but
                                rawDataInThisSeg=0;                    %reports using previous
                            end
                        end
                    else                                            %Get new object information
                        index.entry(obnum)=rawdataindex;
                        index.dataType(obnum)=fread(fid,1,'uint32');
                        index.arrayDim(obnum)=fread(fid,1,'uint32');
%                         disp('nvals');
%                         tango = ftell(fid)
%                         if tango == 1633574
%                         disp('halto')
%                         end
                        
                        index.nValues(obnum)=fread(fid,1,'uint64');
                        if index.dataType(obnum)==32                %If the datatype is a string
                            index.byteSize(obnum)=fread(fid,1,'uint64');
                        else
                            index.byteSize(obnum)=0;
                        end
                        rawDataInThisSeg(obnum)=1;
                    end
                    
                    
                    numProps=fread(fid,1,'uint32');
                    for p=1:numProps
                        propNameLength=fread(fid,1,'uint32');
                        propsName=[fread(fid,propNameLength,'uint8=>char')]';
                        propsDataType=fread(fid,1,'uint32');
                        propExists=isfield(ob.(obname),propsName);
                        dataExists=isfield(ob.(obname),'data');
                        
                        if dataExists                                               %Get number of data samples for the object in this segment
                            %nsamps=max(size(ob.(obname).data));
                            
                            
                            nsamps=ob.(cname).nsamples+1;
                            
                        else
                            nsamps=0;
                            estNumSeg=floor(filesize/(20+segLength)*1.2);            %Estimate # of Segements.  20 is the number of bytes prior to the segLength Read
                        end
                        
                        if propsDataType==32                                         %If the data type is a string
                            propsValueLength=fread(fid,1,'uint32');
                            propsValue=fread(fid,propsValueLength,'uint8=>char');
                            if propExists
                                cnt=ob.(obname).(propsName).cnt+1;
                                ob.(obname).(propsName).cnt=cnt;
                                ob.(obname).(propsName).value{cnt}=propsValue;
                                ob.(obname).(propsName).samples(cnt)=nsamps;
                            else
                                ob.(obname).(propsName).cnt=1;
                                ob.(obname).(propsName).value{estNumSeg}=NaN;
                                ob.(obname).(propsName).samples(estNumSeg)=0;
                                ob.(obname).(propsName).value{1}=propsValue;
                                ob.(obname).(propsName).samples(1)=nsamps;
                            end
                        else                                                        %Numeric Data type
                            if propsDataType==68                                     %If the data type is a timestamp
                                tsec=fread(fid,1,'uint64')/2^64+fread(fid,1,'uint64');   %time since Jan-1-1904 in seconds
                                propsValue=tsec/86400+695422-5/24;                   %/864000 convert to days; +695422 days from Jan-0-0000 to Jan-1-1904
                            else
                                matType=LV2MatlabDataType(propsDataType);
                                propsValue=fread(fid,1,matType);
                            end
                            if propExists
                                cnt=ob.(obname).(propsName).cnt+1;
                                ob.(obname).(propsName).cnt=cnt;
                                ob.(obname).(propsName).value(cnt)=propsValue;
                                ob.(obname).(propsName).samples(cnt)=nsamps;
                            else
                                ob.(obname).(propsName).cnt=1;
                                ob.(obname).(propsName).value(estNumSeg)=NaN;
                                ob.(obname).(propsName).samples(estNumSeg)=0;
                                ob.(obname).(propsName).value(1)=propsValue;
                                ob.(obname).(propsName).samples(1)=nsamps;
                            end
                        end
                        
                    end
                    
                end
            end
            
            % Process Raw Data
            
            
            
            
        else
            if ~(isempty(Ttag) & isempty(Dtag) & isempty(Stag) & isempty(mtag))  %On last read, all will be empty
                %error('Unexpected bit stream in file: %s  at segment %d (dec: %d %d %d %d)',infilename{fnum}, segCnt+1, Ttag, Dtag, Stag, mtag);
                fseek(fid, -4, 0);
                %disp('set');
                %ftell(fid)
            end
        end
        
        
        
        for r=1:max(size(index.names))                                      %Loop through the index
            
            if newob(r) & rawDataInThisSeg(r)                               %If brand new object and new raw data, preallocate data arrays
                %                     firstRawData=0;
                newob(r)=0;
                estNumSeg=filesize/(20+segLength);                              %Estimate # of Segements.  20 is the number of bytes prior to the segLength Read
                
                %for b=1:max(size(index.names))
                cname=cell2mat(index.names(r));
                nEstSamples=floor(1.2*estNumSeg*index.nValues(r));
                if index.dataType(r)~=32 | index.dataType(r)~=68             %If the data is numeric type
                    if r == whichChan + 1    % jv - mod 
                        ob.(cname).data(1:(nEstSamples),1)=NaN;
                    end                     % jv - mod
                else                                                         %If the data is string type
                    ob.(cname).data{nEstSamples}=NaN;
                end
                ob.(cname).nsamples=0;
                %end
            end
            if rawDataInThisSeg(r)
                nvals=index.nValues(r);
                if index.dataType(r)~=68                                    %If not a timestamp data type
                    [data cnt]=fread(fid,nvals,LV2MatlabDataType(index.dataType(r)));
                else                                                        %If a timestamp
                    clear data
                    for dcnt=1:nvals
                        tsec=fread(fid,1,'uint64')/2^64+fread(fid,1,'uint64');   %time since Jan-1-1904 in seconds
                        data(1,dcnt)=tsec/86400+695422-5/24;
                    end
                    cnt=dcnt;
                end
                cname=cell2mat(index.names(r));
                if isfield(ob.(cname),'nsamples')
                    ssamples=ob.(cname).nsamples;
                else
                    ssamples=0;
                end
                
                %                     ssamples=ob.(cname).nsamples;
                if index.dataType(r)~=32                                    %If the data is numeric type
                    if r == whichChan + 1    % jv - mod 
                    ob.(cname).data(ssamples+1:ssamples+cnt,1)=data;    
                    end                     % jv - mod
                else                                                        %If the data is string type
                    
                    ob.(cname).data(ssamples+1:ssamples+cnt,1)=data;
                    
                end
                ob.(cname).nsamples=ssamples+cnt;
            end
        end
        %rawDataInThisSeg(1:end)=0;      % Reset the raw data indicator
    end
end


% Clean up preallocated arrays   (preallocation required for speed)
for y=1:max(size(index.names))
    cname=cell2mat(index.names(y));
    if isfield(ob.(cname),'nsamples')
        nsamples=ob.(cname).nsamples;
        if nsamples>0       %Remove any excess from preallocation of data
            if index.dataType(y)~=32
                if y == whichChan + 1    % jv - mod
                    ob.(cname).data=ob.(cname).data(1:nsamples,1);                  %If the data is numeric type
                end                     % jv - mod
            else
                ob.(cname).data=ob.(cname).data(1:nsamples,1);                  %If the data is string type
            end
            
            proplist=fieldnames(ob.(cname));    %Remove any excess from preallocation of properties
            for isaac=1:size(proplist,1)
                if isfield(ob.(cname).(proplist{isaac}),'cnt')
                    cnt=ob.(cname).(proplist{isaac}).cnt;
                    ob.(cname).(proplist{isaac}).value=ob.(cname).(proplist{isaac}).value(1:cnt);
                    ob.(cname).(proplist{isaac}).samples=ob.(cname).(proplist{isaac}).samples(1:cnt);
                    ob.(cname).(proplist{isaac})=rmfield(ob.(cname).(proplist{isaac}),'cnt');
                end
            end
            
        end
    end
end



% Create Output filenames
[pathstr,namestr]=fileparts(infilename{fnum});
namestr=fixcharformatlab(namestr);
%savefilename=fullfile(pathstr,namestr);

if ~isempty(pathstr)
    cd(pathstr)
end
fclose(fid);

%Save Output Data
ob.index=index;
ob.conver=conver;
filename = strcat(namestr,'\',namestr,'_ch',num2str(whichChan));     % jv - mod
save(filename,'-struct','ob', '-v7.3');
disp([datestr(now,13) ' Completed conversion of:  '  infilename{fnum}])



cd(startingdir);

end


function  fixedtext=fixcharformatlab(textin)
%Private Function to remove all text that is not MATLAB variable name
%compatible
textin=strrep(textin,'''','');
textin=strrep(textin,'/Untitled/','');
textin=strrep(textin,'/','.');
textin=strrep(textin,'-','');
textin=strrep(textin,'?','');
textin=strrep(textin,' ','');
textin=strrep(textin,'.','');
textin=strrep(textin,'[','_');
textin=strrep(textin,']','');
textin=strrep(textin,'%','');
textin=strrep(textin,'#','');
textin=strrep(textin,'(','');
textin=strrep(textin,')','');
textin=strrep(textin,':','');
fixedtext=textin;

end

function matType=LV2MatlabDataType(LVType)
%Cross Refernce Labview TDMS Data type to MATLAB

switch LVType
    case 1   %tdsTypeVoid
        matType='';
    case 2   %tdsTypeI8
        matType='int8';
    case 3   %tdsTypeI16
        matType='int32';
    case 4   %tdsTypeI32
        matType='int32';
    case 5   %tdsTypeI64
        matType='int64';
    case 6   %tdsTypeU8
        matType='uint8';
    case 7   %tdsTypeU16
        matType='uint16';
    case 8   %tdsTypeU32
        matType='uint32';
    case 9   %tdsTypeU64
        matType='uint64';
    case 10  %tdsTypeSingleFloat
        matType='float64';
    case 11  %tdsTypeDoubleFloat
        matType='float64';
    case 12  %tdsTypeExtendedFloat
        matType='';
    case 32  %tdsTypeString
        matType='char';
    case 33  %tdsTypeBoolean
        matType='bit1';
    case 68  %tdsTypeTimeStamp
        matType='bit224';
    otherwise
        matType='';
end

end

