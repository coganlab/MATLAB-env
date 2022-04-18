function gca_playsound(lpr_object, frequency)
% left click to set begin point
% right click to set end point
% audio will playback between two points

if nargin < 2
    frequency = 2000;
end
    
ax = gca;
ax.UserData.frequency = frequency;
f = gcf;

if nargin > 0 && ~isempty(lpr_object)
    ax.UserData.flag_lpr = 1;
    ax.UserData.lpr_y = lpr_object.y;
    ax.UserData.lpr_x = lpr_object.x;
else
    ax.UserData.flag_lpr = 0;
end

ax.UserData.audio = cell(1,9);
idx = 1;

for a = 1:numel(ax.Children)
    if strcmp(ax.Children(a).Type, 'line')
        ax.Children(a).HitTest = 'off';
        ax.UserData.audio{1,idx} = ax.Children(a);
        idx = idx + 1;
    end
end
ax.UserData.audio(cellfun(@isempty, ax.UserData.audio)) = [];

ax.UserData.active_audio = 1;

hax = axes('position', [0, 0, .05 .05]);
hax.Color = ax.UserData.audio{ax.UserData.active_audio}.Color;
% figure('position', [0 0 100 100], 'menubar', 'none', 'toolbar', 'none');
% hax = axes('position', [0 0 1 1], 'units', 'normalized', 'color', ax.UserData.audio{ax.UserData.active_audio}.Color);




ax.UserData.clicks = [Inf Inf];
ax.ButtonDownFcn = @button_click;

f.UserData.ax = ax;
register_KeyPressFcn(f, 'KeyPressFcn', @key_press);
f.UserData.hax = hax;


ax.UserData.linebeg = line(ax, 1,1, 'color', 'r');
ax.UserData.lineend = line(ax, 1,1, 'color', 'g');
ax.UserData.linebeg.HitTest = 'off';
ax.UserData.lineend.HitTest = 'off';

axes(ax);
end
    function button_click(ax,event)
        if event.Button == 1
            eip = event.IntersectionPoint(1);

            fprintf('%f\n', eip);
            ax.UserData.clicks(1) = eip;
            ax.UserData.linebeg.XData = [eip eip];
            ax.UserData.linebeg.YData = ax.YLim;
        elseif event.Button == 3
            eip = event.IntersectionPoint(1);
            fprintf('%f\n', eip);
            ax.UserData.clicks(2) = eip;
            ax.UserData.lineend.XData = [eip eip];
            ax.UserData.lineend.YData = ax.YLim;
            drawnow update;
            if ax.UserData.clicks(2) > ax.UserData.clicks(1)
                playsound(ax);
            else
                fprintf('set begin point first by left clicking\n');
            end
        end
    end
    
    function key_press(fig, event)
    if ismember(event.Character, '123456789')
        keynum = str2double(event.Character);
        fax = fig.UserData.ax;
        if keynum <= numel(fax.UserData.audio)
            fax.UserData.active_audio = keynum;
            
            fig.UserData.hax.Color = fax.UserData.audio{fax.UserData.active_audio}.Color;
        end
    end
    end
    
    function playsound(ax)
    aaudio = ax.UserData.active_audio;
    xlimit = floor(ax.UserData.clicks);

    if ax.UserData.flag_lpr
        mask = ax.UserData.lpr_x{aaudio} >= xlimit(1) & ax.UserData.lpr_x{aaudio} <= xlimit(2);
        tone = rescale_matrix(ax.UserData.lpr_y{aaudio}(mask), -1, 1);
    else
        mask = ax.UserData.audio{1,aaudio}.XData >= xlimit(1) & ax.UserData.audio{1,aaudio}.XData <= xlimit(2);
        tone = rescale_matrix(ax.UserData.audio{1,aaudio}.YData(mask), -1, 1);
    end
    if (length(tone) / ax.UserData.frequency) > 20
        warning('sound is over 20 seconds, was this a mistake?');
    else
        tone = resample(tone, 44100, ax.UserData.frequency);
    %         soundsc(ax.Children(a).XData(xlimit(1):xlimit(2)), 2000);
    

        ap = audioplayer(tone, 44100);
        playblocking(ap);
    end
%     InitializePsychSound(0);
%     pahandle = PsychPortAudio('Open', 1, 1, 1, 44100, 1);
%     duration = length(tone)/44100;
%     
%     %         while ~KbCheck()
%     PsychPortAudio('FillBuffer', pahandle, tone);
%     PsychPortAudio('Start', pahandle, 1, 0, 1);
%     WaitSecs(duration + 0.5);
%     %         end
%     PsychPortAudio('close');
    
    end