function [shand]=ntools_elec_plotSpheres(spheresX, spheresY, spheresZ, spheresRadius,varargin)

% spheresX = [0 0 0 0 2 2 2 2];
% spheresY = [0 0 2 2 0 0 2 2];
% spheresZ = [0 2 0 2 0 2 0 2];
% spheresRadius = 1;
% spheresRadius = [1 1 1 1 1 1 1 1];
% col='b';

if nargin>4,
    col=varargin{:};
end

spheresRadius = ones(length(spheresX),1).*spheresRadius;
% set up unit sphere information
numSphereFaces = 25;
[unitSphereX, unitSphereY, unitSphereZ] = sphere(numSphereFaces);

% set up basic plot
%figure
%hold on

sphereCount = length(spheresRadius);

% for each given sphere, shift the scaled unit sphere by the
% location of the sphere and plot
for i=1:sphereCount
sphereX = spheresX(i) + unitSphereX*spheresRadius(i);
sphereY = spheresY(i) + unitSphereY*spheresRadius(i);
sphereZ = spheresZ(i) + unitSphereZ*spheresRadius(i);
%shand=surface(sphereX, sphereY, sphereZ,'FaceColor',col,'EdgeColor',col,'Tag','btq_sphere');
shand=surface(sphereX, sphereY, sphereZ,'FaceColor',col,'EdgeColor','none','AmbientStrength',0.7);
end
