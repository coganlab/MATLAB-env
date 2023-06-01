function format = getFileFormat(acquisition_type)
% GETFILEFORMAT returns file format for specified hardware
%
%     ACQUISITION_TYPE - String - hardware type e.g. 'Broker'
%

global experiment Rec

if ~isempty(experiment)
    acquisition = experiment.hardware.acquisition;
    acquisitiontype = cell(1,length(acquisition));
    [acquisitiontype{:}] = deal(acquisition.type);
    hardware = find(ismember(acquisitiontype,acquisition_type));
    if(isempty(hardware))
        hardware = 1;
    end
    format = acquisition(hardware).data_format;
else
    disp('No experiment variable')
     format = Rec.BinaryDataFormat;
end
