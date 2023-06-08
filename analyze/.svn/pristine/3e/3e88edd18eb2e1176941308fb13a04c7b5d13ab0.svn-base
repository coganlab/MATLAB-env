
function  procAudioVideoSync(day,num)
% procAudioVideoSync(day,num)
%
% processes wav file from video monitoring avi file to give video sync file
%
%  Inputs:  DAY        =   String. Day to calibrate.
%           NUM        =   Cell. Recording number to calibrate
%                               Defaults to {'001'}
%
%

global MONKEYDIR MONKEYNAME experiment

olddir = pwd;

if nargin < 2
    num = dayrecs(day);
end
figure;
% Load data for recordings

recording_filename = make_filename_root(recording_filename_root); %removes suffix if necess
calvin_ppc_sc32_mocap
readerobj = mmreader('/mnt/sas1/Reggie_Pmd_SC32x2/matlab/mfiles/Yan/video/Power_Posterior.avi')
%readerobj = mmreader('/mnt/sas1/Reggie_Pmd_SC32x2/matlab/mfiles/Yan/video/Power_wand_Camera_Posterior.mp4')

% Read in all video frames.
vidFrames = read(readerobj);

% Get the number of frames.
numFrames = get(readerobj, 'numberOfFrames');

% Create a MATLAB movie struct from the video frames.
for k = 1 : numFrames
    mov(k).cdata = vidFrames(:,:,:,k);
    mov(k).colormap = [];
end


figh = get(0, 'CurrentFigure'); %use setappdata to report percent done if in GUI

tic
CH = 2; SIZEOF_WAV = 2;
FS = 48000;
T = 0.25;
THRESHOLD = 0.01;   
DECIMATION_FACTOR = 4;
wav_file = [recording_filename_root '.wav'];
prev_stdwav = 0;
prev_code = 0;
if isfile(wav_file)
    wav_size = file_size(wav_file);
    videosync_file = [recording_filename_root '.wavvideosync.txt'];
    videosync_fid = fopen(videosync_file, 'wt');
    
    iCode = 0;  videosync_data= [];
    maxN = floor(wav_size./CH./SIZEOF_WAV./FS./T);
    for N = 1:maxN
        
        %             disp(['WAV: Loop ' num2str(N)]);
        wav = wavread(wav_file, [(N-1)*FS*T + 1,N*FS*T]);
        wav = wav(1:DECIMATION_FACTOR:end,audio_ch) - mean(wav(1:DECIMATION_FACTOR:end,audio_ch));
        stdwav = std(wav);
        if stdwav > THRESHOLD && prev_stdwav < THRESHOLD
            iCode = iCode + 1;
            wintime = find(abs(wav)>THRESHOLD,1,'first');
            timestamp = (N-1)*T + DECIMATION_FACTOR.*wintime./FS;  % Timestamp in seconds
            code = demodulate_timecode(wav, FS./DECIMATION_FACTOR);
            disp(['Code detected: ' num2str(code)]);
            videosync_data(iCode,1) = timestamp;
            videosync_data(iCode,2) = code;
            
            if code ~= prev_code + 1;
                %plot(comedi)
                %pause;
            end
            prev_code = code;
        end
        
        prev_stdwav = stdwav;
        
        %             if(~isempty(figh)),
        %                setappdata(figh, 'percent_done', ftell(comedi_fid)/comedi_size);
        %             end
        
        
    end
    
    %  Fix isolated code errors
    a = diff(videosync_data(:,2));
    ind = find(a<1);  %  Timecodes that don't step by one.
    for iInd = 1:length(ind);
        if videosync_data(ind(iInd)+2,2) == videosync_data(ind(iInd),2)+2;
            videosync_data(ind(iInd)+1,2) = videosync_data(ind(iInd),2)+1;
        end
    end
    
    %  Write to disk
    for iCode = 1:size(videosync_data,1)
        timestamp = videosync_data(iCode,1);
        code = videosync_data(iCode,2);
        fprintf(videosync_fid,'%6.3f\t%d\n',timestamp,code);
    end
    fclose(videosync_fid);
    
else
    ret = false;
    disp('No wav file found.  Skipping.')
end
ret = true;
end