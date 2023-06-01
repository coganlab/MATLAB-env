function handles = procCluWaveClus_params
%% adpoted for procCluWaveClus
handles.par.stdmin = 5.00;                  % minimum threshold
handles.par.stdmax = 50;                    % maximum threshold
handles.par.max_spk = inf;                  % max. # of spikes before starting templ. match.
handles.par.template_sdnum = 3;             % max radius of cluster in std devs.
handles.par.features = 'wav';               % choice of spike features (wav)
if strcmp(handles.par.features,'pca');      % number of inputs to the clustering for pca
    handles.par.inputs=3; 
end
handles.par.inputs = 10;                    % number of inputs to the clustering (def. 10)
handles.par.scales = 4;                     % scales for wavelet decomposition
handles.par.mintemp = 0;                    % minimum temperature
handles.par.maxtemp = 0.301;                % maximum temperature (0.201)
handles.par.tempstep = 0.01;                % temperature step
handles.par.num_temp = floor(...
(handles.par.maxtemp - ...
handles.par.mintemp)/handles.par.tempstep); % total number of temperatures 
handles.par.stab = 0.8;                     % stability condition for selecting the temperature
handles.par.SWCycles = 100;                 % number of montecarlo iterations (100)
handles.par.KNearNeighb = 11;               % number of nearest neighbors
handles.par.randomseed = 0;                 % if 0, random seed is taken as the clock value
%handles.par.randomseed = 147;              % If not 0, random seed   
handles.par.fname_in = 'tmp_data';          % temporary filename used as input for SPC
handles.par.fname = 'clusdata';             % filename for interaction with SPC
handles.par.min_clus_abs = 20;              % minimum cluster size (absolute value)
handles.par.min_clus_rel = 0.005;           % minimum cluster size (relative to the total nr. of spikes)
%handles.par.temp_plot = 'lin';               %temperature plot in linear scale
handles.par.temp_plot = 'log';              % temperature plot in log scale
handles.par.force_auto = 'y';               % automatically force membership if temp>3.
handles.par.max_spikes = 5000;              % maximum number of spikes to plot.
handles.par.sr = 30e3;                     % sampling frequency, in Hz.

% added parameters
handles.par.print_figures = 1; % should procCluWaveClus print figures about spike clusters?
handles.par.min_spikes = 100; % minimum number of spikes for sorting

%% % original parameters set in wave_clus of no use in analyze
% handles.par.detection = 'pos';              % type of threshold
% %handles.par.detection = 'neg';              % type of threshold
% % handles.par.detection = 'both';              % type of threshold
% handles.par.detect_fmin = 300;              % high pass filter for detection (default 300)
% handles.par.detect_fmax = 3000;             % low pass filter for detection (default 3000)
% handles.par.sort_fmin = 300;                % high pass filter for sorting (default 300)
% handles.par.sort_fmax = 3000;               % low pass filter for sorting (default 3000)
% handles.par.w_pre = 20;                       % number of pre-event data points stored
% handles.par.w_post = 44;                      % number of post-event data points stored
% handles.par.interpolation = 'y';            % interpolation for alignment
% handles.par.int_factor = 2;                 % interpolation factor
% handles.par.template_type = 'center';       % nn, center, ml, mahal
% handles.par.permut = 'y';                   % for selection of random 'par.max_spk' spikes before starting templ. match. 
% % handles.par.permut = 'n';                 % for selection of the first 'par.max_spk' spikes before starting templ. match.
