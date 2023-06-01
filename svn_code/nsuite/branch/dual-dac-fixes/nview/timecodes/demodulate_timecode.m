%
% demodulate_timecode(data, sr)
%
% takes analog data generated by modulate_timecode
% and demodulates the 32 bit integer that was
% encoded.
%
% example:
%
% myint = demodulate_timecode(audiobuf, 44100);
%
% note1: the passed in audiobuf must contain only
% one timecode tone.  if two are in there, the
% results will be a logical AND of the two values.
%
% note2: the same value for frequency spacing must
% be used at modulation and demodulation time.
% (mult in modulate_timecode() at modulate time
% must be the same used in demodulate_timecode
% at demodulate time
%
function ret=demodulate_timecode(data,sr)

% space in hz between indicator frequencies
mult = 64;
%sr = 44100;

% take fft, get magnitude, and cut symmetric
% fft in half, as we only care about +ive f
spec = fft(data);
spec = spec(1:ceil(length(spec)/2));
spec = abs(spec);

ret = 0;

% if power at f > 10*mean, consider the freq present
%avg = mean(spec);
% avg=0;
% for i=1:32
%     avg = ((i-1)*avg + spec((round(i*mult*length(data)./sr)-(mult/2)))/i;
% end
avg = mean(spec);

for i=1:32
    if (spec(round(i*mult*length(data)/sr)+1)>10^1*avg)
        ret = ret + 2^(i-1);
        display(['Freq: ' num2str(i*mult) ' exp: ' num2str(i-1)]);
    end
end
%ret = spec;        