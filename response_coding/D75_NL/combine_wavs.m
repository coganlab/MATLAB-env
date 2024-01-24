% rename block wavs to block1.wav, block2.wav, etc.
big_wav = [];
for d = 1:10
    if exist(sprintf('block%d.wav', d), 'file')
        [aud,Fs] = audioread(sprintf('block%d.wav', d));
        if d == 1
            lastFs = Fs;
        else
            assert(lastFs==Fs);
        end
        block_wav_onsets(d,1) = length(big_wav) + 1;
        block_wav_onsets(d,2) = Fs;
        big_wav = cat(1, big_wav, aud, zeros(10*Fs,1));
    end
end

audiowrite('allblocks.wav', big_wav, Fs);
save('block_wav_onsets', 'block_wav_onsets');