function [playbackdevId,capturedevId] = getDevices

devices = PsychPortAudio('getdevices');

playbackdevId=[];
for iD=1:length(devices);
    if contains(devices(iD).DeviceName,'DigiHug') && devices(iD).DefaultSampleRate==44100
        playbackdevId = devices(iD).DeviceIndex;
    end
end
if isempty(playbackdevId)
    display('Could Not Find playbackdevID')
end

capturedevId=[];
for iD=1:length(devices)
    if contains(devices(iD).DeviceName,'USB Audio CODEC') && devices(iD).DefaultSampleRate==44100
        capturedevId=devices(iD).DeviceIndex;
    end
end
if isempty(capturedevId)
    display('Could Not Find capturedevID')
end

