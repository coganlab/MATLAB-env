%%%%%%%%%%%%%% Big box %%%%%%%%%%%%%%%%%%%%%%

bigbox = zeros(8*numRow+8, 8 * numCol+8);
frame = 1;
for i = 1:8
    % create big box plot
    y = ((ceil(i / 8)-1)*(numRow+1))+1;
    x = (mod(i-1,8)*(numCol+1))+1;
    bigbox(y:y+numRow-1,x:x+numCol-1) = data(:,:,frame);
    frame = frame + 7;
end

%%%%%%% Image of 64 frames of video
figure(2)
imagesc(bigbox,[minValV maxValV])
title(strcat('start   ',' ',num2str(startSec),' stop  ', ' ',num2str(startSec+64/Fs)))
colorbar

%%%%%%%%%%%%%%%%%