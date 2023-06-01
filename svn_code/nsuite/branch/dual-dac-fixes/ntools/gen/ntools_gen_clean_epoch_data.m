%  epoch_data = ntools_gen_clean_epoch_data(recording, ['channels', wh_channels_to_keep], ['sfreq', new_samp_rate], ['max_epochs', max_epochs])
%
%  Generate an epoch_data data structure from a recording data_structure
%
%  Parameters:
%       recording: recording structure
%
%  Optional keyword parameters:
%       channels: which channels to keep (default: all)
%       sfreq: new sampling rate of epoch_data (default: same as file)
%       max_epochs: max num epochs (default: no limit)
%
%
%  Generate an epoch_data data structure from a recording data_structure
%  for cleanieeg file
%
%  Example:
%    epoch_data = ntools_gen_clean_epoch_data(recording, 'channels', 1:128, 'sfreq', 800)
%    % use only the first 128 channels, and downsample to 800 Hz

function epoch_data = ntools_gen_clean_epoch_data(recording, varargin)
    epoch_data = ntools_gen_epoch_data('cleanieeg', recording, varargin{:});
end
