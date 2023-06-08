function IMG = maskimage(X,mask,clim,colmap);
%
% IMG = maskimage(X,mask,clim,colmap);
%
% creates an image plot of matrix X masked with mask. All values in X whos
% corresponding value in mask is 1 will appear fully saturated while all
% values in X whos corresponding value in mask is 0 will appear dark. clim
% is a two element vector specifying the colorrange within the image.
%
% jet,hsv,hot,cool,spring,summer,autumn,winter,gray,bone,copper,pink,lines

if nargin<4
    colmap = 'jet';
end
if nargin < 3 || isempty(clim)
    clim = [-prctile(abs(X(:)),99) prctile(abs(X(:)),99)];
end
if nargin <2 || isempty(mask)
    mask = ones(size(X));
end

figure('Visible','off')
colormap(colmap)
cm = colormap;
colormap('gray')
cm2 = colormap;
close
nstep = size(cm,1);

% high resolution
for irgb=1:3
   tmp1(:,irgb)=interp1(1:nstep,cm(:,irgb),1:nstep/1000:nstep); 
   tmp2(:,irgb)=interp1(1:nstep,cm2(:,irgb),1:nstep/1000:nstep); 
end
nstep = size(tmp1,1);

cm=[tmp1;tmp2];
clear tmp1 tmp2

vrange = linspace(clim(1),clim(2),size(cm,1)./2);
vrange_cb = [vrange vrange];
vrange_cb=round(vrange_cb*100)/100;

IMG = zeros(size(X,1), size(X,2),3);
for iX = 1:size(X,1)
    for iY = 1:size(X,2)
        idx = find(abs(vrange-X(iX,iY))==min(abs(vrange-X(iX,iY))));
       if mask(iX,iY) == 1
           IMG(iX,iY,:) = reshape(cm(idx,:),[1 1 3]);
       else
           IMG(iX,iY,:) = reshape(cm(idx+nstep,:),[1 1 3]);
       end
    end
end
if nargout == 0
    image(IMG);
    colormap(cm)
    h=colorbar;
    set(h,'Ytick',[1 floor(nstep/4):floor(nstep/4):nstep*2]);
    set(h,'YtickLabel',vrange_cb([1 floor(nstep/4):floor(nstep/4):nstep*2]))
end
    
