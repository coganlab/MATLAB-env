function PostCopyVizData(day)
%This copies viz.ev.txt files from sas1 WorldViz folders and TRC files from pesaranlab/mocap_data into corresponding sas1
%rec folders. It also runs procMocapFile.
%

global MONKEYDIR
cd ([MONKEYDIR '/' day])


recs = dir('0*');


for iRec = 1:length(recs)
    dest_rec = recs(iRec).name;
    mocap_rec = num2str(str2num(dest_rec));
    
    % copy vizard file
    if ~exist([MONKEYDIR '/' day '/' dest_rec '/rec' dest_rec '.viz.ev.txt' ]) & exist([MONKEYDIR '/' day '/WorldViz/rec' dest_rec '.viz.ev.txt'])
        copyfile([MONKEYDIR '/' day '/WorldViz/rec' dest_rec '.viz.ev.txt'],[MONKEYDIR '/' day '/' dest_rec])
%     else
%         continue
    end
    
    
    % copy mocap file
    dest_directory=([MONKEYDIR '/' day '/' dest_rec '/rec' dest_rec '.Body.mocap.trc' ]);
    mocap_file=(['/mnt/pesaranlab/mocap_data/Capture_Data/Calvin_PPC_SC32_Mocap/' day '/rec' mocap_rec '.trc']);
    cd ([MONKEYDIR '/' day '/' dest_rec ]);
    if ~exist(['rec' dest_rec '.Body.mocap.trc']) & exist(mocap_file)
        copyfile(mocap_file,dest_directory)
    end
    
    if exist(['rec' dest_rec '.Body.mocap.trc']) 
    procMocapFile(day,dest_rec);
    end
end