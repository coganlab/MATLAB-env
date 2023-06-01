function sample_rate = getSampleRate(acquisition_type)
% GETSAMPLERATE returns sample rate for specified hardware
%
%     ACQUISITION_TYPE - String - hardware type e.g. 'Broker' 
%  


    global experiment
    
    acquisition = experiment.hardware.acquisition;
    acquisitiontype = cell(1,length(acquisition));
    [acquisitiontype{:}] = deal(acquisition.type);  
    hardware = find(ismember(acquisitiontype,acquisition_type));  
    if(isempty(hardware))
        hardware = 1;
    end  
    sample_rate = acquisition(hardware).samplingrate;
    
end