%  ntools_procCleanComedi_Audio processes ieeg file to give line-noise-filtered files
%
%  Inputs:  	recording_filename_root  Recording prefix or numbers
%
%
function ntools_procCleanComedi_Audio(recording_filename_root)

    global experiment

    recording_filename_root = make_filename_root(recording_filename_root); %removes suffix if necess

    FS = experiment.processing.comedi.audio.sample_rate;
    CH = 1;
    
    fks = zeros(length(experiment.processing.comedi.audio.linefilter.frequencies),2);
    for i = 1:length(experiment.processing.comedi.audio.linefilter.frequencies)
        fks(i,:) = experiment.processing.comedi.audio.linefilter.frequencies(i) + [-100,100]; 
    end

    tic
    T = 0.2;

    if isfile([recording_filename_root '.comedi_audio.dat'])

        comedi_audio_fid = fopen([recording_filename_root '.comedi_audio.dat'], 'r');
        clean_fid = fopen([recording_filename_root '.cleancomedi_audio.dat'], 'w');

        chk=1; N=0;
        while(chk)
            tic
            N = N+1;
            disp(['Clean Comedi_Audio: Loop ' num2str(N)]);
            data = fread(comedi_audio_fid,[CH,FS*T],[experiment.processing.comedi.audio.sample_format '=>single']);
            clean = zeros(CH,size(data,2),'single');
            if(size(data,2))
                for ii = 1:size(data,1)
                    cl = linefilter(data(ii,:),[min(T,size(data,2)./FS),10],FS,fks);
                    clean(ii,1:size(data,2)) = cl;
                end
                fwrite(clean_fid,clean,'float');
            end
            if (size(data,2) < FS*T); chk = 0; end
            toc
        end
        fclose(comedi_audio_fid);
        fclose(clean_fid);
    else
        disp('No comedi_audio file found.  Skipping.')
    end
end
