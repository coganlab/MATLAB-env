
close all
clear all


row = 16;
col = 16;

fps = 30;
WhiteTime = .1;
BlankTime = 0.008;
numframes = 50;

size = row*col;
idx = randperm(size);
idx = idx(1:numframes);
mov = zeros(size,numframes);

for i = 1:numframes
    mov(idx(i),i) = 1;
end

% create figure
figure(1)
close(1)
f1 = figure('color','white');

mov = reshape(mov, row, col, numframes);

frameNo = 1;

greyFrame = zeros(row,col);

frameTime = 1 / fps;


repeatWhite = round (WhiteTime / frameTime);
repeatBlank = round (BlankTime / frameTime);

for i = 1:numframes
    
    imagesc(mov(:,:,i),[-1 1])
    colormap(gray)
    axis image;
    set(gca,'XTick',[]);
    set(gca,'YTick',[]);
    
    
    for j = 1:repeatWhite
        M(frameNo) = getframe;
        frameNo = frameNo + 1;
    end
    
    for j = 1:repeatBlank
        imagesc(greyFrame,[-1 1])
        colormap(gray)
        axis image;
        set(gca,'XTick',[]);
        set(gca,'YTick',[]);
        M(frameNo) = getframe;
        frameNo = frameNo + 1;
    end
    
end


movie2avi(M, '2dsparsenoise.avi', 'FPS', fps);