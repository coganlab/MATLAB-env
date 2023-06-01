function[]=makemodfilterfiles(song_name, method, wf_high_matrix, wt_high_matrix, wf_it_matrix, wt_it_matrix, fband);

%% Filters the modulation spectrum of sound using one or many filters
%%song_name is the name of the sound you wish to filter. If you wish 
% % method 1 is notch filter where wf_high is the lower bound for spectral 
% modulations in cycles/Hz and wf_high+wf_it is the upper bound in 
% cycles/Hz (similarly for wt in Hz).
% For a spectral notch, wt filtering limits extend from 0 to at least 100.
% For a temporal notch, wf filtering limits extend from 0 to at least .016.
% % method 2 is high-pass filter where wf_high and wt_high are the cutoff
% frequencies (higher bound of the filter).  Set wf_it and wt_it to 0.
% % method 3 is low-pass filter where wf_high and wt_high are the cutoff
% frequencies (lower bound of the filter).
% % method 4 is unfiltered for control purposes

%%choose filtering method and limits
if nargin <7
    fband = 32;                                   %fband is the width of the frequency band - use 32 Hz for speech - 125 Hz for zebra finch song
end


if nargin < 4
    wf_high_matrix = [0.002];                     %values of wf_high (cycles/Hz) to be used for filtering,
                                                    %%wf_high_matrix and wf_it_matrix must be of same dimension.
    wt_high_matrix = [4];                          %values of wt_high (Hz) to be used for filtering,
end                                                 %% wt_high_matrix and wt_it_matrix must be of same dimension.

if nargin < 6
    wf_it_matrix = zeros(size(wf_high_matrix));    %values of wf_it: if unspecified, will create a matrix of zeroes of same dimension as wf_high
    wt_it_matrix = zeros(size(wt_high_matrix));    %values of wt_it; if unspecified, will create a matrix of zeroes of same dimension as wt_high
end

if nargin <2
    method = 3;                                   %choose method
end
                                    
autopath = 1;                                        %%song names and song folders. Set autopath to 0 if you want to specify your own path
                                                    
if autopath
    song_folder = './SpeechTestSentences/';
    mod_song_folder = './FilteredFiles/';

    if nargin > 0
        tmpname = song_name;
        song_name = sprintf('%s/%s_0', tmpname,tmpname);
        mod_song_name = sprintf('%s',tmpname);
    end
    if nargin == 0
        song_name = 'baby/baby_0';
        mod_song_name = 'baby';
    end
else 
    song_folder = '' ; %% song folder path
    mod_song_folder = ''; %% mod song folder path
    mod_song_name = song_name;
end

%%create filters
rep = 0;
methodnames = {'nf';'hpf';'lpf';'uf'};


for wf = 1:1:length(wf_high_matrix)
    for wt = 1:1:length(wt_high_matrix)
        rep = rep + 1;
        filter(rep).method = method;
        filter(rep).wf_high = wf_high_matrix(wf);
        filter(rep).wt_high = wt_high_matrix(wt);
        filter(rep).wf_it = wf_it_matrix(wf);
        filter(rep).wt_it = wt_it_matrix(wt);
        filter(rep).fband = fband;
        if filter(rep).method == 1
            filter(rep).mod_song_name = sprintf('%s_%s_f%g-%gt%g-%g', mod_song_name, char(methodnames(filter(rep).method)), filter(rep).wf_high*1000, filter(rep).wf_it*1000, filter(rep).wt_high, filter(rep).wt_it);
        else
            filter(rep).mod_song_name = sprintf('%s_%s_f%gt%g', mod_song_name, char(methodnames(filter(rep).method)), filter(rep).wf_high*1000, filter(rep).wt_high);
        end
        filter(rep).song_path = sprintf('%s%s', song_folder, song_name);
        filter(rep).mod_song_path = sprintf('%s%s',mod_song_folder, filter(rep).mod_song_name);
    end
end
           
numrepeats = length(wf_high_matrix)*length(wt_high_matrix);

%pass filters to onemodfilter
for rep = 1:1:numrepeats;
    onemodfilter(filter(rep));
end
  
