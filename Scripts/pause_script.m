function to_exit = pause_script(window)

ts = Screen('TextSize', window); % get current text size and reset it later
rk = RestrictKeysForKbCheck([]);
Screen('TextSize', window, 50);
to_exit = 0;
[~,secs, keypressed] = KbCheck();
escNum = find(strcmp(KbName(1:255),'ESCAPE'));
eNum = find(strcmp(KbName(1:255),'e'));
if keypressed(escNum) > 0 %keypressed(27)
    DrawFormattedText(window, 'Pause, press ESC to continue, E to exit task', 'center', 'center', []);
    Screen('Flip', window);
    KbReleaseWait();
    while 1
        [~,secs, keypressed] = KbCheck();
%         disp(find(keypressed));
        if keypressed(escNum) > 0 || keypressed(eNum) > 0
            if keypressed(eNum) > 0
                to_exit = 1;
            end
            Screen('Flip', window);
            WaitSecs(.5);
            break;
        end
    end
end
Screen('TextSize', window, ts);
RestrictKeysForKbCheck(rk);