function Video = loadSessVideo(Sess)
%
%  Video = loadSessVideo(Sess)
%


Task = sessBehaviorTask(Sess);

switch Task
    case {'Powerwand_VR_Front'}
        VideoFile = 'Front.avi';
    case{'Powerwand_VR_Lateral'}
        VideoFile = 'Lateral.avi';
    case{'Powerwand_VR_Subjective'}
        VideoFile = 'POV.avi';
end

VideoObj = mmreader(VideoFile);
Video = read(VideoObj);
