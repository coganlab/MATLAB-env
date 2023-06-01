function animateMarkers2D(x,y,z)
% Alternate calling conventions:
% animateMarkers(path,rec) if the data has not already been loaded
% animateMarkers(spikeCounts,position,velocity) if the data has already
%   been loaded, binned and cleaned
if nargin == 2
    [s,c,~,n] = loadMarkers(x,y);
else
    s = x;
    c = y;
    n = z;
end

cx = c(:,1:3:size(c,2));
cy = c(:,2:3:size(c,2));
cz = c(:,3:3:size(c,2));
xmin = min(cx(~isinf(cx(:,1:n))));
xmax = max(cx(~isinf(cx(:,1:n))));
ymin = min(cy(~isinf(cy(:,1:n))));
ymax = max(cy(~isinf(cy(:,1:n))));
zmin = min(cz(~isinf(cz(:,1:n))));
zmax = max(cz(~isinf(cz(:,1:n))));
cmin = 0;
cmax = max(max(s));

winsize = get(gcf,'Position');
winsize(1:2) = [0 0];
nframes = size(c,1);
A = moviein(nframes,gcf,winsize);
set(gcf,'NextPlot','replacechildren');
for t = 1:size(c,1)
    subplot(2,2,1)
    scatter(cx(t,:),cy(t,:),10,[ones(n,1);0.5*ones(size(cy,2)-n,1)])
    axis([xmin xmax ymin ymax])
    axis square, grid on
    title(['t = ' int2str(floor(t/20)) '.' int2str(floor(mod(t,20)/2)) int2str(mod(t,2)*5) ' s'])
    xlabel('x position'), ylabel('y position')
    
    subplot(2,2,2)
    scatter(cx(t,:),cz(t,:),10,[ones(n,1);0.5*ones(size(cy,2)-n,1)])
    axis([xmin xmax zmin zmax])
    axis square, grid on
    xlabel('x position'), ylabel('z position')

    subplot(2,2,3)
    scatter(cz(t,:),cy(t,:),10,[ones(n,1);0.5*ones(size(cy,2)-n,1)])
    axis([zmin zmax ymin ymax])
    axis square, grid on
    xlabel('y position'), ylabel('z position')
    
    subplot(2,2,4)
    image(reshape(s(t,33:64),4,8))
    axis image
    caxis([cmin cmax])
    title('Left PMd')
    drawnow
    A(:,t) = getframe(gcf,winsize);
    pause(0.01)
end
disp('done')