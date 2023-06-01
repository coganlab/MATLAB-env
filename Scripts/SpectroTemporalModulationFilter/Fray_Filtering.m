[y fs]=audioread(['H:\Box Sync\CoganLab\Scripts\Music\The Fray - How to Save a Life (New Video Version).mp3']);
[p q]=rat(16000/fs);
signalA=resample(y,p,q);
Fs=16000;
signal=mean(signalA(1:Fs*30,:),2);
%CB_filter='gauss';

[TFout] = STM_CreateTF(signal,Fs);

[MS] = STM_Filter_Mod(TFout);

   figure;imagesc(MS.x_axis,MS.y_axis,log(MS.orig_MS)); axis xy;
 figure;imagesc(MS.x_axis,MS.y_axis(fix(length(MS.y_axis)/2+1):end),log(MS.orig_MS(fix(length(MS.y_axis)/2+1):end,:))); axis xy;
% 



 MStime_2 = STM_Filter_Mod(TFout,2);
 MSspect_19 = STM_Filter_Mod(TFout,[],0.19);
 
 MStime_4 = STM_Filter_Mod(TFout,4);
 MSspect_56 = STM_Filter_Mod(TFout,[],0.56);
 
 MStime_6 = STM_Filter_Mod(TFout,6);
 MSspect_93 = STM_Filter_Mod(TFout,[],0.93);
 
 MStime_8 = STM_Filter_Mod(TFout,8);
 MSspect_140 = STM_Filter_Mod(TFout,[],1.4);
 
 MStime_16 = STM_Filter_Mod(TFout,16);
 MSspect_500 = STM_Filter_Mod(TFout,[],5);
 
 inp=MSspect_140;
 figure;subplot(2,1,1);imagesc(inp.x_axis,inp.y_axis(fix(length(inp.y_axis)/2+1):end),log(inp.orig_MS(fix(length(inp.y_axis)/2+1):end,:))); axis xy;
 subplot(2,1,2);imagesc(inp.x_axis,inp.y_axis(fix(length(inp.y_axis)/2+1):end),log(inp.new_MS(fix(length(inp.y_axis)/2+1):end,:))); axis xy;

%       imagesc(MS.new_TF); axis xy;


[Recon_MStime_2, newTF,TFreference] = STM_Invert_Spectrum(MStime_2);
sFact_time2=max(Recon_MStime_2)./max(signal);
audiowrite('Fray_Test_MSTime_2.wav',Recon_MStime_2./sFact_time2',Fs);

[Recon_MSspect_19, newTF2,TFreference2] = STM_Invert_Spectrum(MSspect_19);
sFact_spect19=max(Recon_MSspect_19)./max(signal);
audiowrite('Fray_Test_MSSpect_19.wav',Recon_MSspect19./sFact_spec19',Fs);

[Recon_MStime_4, newTF,TFreference] = STM_Invert_Spectrum(MStime_4);
sFact_time4=max(Recon_MStime_4)./max(signal);
audiowrite('Fray_Test_MSTime_4.wav',Recon_MStime_4./sFact_time4',Fs);

[Recon_MSspect_56, newTF2,TFreference2] = STM_Invert_Spectrum(MSspect_56);
sFact_spect56=max(Recon_MSspect_56)./max(signal);
audiowrite('Fray_Test_MSSpect_56.wav',Recon_MSspect_56./sFact_spect56',Fs);

[Recon_MStime_6, newTF,TFreference] = STM_Invert_Spectrum(MStime_6);
sFact_time6=max(Recon_MStime_6)./max(signal);
audiowrite('Fray_Test_MSTime_6.wav',Recon_MStime_6./sFact_time6',Fs);

[Recon_MSspect_93, newTF2,TFreference2] = STM_Invert_Spectrum(MSspect_93);
sFact_spect93=max(Recon_MSspect_93)./max(signal);
audiowrite('Fray_Test_MSSpect_93.wav',Recon_MSspect_93./sFact_spect93',Fs);

[Recon_MStime_8, newTF,TFreference] = STM_Invert_Spectrum(MStime_8);
sFact_time8=max(Recon_MStime_8)./max(signal);
audiowrite('Fray_Test_MSTime_8.wav',Recon_MStime_8./sFact_time8',Fs);

[Recon_MSspect_140, newTF2,TFreference2] = STM_Invert_Spectrum(MSspect_140);
sFact_spect140=max(Recon_MSspect_140)./max(signal);
audiowrite('Fray_Test_MSSpect_140.wav',Recon_MSspect_140./sFact_spect140',Fs);

[Recon_MStime_16, newTF,TFreference] = STM_Invert_Spectrum(MStime_16);
sFact_time16=max(Recon_MStime_16)./max(signal);
audiowrite('Fray_Test_MSTime_16.wav',Recon_MStime_16./sFact_time16',Fs);

[Recon_MSspect_500, newTF2,TFreference2] = STM_Invert_Spectrum(MSspect_500);
sFact_spect500=max(Recon_MSspect_500)./max(signal);
audiowrite('Fray_Test_MSSpect_500.wav',Recon_MSspect_500./sFact_spect500',Fs);
