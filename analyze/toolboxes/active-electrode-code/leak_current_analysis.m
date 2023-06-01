close all

dateString = datestr(now, 29);  % get date in yyyy-mm-dd form for output folder
mkdir([info.location,'\Figures ',dateString]);

figure
imagesc(reshape(mean(data,2),numRow,numChan))
titleStr = 'Average DC value colormap (21st column BNC)';
title(titleStr);
colorbar
fileString = [info.location,'\Figures ',dateString,'\',info.name,'_',titleStr,'.fig'];
saveas(gcf, fileString, 'fig')

figure
imagesc(reshape(mean(data(1:numRow*numCol,:),2),numRow,numCol))
titleStr = 'Average DC value colormap';
title(titleStr);
colorbar
fileString = [info.location,'\Figures ',dateString,'\',info.name,'_',titleStr,'.fig'];
saveas(gcf, fileString, 'fig')


figure
plot(mean(data(361:378,:),2))
titleStr = 'Average DC value - BNC channel';
title(titleStr)
xlabel('Row')
fileString = [info.location,'\Figures ',dateString,'\',info.name,'_',titleStr,'.fig'];
saveas(gcf, fileString, 'fig')

