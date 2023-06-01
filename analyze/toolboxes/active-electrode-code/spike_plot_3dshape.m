

close all

start = 269.5;
stop = 270;
v = reshape(data(1:numRow*numCol,round(Fs*start):round(Fs*stop)),numRow,numCol,round(Fs*stop) - round(Fs * start) + 1);

xAvg = data(1:numRow*numCol,round(Fs*start):round(Fs*stop));
xAvg = mean(xAvg,1);
figure
t = 0:1/Fs:(size(xAvg,2)-1)*1/Fs;
plot(t,xAvg)
%v = cat(3,  spikes(794,:,:),  spikes(795,:,:));
%v = reshape(v,numRow,numCol,size(v,3));

x = zeros(size(v));
y = zeros(size(v));
z = zeros(size(v));

x1 = 1:numCol;
x1 = repmat(x1,numRow,1);
y1 = numRow:-1:1;
y1 = repmat(y1,numCol,1)';


for i = 1:size(v,3)
x(:,:,i) = x1;
y(:,:,i) = y1;
z(:,:,i) = i * ones(size(y1));
end

figure
v = smooth3(v,'box',3);
p1 = patch(isosurface(v, 1e-3),'FaceColor','blue','EdgeColor','none');
%p2 = patch(isocaps(v), 'FaceColor','interp','EdgeColor','none');
isonormals(v,p1)
view(3); axis vis3d tight
camlight; 

set(gcf,'Renderer','zbuffer'); 
%lighting phong


% hpatch = patch(isosurface(x,y,z,v,1e-3));
% isonormals(x,y,z,v,hpatch)
% %set(hpatch,'FaceColor','red','EdgeColor','none')
% %daspect([1,4,4])
% %view([-65,20])
% axis tight
% camlight left; 




%     
% 
% z = 1:size(spikes,3);
% z = repmat(z,size(spikes,2),1);
% 
% 
% x = x(:);
% x = repmat(x,size(spikes,3),1);
% x = x(:);
% 
% 
% y = y(:);
% y = repmat(y,size(spikes,3),1);
% 
% data = spikes(73,:,:);
% data = data(:);
% 
% thresh = 1e-3;
% 
% data = data > thresh;
% 
% scale_factor = 100 / max(data);
% 
% data = data .* scale_factor;
% 
% data = data + 0.1;
% 
% scatter3(x,y,z,data,data,'filled')