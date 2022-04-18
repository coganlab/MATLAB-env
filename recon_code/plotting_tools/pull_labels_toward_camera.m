function pull_labels_toward_camera(handle_labels, magnitude)
% handle_labels is scatter handle
if nargin < 2
    magnitude = 10; % mm
end

for e = 1:numel(handle_labels)
    newpoint = campos - handle_labels(e).Position;
    newpoint = newpoint/norm(newpoint);
    newpoint = newpoint * magnitude;
    handle_labels(e).Position = handle_labels(e).Position + newpoint;
end

drawnow update;
end