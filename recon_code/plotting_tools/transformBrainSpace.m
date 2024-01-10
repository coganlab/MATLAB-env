function trgSpaceAligned = transformBrainSpace(srcSpace,trgSpace)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
trgSpaceAligned = trgSpace;
sourceCloud = pointCloud(srcSpace.vert);
targetCloud = pointCloud(trgSpace.vert);

downsampledSourceCloud = pcdownsample(sourceCloud, 'gridAverage', 5);  % Adjust as needed
downsampledTargetCloud = pcdownsample(targetCloud, 'gridAverage', 5);  % Adjust as needed

% Use the Iterative Closest Point (ICP) algorithm
tform = pcregistericp(downsampledTargetCloud, downsampledSourceCloud,'MaxIterations',100);

% Apply the computed transformation to the entire pial brain mesh
trgSpaceAligned.vert = tform.transformPointsForward(trgSpace.vert);

% Display the transformed pial brain mesh
figure;
trisurf(srcSpace.tri, srcSpace.vert(:, 1), srcSpace.vert(:, 2), srcSpace.vert(:, 3), 'EdgeColor', 'none');
hold on;
trisurf(trgSpaceAligned.tri, trgSpaceAligned.vert(:, 1), trgSpaceAligned.vert(:, 2), trgSpaceAligned.vert(:, 3), 'EdgeColor', 'none', 'FaceAlpha', 0.5);


axis equal;
view(3);


end