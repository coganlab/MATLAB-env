function RecDuration = expRecDuration(experiment, day, rec)
%
%  RecDuration = expRecDuration(experiment, day, rec)
%
%   RecDuration = Scalar.  Duration of recording in units of milliseconds
%
disp('Inside expRecDuration')

global MONKEYDIR

sys = experiment.hardware.microdrive(1).name;
sample_rate = experiment.hardware.acquisition.samplingrate;

switch experiment.hardware.acquisition(1).data_format
case {'float'}
  sample_size = 4;
case {'ushort','short','int16'}
  sample_size = 2;
end

nElectrode= length(experiment.hardware.microdrive(1).electrodes);

Microdrive = 1;

ChannelCount = 0;
for iElectrode = 1:nElectrode
    elec = experiment.hardware.microdrive(Microdrive).electrodes(iElectrode);
    if isfield(elec,'numContacts')
        NumContacts = elec.numContacts;
    else
        NumContacts = 1;
    end
    ChannelCount = ChannelCount + NumContacts;
end

FileInfo = dir([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.raw.dat']);
FileSize = FileInfo.bytes;
RecDuration = FileSize./sample_size./sample_rate./ChannelCount.*1e3;
