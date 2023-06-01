% Tests filtering speech from the modulation spectrum. 
function [] = onemodfilter(filter)

if nargin < 1
    filter.method = 3;
    filter.fband = 32;
    filter.wf_high = 0.003;
    filter.wt_high = 1;
    filter.wf_it = 0;
    filter.wt_it = 0;
    filter.song_path = './SpeechTestSentences/baby/baby_0';
    filter.mod_song_name = 'baby_lpf_f3t1';
    filter.mod_song_path= './FilteredFiles/baby_lpf_f3t1';
end


%%make sound pressure file from wav file
[song_in fs]= wavread(filter.song_path);


soundsc(song_in, fs);

% First low pass filter below 10 Hz filter and 0.25 cyc/kHz
%sound_lp = modfilter(song_in, fs, 32, 3, 0.00025, 100, 0, 0);


% First filter the sound
sound_lp = modfilter(song_in, fs, filter.fband, filter.method, filter.wf_high, filter.wt_high, filter.wf_it, filter.wt_it, filter);

% Then prevent +1 and -1
sound_lp_fixed = sound_lp;
sound_lp_fixed(find(sound_lp<-1)) = -1;
sound_lp_fixed(find(sound_lp>1)) = 1;
soundsc(sound_lp_fixed, fs);

%save the file
modsoundfile = sprintf('%s.wav', filter.mod_song_path);
wavwrite(sound_lp_fixed, fs, 16, modsoundfile);

