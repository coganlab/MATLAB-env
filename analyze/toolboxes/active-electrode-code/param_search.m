

for j = 0.16:0.02:0.3
    for i = 1.2:0.02:1.3
    
    disp(['response_window_start (s): ' num2str(i)]);
    disp(['response_window_len   (s): ' num2str(j)]);
    disp(' ');
    iso = OrientationColormap(avg_eps, filename, numRow, numCol, numChan, Fs, i, i+j);
    pause
    end
end

